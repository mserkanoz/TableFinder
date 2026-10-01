// TableFinder Cloud Functions: push notifications and seat bookkeeping.
// Runs next to the Firestore database (europe-west3) with admin access.

const { onDocumentCreated, onDocumentUpdated } = require('firebase-functions/v2/firestore');
const { setGlobalOptions, logger } = require('firebase-functions/v2');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

initializeApp();
setGlobalOptions({ region: 'europe-west3', maxInstances: 5 });
const db = getFirestore();

// Must match notification_channel_id in the Android app.
const CHANNEL_ID = 'tablefinder_default';

// Notification texts per kind and language. `a` holds names/titles.
const TEXTS = {
  chat: {
    tr: (a) => ({ title: a.from, body: a.text }),
    en: (a) => ({ title: a.from, body: a.text }),
    bg: (a) => ({ title: a.from, body: a.text }),
  },
  application: {
    tr: (a) => ({ title: 'Yeni başvuru', body: `${a.player}, "${a.game}" masana başvurdu.` }),
    en: (a) => ({ title: 'New application', body: `${a.player} applied to "${a.game}".` }),
    bg: (a) => ({ title: 'Нова кандидатура', body: `${a.player} кандидатства за "${a.game}".` }),
  },
  accepted: {
    tr: (a) => ({ title: 'Başvurun kabul edildi 🎉', body: `"${a.game}" masasına kabul edildin. DM'in iletişim notu artık açık.` }),
    en: (a) => ({ title: 'Application accepted 🎉', body: `You're in "${a.game}". The DM's contact note is now visible.` }),
    bg: (a) => ({ title: 'Кандидатурата ти е приета 🎉', body: `Приет/а си в "${a.game}". Бележката за контакт на DM вече е видима.` }),
  },
  rejected: {
    tr: (a) => ({ title: 'Başvurun hakkında', body: `"${a.game}" masasına yaptığın başvuru kabul edilmedi.` }),
    en: (a) => ({ title: 'About your application', body: `Your application to "${a.game}" wasn't accepted.` }),
    bg: (a) => ({ title: 'За кандидатурата ти', body: `Кандидатурата ти за "${a.game}" не беше приета.` }),
  },
  removed: {
    tr: (a) => ({ title: 'Masadan çıkarıldın', body: `"${a.game}" masasından çıkarıldın.` }),
    en: (a) => ({ title: 'Removed from a table', body: `You were removed from "${a.game}".` }),
    bg: (a) => ({ title: 'Отстранен/а от маса', body: `Беше отстранен/а от "${a.game}".` }),
  },
  left: {
    tr: (a) => ({ title: 'Bir oyuncu ayrıldı', body: `${a.player}, "${a.game}" masasından ayrıldı. Boş yer otomatik açıldı.` }),
    en: (a) => ({ title: 'A player left', body: `${a.player} left "${a.game}". The seat was reopened.` }),
    bg: (a) => ({ title: 'Играч напусна', body: `${a.player} напусна "${a.game}". Мястото е освободено отново.` }),
  },
  invite: {
    tr: (a) => ({ title: 'Masaya davet edildin 🎲', body: `${a.dm} seni "${a.game}" masasına davet etti.` }),
    en: (a) => ({ title: 'You were invited 🎲', body: `${a.dm} invited you to "${a.game}".` }),
    bg: (a) => ({ title: 'Получи покана 🎲', body: `${a.dm} те покани на "${a.game}".` }),
  },
};

const STALE_TOKEN_ERRORS = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
]);

/**
 * Sends a notification of `kind` to every registered device of `uid`, in each
 * device's language. `data` values must be strings; they tell the app which
 * screen to open. Tokens the devices no longer have are removed.
 */
async function notify(uid, kind, args, data) {
  const tokensRef = db.collection('users').doc(uid).collection('tokens');
  const snap = await tokensRef.get();
  if (snap.empty) return;

  const byLang = { tr: [], en: [], bg: [] };
  for (const doc of snap.docs) (byLang[doc.get('lang')] || byLang.tr).push(doc.id);

  for (const lang of Object.keys(byLang)) {
    const tokens = byLang[lang];
    if (tokens.length === 0) continue;
    const { title, body } = TEXTS[kind][lang](args);
    const res = await getMessaging().sendEachForMulticast({
      tokens,
      notification: { title, body },
      data: { type: kind, ...data },
      android: {
        priority: 'high',
        // One notification per chat / game that later ones replace.
        notification: { channelId: CHANNEL_ID, tag: data.chatId || `${kind}_${data.gameId || ''}` },
      },
    });
    const stale = tokens.filter((_, i) => {
      const r = res.responses[i];
      return !r.success && STALE_TOKEN_ERRORS.has(r.error && r.error.code);
    });
    await Promise.all(stale.map((t) => tokensRef.doc(t).delete()));
    if (res.failureCount > stale.length) {
      logger.warn('Some notifications failed', { uid, kind, failures: res.failureCount - stale.length });
    }
  }
}

const shorten = (text, max) => (text.length > max ? `${text.slice(0, max)}…` : text);

// 💬 New chat message -> the other member.
exports.onChatMessage = onDocumentCreated('chats/{chatId}/messages/{messageId}', async (event) => {
  const msg = event.data && event.data.data();
  if (!msg) return;
  const chat = (await db.collection('chats').doc(event.params.chatId).get()).data();
  if (!chat) return;
  const to = chat.members.find((m) => m !== msg.senderUid);
  if (!to || (chat.deletedUids || []).includes(to)) return;
  const from = (chat.nicknames && chat.nicknames[msg.senderUid]) || 'TableFinder';
  await notify(to, 'chat', { from, text: shorten(msg.text, 150) }, { chatId: event.params.chatId });
});

// 📩 New application -> the game's DM.
exports.onApplicationCreated = onDocumentCreated('games/{gameId}/applications/{uid}', async (event) => {
  const a = event.data && event.data.data();
  if (!a) return;
  await notify(a.gameOwnerUid, 'application', { player: a.applicantNickname, game: a.gameTitle },
    { gameId: event.params.gameId });
});

// Application status changes: re-apply, accept/reject/remove, an accepted player leaving.
exports.onApplicationUpdated = onDocumentUpdated('games/{gameId}/applications/{uid}', async (event) => {
  const before = event.data && event.data.before.data();
  const after = event.data && event.data.after.data();
  if (!before || !after || before.status === after.status) return;
  const gameId = event.params.gameId;
  const args = { player: after.applicantNickname, game: after.gameTitle };

  switch (after.status) {
    case 'pending': // re-applied after withdrawing
      return notify(after.gameOwnerUid, 'application', args, { gameId });
    case 'accepted':
    case 'rejected':
    case 'removed':
      return notify(after.applicantUid, after.status, args, { gameId });
    case 'withdrawn':
      if (before.status !== 'accepted') return;
      // The player gave up a seat they held: reopen it (the client can't, rules only let the DM edit the game).
      await freeSeat(gameId);
      return notify(after.gameOwnerUid, 'left', args, { gameId });
    default:
      return;
  }
});

async function freeSeat(gameId) {
  const ref = db.collection('games').doc(gameId);
  await db.runTransaction(async (tx) => {
    const game = await tx.get(ref);
    if (!game.exists) return;
    const g = game.data();
    tx.update(ref, {
      seatsOpen: Math.min(g.seatsTotal, (g.seatsOpen || 0) + 1),
      ...(g.status === 'full' ? { status: 'open' } : {}),
      updatedAt: FieldValue.serverTimestamp(),
    });
  });
}

// 🎲 Invitation -> the player.
exports.onInviteCreated = onDocumentCreated('invites/{inviteId}', async (event) => {
  const i = event.data && event.data.data();
  if (!i) return;
  await notify(i.playerUid, 'invite', { dm: i.dmNickname, game: i.gameTitle }, { gameId: i.gameId });
});
