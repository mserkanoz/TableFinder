import 'package:cloud_firestore/cloud_firestore.dart';

import 'game_listing.dart';

/// Search filters; null means "any".
class GameFilters {
  const GameFilters({
    this.system,
    this.platform,
    this.cityCode,
    this.district,
    this.gameType,
    this.language,
    this.beginnerOnly = false,
    this.freeOnly = false,
  });

  final String? system;
  final String? platform;
  final int? cityCode;
  final String? district;
  final String? gameType;
  final String? language;
  final bool beginnerOnly;
  final bool freeOnly;
}

class GamePage {
  const GamePage(this.games, this.cursor, this.hasMore);

  final List<GameListing> games;
  final DocumentSnapshot<Map<String, dynamic>>? cursor;
  final bool hasMore;
}

class GameRepository {
  GameRepository._();
  static final instance = GameRepository._();

  static const pageSize = 20;

  final _games = FirebaseFirestore.instance.collection('games');

  DocumentReference<Map<String, dynamic>> _contactRef(String gameId) =>
      _games.doc(gameId).collection('private').doc('contact');

  /// The owner's listings, newest first (sorted locally to avoid an index).
  Stream<List<GameListing>> watchMine(String uid) =>
      _games.where('ownerUid', isEqualTo: uid).snapshots().map((s) {
        final list = s.docs.map(GameListing.fromDoc).toList();
        list.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        return list;
      });

  Stream<GameListing?> watch(String id) =>
      _games.doc(id).snapshots().map((d) => d.exists ? GameListing.fromDoc(d) : null);

  /// Open listings matching [f], newest first. Expired one-shots are dropped
  /// locally, so a page may hold fewer than [pageSize] games.
  Future<GamePage> search(GameFilters f, {DocumentSnapshot<Map<String, dynamic>>? after}) async {
    Query<Map<String, dynamic>> q = _games.where('status', isEqualTo: 'open');
    if (f.system != null) q = q.where('system', isEqualTo: f.system);
    if (f.platform != null) q = q.where('platform', isEqualTo: f.platform);
    if (f.cityCode != null) q = q.where('cityCode', isEqualTo: f.cityCode);
    if (f.district != null) q = q.where('district', isEqualTo: f.district);
    if (f.gameType != null) q = q.where('gameType', isEqualTo: f.gameType);
    if (f.language != null) q = q.where('language', isEqualTo: f.language);
    if (f.beginnerOnly) q = q.where('beginnerFriendly', isEqualTo: true);
    if (f.freeOnly) q = q.where('paid', isEqualTo: false);
    q = q.orderBy('createdAt', descending: true).limit(pageSize);
    if (after != null) q = q.startAfterDocument(after);

    final snap = await q.get();
    final games = snap.docs.map(GameListing.fromDoc).where((g) => !g.isExpired).toList();
    return GamePage(games, snap.docs.isEmpty ? after : snap.docs.last, snap.docs.length == pageSize);
  }

  /// Creates or updates a listing together with its private contact note.
  Future<void> save(GameListing game, String contactNote) async {
    final ref = game.id == null ? _games.doc() : _games.doc(game.id);
    final batch = FirebaseFirestore.instance.batch();
    batch.set(ref, {
      ...game.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (game.id == null) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    batch.set(_contactRef(ref.id), {'note': contactNote});
    await batch.commit();
  }

  Future<String> loadContactNote(String gameId) async {
    final doc = await _contactRef(gameId).get();
    return doc.data()?['note'] as String? ?? '';
  }

  Future<void> delete(String gameId) async {
    final batch = FirebaseFirestore.instance.batch();
    batch.delete(_contactRef(gameId));
    batch.delete(_games.doc(gameId));
    await batch.commit();
  }
}
