import 'package:cloud_firestore/cloud_firestore.dart';

const reportReasonIds = ['spam', 'harassment', 'inappropriate', 'fake', 'other'];

/// Reports go to `reports/{id}`; users can only create them. They are
/// reviewed in the Firebase console.
class ReportRepository {
  ReportRepository._();
  static final instance = ReportRepository._();

  Future<void> report({
    required String reporterUid,
    required String targetType, // user | game | seeker
    required String targetId,
    required String targetUid,
    required String reason,
    required String details,
  }) {
    return FirebaseFirestore.instance.collection('reports').add({
      'reporterUid': reporterUid,
      'targetType': targetType,
      'targetId': targetId,
      'targetUid': targetUid,
      'reason': reason,
      'details': details,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
