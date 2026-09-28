import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/game_options.dart';
import 'seeker_post.dart';

/// DM-side search filters; null means "any".
class SeekerFilters {
  const SeekerFilters({this.system, this.platform, this.cityCode, this.district, this.language, this.experience});

  final String? system;
  final String? platform;
  final int? cityCode;
  final String? district;
  final String? language;
  final String? experience;
}

class SeekerPage {
  const SeekerPage(this.posts, this.cursor, this.hasMore);

  final List<SeekerPost> posts;
  final DocumentSnapshot<Map<String, dynamic>>? cursor;
  final bool hasMore;
}

class SeekerLimitException implements Exception {}

class SeekerRepository {
  SeekerRepository._();
  static final instance = SeekerRepository._();

  static const pageSize = 20;

  final _posts = FirebaseFirestore.instance.collection('seekers');

  Stream<List<SeekerPost>> watchMine(String uid) =>
      _posts.where('ownerUid', isEqualTo: uid).snapshots().map((s) {
        final list = s.docs.map(SeekerPost.fromDoc).toList();
        list.sort((a, b) => a.id!.compareTo(b.id!));
        return list;
      });

  Stream<SeekerPost?> watch(String id) =>
      _posts.doc(id).snapshots().map((d) => d.exists ? SeekerPost.fromDoc(d) : null);

  /// Open posts matching [f], newest first. Firestore allows one
  /// array-contains per query, so the first of system/platform/language is
  /// filtered on the server and the rest locally.
  Future<SeekerPage> search(SeekerFilters f, {DocumentSnapshot<Map<String, dynamic>>? after}) async {
    Query<Map<String, dynamic>> q = _posts.where('status', isEqualTo: 'open');
    final arrayFilters = <String, String?>{'systems': f.system, 'platforms': f.platform, 'languages': f.language};
    final serverArray = arrayFilters.entries.where((e) => e.value != null).firstOrNull;
    if (serverArray != null) q = q.where(serverArray.key, arrayContains: serverArray.value);
    if (f.cityCode != null) q = q.where('cityCode', isEqualTo: f.cityCode);
    if (f.district != null) q = q.where('district', isEqualTo: f.district);
    if (f.experience != null) q = q.where('experience', isEqualTo: f.experience);
    q = q.orderBy('createdAt', descending: true).limit(pageSize);
    if (after != null) q = q.startAfterDocument(after);

    final snap = await q.get();
    final posts = snap.docs.map(SeekerPost.fromDoc).where((p) {
      return (f.system == null || p.systems.contains(f.system)) &&
          (f.platform == null || p.platforms.contains(f.platform)) &&
          (f.language == null || p.languages.contains(f.language));
    }).toList();
    return SeekerPage(posts, snap.docs.isEmpty ? after : snap.docs.last, snap.docs.length == pageSize);
  }

  /// Creates a post in the owner's first free slot, or updates [post].
  /// Throws [SeekerLimitException] when all slots are taken.
  Future<void> save(SeekerPost post, {List<SeekerPost> existing = const []}) async {
    var id = post.id;
    if (id == null) {
      final used = existing.map((p) => p.id).toSet();
      id = [for (var i = 1; i <= maxSeekerPosts; i++) '${post.ownerUid}_$i']
          .where((slot) => !used.contains(slot))
          .firstOrNull;
      if (id == null) throw SeekerLimitException();
    }
    await _posts.doc(id).set({
      ...post.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (post.id == null) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> delete(String id) => _posts.doc(id).delete();
}
