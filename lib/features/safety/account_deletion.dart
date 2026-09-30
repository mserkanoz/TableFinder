import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/auth_service.dart';
import '../chat/chat_repository.dart';
import '../games/game_repository.dart';
import '../notifications/push_service.dart';
import '../profile/nickname.dart';

/// Deletes everything the user owns, then their sign-in.
///
/// Chats are archived rather than deleted (see [ChatRepository.archiveAllFor]);
/// reports they filed are kept for moderation (users can't read them anyway).
class AccountDeletion {
  AccountDeletion._();

  /// Returns false if the user cancelled the Google confirmation.
  static Future<bool> deleteAccount(String uid) async {
    // Confirm first, so a cancelled sign-in never leaves a half-deleted account.
    if (!await AuthService.instance.reauthenticate()) return false;

    await PushService.instance.stop();
    final db = FirebaseFirestore.instance;

    // Games, with their applications, invitations and contact notes.
    final games = await db.collection('games').where('ownerUid', isEqualTo: uid).get();
    for (final g in games.docs) {
      await GameRepository.instance.delete(g.id, uid);
    }

    final batch = db.batch();
    final seekers = await db.collection('seekers').where('ownerUid', isEqualTo: uid).get();
    final myApps = await db.collectionGroup('applications').where('applicantUid', isEqualTo: uid).get();
    final invitesToMe = await db.collection('invites').where('playerUid', isEqualTo: uid).get();
    final invitesFromMe = await db.collection('invites').where('dmUid', isEqualTo: uid).get();
    final blocked = await db.collection('users').doc(uid).collection('blocked').get();
    final tokens = await db.collection('users').doc(uid).collection('tokens').get();
    for (final d in [
      ...seekers.docs,
      ...myApps.docs,
      ...invitesToMe.docs,
      ...invitesFromMe.docs,
      ...blocked.docs,
      ...tokens.docs,
    ]) {
      batch.delete(d.reference);
    }
    await batch.commit();

    // Chats are closed and kept for the other member, without this user's nickname.
    await ChatRepository.instance.archiveAllFor(uid);

    // Profile and nickname reservation go together (the rules require it).
    final user = await db.collection('users').doc(uid).get();
    final nickname = user.data()?['nickname'] as String?;
    final last = db.batch();
    if (nickname != null && isValidNickname(nickname)) {
      last.delete(db.collection('nicknames').doc(nicknameKey(nickname)));
    }
    last.delete(user.reference);
    await last.commit();

    await AuthService.instance.deleteCurrentUser();
    return true;
  }
}
