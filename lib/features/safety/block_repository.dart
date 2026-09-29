import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Users the current user has blocked, at `users/{uid}/blocked/{otherUid}`.
///
/// Blocking hides the other user's listings, LFG posts and invitations from
/// the blocker (client side), and the rules stop the blocked user from
/// applying to the blocker's games or inviting them.
class BlockRepository {
  BlockRepository._();
  static final instance = BlockRepository._();

  final _db = FirebaseFirestore.instance;

  /// Blocked user IDs of the signed-in user, kept live between [start] and [stop].
  final blocked = ValueNotifier<Set<String>>({});
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  String? _uid;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('blocked');

  void start(String uid) {
    if (_uid == uid) return;
    stop();
    _uid = uid;
    _sub = _col(uid).snapshots().listen((s) => blocked.value = s.docs.map((d) => d.id).toSet());
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
    _uid = null;
    // Called from a build method; notify listeners after the frame's build.
    Future.microtask(() => blocked.value = {});
  }

  bool isBlocked(String otherUid) => blocked.value.contains(otherUid);

  /// Blocked users with the nickname they had when blocked, for the list screen.
  Stream<List<({String uid, String nickname})>> watchList(String uid) => _col(uid).snapshots().map(
        (s) => [for (final d in s.docs) (uid: d.id, nickname: d.data()['nickname'] as String? ?? '')],
      );

  Future<void> block(String uid, String otherUid, String otherNickname) => _col(uid)
      .doc(otherUid)
      .set({'nickname': otherNickname, 'createdAt': FieldValue.serverTimestamp()});

  Future<void> unblock(String uid, String otherUid) => _col(uid).doc(otherUid).delete();
}
