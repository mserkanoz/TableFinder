import 'package:cloud_firestore/cloud_firestore.dart';

import '../games/game_listing.dart';
import '../profile/user_profile.dart';
import 'application.dart';

class ApplicationRepository {
  ApplicationRepository._();
  static final instance = ApplicationRepository._();

  final _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _ref(String gameId, String uid) =>
      _db.collection('games').doc(gameId).collection('applications').doc(uid);

  DocumentReference<Map<String, dynamic>> _gameRef(String gameId) => _db.collection('games').doc(gameId);

  List<GameApplication> _newestFirst(QuerySnapshot<Map<String, dynamic>> s) {
    final list = s.docs.map(GameApplication.fromDoc).toList();
    list.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
    return list;
  }

  /// The current user's application to [gameId], or null.
  Stream<GameApplication?> watchMine(String gameId, String uid) =>
      _ref(gameId, uid).snapshots().map((d) => d.exists ? GameApplication.fromDoc(d) : null);

  /// All of a player's applications (for "My applications").
  Stream<List<GameApplication>> watchByApplicant(String uid) => _db
      .collectionGroup('applications')
      .where('applicantUid', isEqualTo: uid)
      .snapshots()
      .map(_newestFirst);

  /// Applications to one game. Rules only allow this for the owner, and the
  /// query must say so explicitly.
  Stream<List<GameApplication>> watchForGame(GameListing game) => _gameRef(game.id!)
      .collection('applications')
      .where('gameOwnerUid', isEqualTo: game.ownerUid)
      .snapshots()
      .map(_newestFirst);

  /// Pending applications across all of a DM's games, counted per game.
  Stream<Map<String, int>> watchPendingCounts(String ownerUid) => _db
      .collectionGroup('applications')
      .where('gameOwnerUid', isEqualTo: ownerUid)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((s) {
        final counts = <String, int>{};
        for (final d in s.docs) {
          final id = d.data()['gameId'] as String;
          counts[id] = (counts[id] ?? 0) + 1;
        }
        return counts;
      });

  /// Applies, or re-applies after withdrawing.
  Future<void> apply(GameListing game, String uid, UserProfile profile, String message) async {
    final ref = _ref(game.id!, uid);
    final existing = await ref.get();
    if (existing.exists) {
      await ref.update({'status': 'pending', 'message': message, 'updatedAt': FieldValue.serverTimestamp()});
    } else {
      await ref.set({
        'gameId': game.id,
        'gameTitle': game.title,
        'gameOwnerUid': game.ownerUid,
        'applicantUid': uid,
        'applicantNickname': profile.nickname,
        'message': message,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> withdraw(String gameId, String uid) => _ref(gameId, uid)
      .update({'status': 'withdrawn', 'updatedAt': FieldValue.serverTimestamp()});

  /// Owner: accept a pending application and take one open seat.
  Future<void> accept(GameListing game, String applicantUid) async {
    final seats = (game.seatsOpen - 1).clamp(0, game.seatsTotal);
    final batch = _db.batch();
    batch.update(_ref(game.id!, applicantUid), {'status': 'accepted', 'updatedAt': FieldValue.serverTimestamp()});
    batch.update(_gameRef(game.id!), {
      'seatsOpen': seats,
      if (seats == 0 && game.status == 'open') 'status': 'full',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  /// Owner: reject a pending application, or remove an accepted player
  /// (which frees their seat and reopens a full table).
  Future<void> reject(GameListing game, GameApplication app) async {
    final batch = _db.batch();
    batch.update(_ref(game.id!, app.applicantUid), {'status': 'rejected', 'updatedAt': FieldValue.serverTimestamp()});
    if (app.isAccepted) {
      final seats = (game.seatsOpen + 1).clamp(0, game.seatsTotal);
      batch.update(_gameRef(game.id!), {
        'seatsOpen': seats,
        if (game.status == 'full') 'status': 'open',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
