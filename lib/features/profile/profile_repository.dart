import 'package:cloud_firestore/cloud_firestore.dart';

import 'nickname.dart';
import 'user_profile.dart';

class NicknameTakenException implements Exception {}

class ProfileRepository {
  ProfileRepository._();
  static final instance = ProfileRepository._();

  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');
  CollectionReference<Map<String, dynamic>> get _nicknames => _db.collection('nicknames');

  /// Raw snapshots, so callers can tell "no profile" apart from
  /// "not loaded from the server yet" (see [SnapshotMetadata.isFromCache]).
  Stream<DocumentSnapshot<Map<String, dynamic>>> watch(String uid) =>
      _users.doc(uid).snapshots(includeMetadataChanges: true);

  /// Saves the profile and reserves its nickname in `nicknames/{key}` in one
  /// transaction; a changed nickname releases the old reservation.
  /// Throws [NicknameTakenException] if someone else holds the nickname.
  Future<void> save(String uid, UserProfile profile, {required bool isNew}) {
    return _db.runTransaction((tx) async {
      final newRef = _nicknames.doc(nicknameKey(profile.nickname));
      final newRes = await tx.get(newRef);
      if (newRes.exists && newRes.data()?['uid'] != uid) throw NicknameTakenException();

      final current = await tx.get(_users.doc(uid));
      final oldNickname = current.data()?['nickname'] as String?;
      DocumentSnapshot<Map<String, dynamic>>? oldRes;
      if (oldNickname != null && isValidNickname(oldNickname) && nicknameKey(oldNickname) != newRef.id) {
        oldRes = await tx.get(_nicknames.doc(nicknameKey(oldNickname)));
      }

      // All reads are done; writes follow.
      if (!newRes.exists) tx.set(newRef, {'uid': uid});
      if (oldRes != null && oldRes.exists && oldRes.data()?['uid'] == uid) tx.delete(oldRes.reference);
      tx.set(_users.doc(uid), {
        ...profile.toMap(),
        'ageConfirmed': true,
        'updatedAt': FieldValue.serverTimestamp(),
        if (isNew || !current.exists) 'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }
}
