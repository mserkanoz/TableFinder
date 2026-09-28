import 'package:cloud_firestore/cloud_firestore.dart';

/// A DM's invitation for a player to apply to a game, stored at
/// `invites/{gameId}_{playerUid}` (one per game and player).
class Invite {
  const Invite({
    required this.id,
    required this.gameId,
    required this.gameTitle,
    required this.dmUid,
    required this.dmNickname,
    required this.playerUid,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String gameId;
  final String gameTitle;
  final String dmUid;
  final String dmNickname;
  final String playerUid;
  final String status; // pending | dismissed
  final DateTime? createdAt;

  static String idFor(String gameId, String playerUid) => '${gameId}_$playerUid';

  factory Invite.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    return Invite(
      id: doc.id,
      gameId: m['gameId'] as String,
      gameTitle: m['gameTitle'] as String? ?? '',
      dmUid: m['dmUid'] as String,
      dmNickname: m['dmNickname'] as String? ?? '',
      playerUid: m['playerUid'] as String,
      status: m['status'] as String? ?? 'pending',
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
