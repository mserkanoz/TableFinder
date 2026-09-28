import 'package:cloud_firestore/cloud_firestore.dart';

import '../games/game_listing.dart';
import 'invite.dart';

class InviteRepository {
  InviteRepository._();
  static final instance = InviteRepository._();

  final _invites = FirebaseFirestore.instance.collection('invites');

  /// A player's pending invitations, newest first.
  Stream<List<Invite>> watchPendingFor(String playerUid) => _invites
      .where('playerUid', isEqualTo: playerUid)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((s) {
        final list = s.docs.map(Invite.fromDoc).toList();
        list.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        return list;
      });

  /// IDs of the DM's games this player has already been invited to.
  Stream<Set<String>> watchInvitedGameIds(String dmUid, String playerUid) => _invites
      .where('dmUid', isEqualTo: dmUid)
      .where('playerUid', isEqualTo: playerUid)
      .snapshots()
      .map((s) => s.docs.map((d) => d.data()['gameId'] as String).toSet());

  Future<void> invite(GameListing game, String dmNickname, String playerUid) {
    return _invites.doc(Invite.idFor(game.id!, playerUid)).set({
      'gameId': game.id,
      'gameTitle': game.title,
      'dmUid': game.ownerUid,
      'dmNickname': dmNickname,
      'playerUid': playerUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> dismiss(String inviteId) => _invites.doc(inviteId).update({'status': 'dismissed'});

  /// Called after the player applies; a missing invite is fine.
  Future<void> dismissIfInvited(String gameId, String playerUid) async {
    try {
      await dismiss(Invite.idFor(gameId, playerUid));
    } on FirebaseException {
      // No invite for this game (not-found / permission-denied): nothing to do.
    }
  }

  /// Removes all invitations to a game (when the DM deletes it).
  Future<void> deleteForGame(String gameId, String dmUid) async {
    final snap = await _invites.where('dmUid', isEqualTo: dmUid).where('gameId', isEqualTo: gameId).get();
    final batch = FirebaseFirestore.instance.batch();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }
}
