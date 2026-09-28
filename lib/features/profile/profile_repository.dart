import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_profile.dart';

class ProfileRepository {
  ProfileRepository._();
  static final instance = ProfileRepository._();

  final _users = FirebaseFirestore.instance.collection('users');

  /// Raw snapshots, so callers can tell "no profile" apart from
  /// "not loaded from the server yet" (see [SnapshotMetadata.isFromCache]).
  Stream<DocumentSnapshot<Map<String, dynamic>>> watch(String uid) =>
      _users.doc(uid).snapshots(includeMetadataChanges: true);

  Future<void> save(String uid, UserProfile profile, {required bool isNew}) {
    return _users.doc(uid).set({
      ...profile.toMap(),
      'ageConfirmed': true,
      'updatedAt': FieldValue.serverTimestamp(),
      if (isNew) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
