import 'package:cloud_firestore/cloud_firestore.dart';

/// A player's application to a game, stored at
/// `games/{gameId}/applications/{applicantUid}` (one per player per game).
class GameApplication {
  const GameApplication({
    required this.gameId,
    required this.gameTitle,
    required this.gameOwnerUid,
    required this.applicantUid,
    required this.applicantNickname,
    required this.message,
    required this.status,
    this.createdAt,
  });

  final String gameId;
  final String gameTitle;
  final String gameOwnerUid;
  final String applicantUid;
  final String applicantNickname;
  final String message;
  final String status; // pending | accepted | rejected | removed | withdrawn
  final DateTime? createdAt;

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';

  factory GameApplication.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    return GameApplication(
      gameId: m['gameId'] as String,
      gameTitle: m['gameTitle'] as String? ?? '',
      gameOwnerUid: m['gameOwnerUid'] as String,
      applicantUid: m['applicantUid'] as String,
      applicantNickname: m['applicantNickname'] as String? ?? '',
      message: m['message'] as String? ?? '',
      status: m['status'] as String? ?? 'pending',
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
