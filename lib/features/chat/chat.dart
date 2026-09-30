import 'package:cloud_firestore/cloud_firestore.dart';

/// A one-to-one conversation at `chats/{uidA}_{uidB}` (UIDs sorted), with
/// messages in `chats/{id}/messages`. A chat can only be started from a
/// listing (see [ChatContext]); after that both members can write freely.
/// When a member deletes their account the chat is closed but kept, so the
/// other member still has the history.
class Chat {
  const Chat({
    required this.id,
    required this.members,
    required this.nicknames,
    required this.contextTitle,
    required this.lastMessage,
    required this.lastSenderUid,
    required this.updatedAt,
    required this.readAt,
    required this.closed,
    required this.deletedUids,
  });

  final String id;
  final List<String> members;
  final Map<String, String> nicknames;
  final String contextTitle;
  final String lastMessage;
  final String? lastSenderUid;
  final DateTime? updatedAt;
  final Map<String, DateTime> readAt;
  final bool closed;
  final List<String> deletedUids;

  static String idFor(String a, String b) => a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';

  String otherUid(String me) => members.firstWhere((m) => m != me, orElse: () => me);

  bool isDeleted(String uid) => deletedUids.contains(uid);

  /// The other member's nickname, or null if they deleted their account.
  String? otherNickname(String me) {
    final other = otherUid(me);
    return isDeleted(other) ? null : nicknames[other];
  }

  bool isUnreadFor(String me) {
    if (lastSenderUid == null || lastSenderUid == me || updatedAt == null) return false;
    final read = readAt[me];
    return read == null || updatedAt!.isAfter(read);
  }

  factory Chat.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    final read = (m['readAt'] as Map?) ?? {};
    return Chat(
      id: doc.id,
      members: List<String>.from(m['members'] as List),
      nicknames: Map<String, String>.from((m['nicknames'] as Map?) ?? {}),
      contextTitle: m['contextTitle'] as String? ?? '',
      lastMessage: m['lastMessage'] as String? ?? '',
      lastSenderUid: m['lastSenderUid'] as String?,
      updatedAt: (m['updatedAt'] as Timestamp?)?.toDate(),
      readAt: {for (final e in read.entries) e.key as String: (e.value as Timestamp).toDate()},
      closed: m['closed'] as bool? ?? false,
      deletedUids: List<String>.from((m['deletedUids'] as List?) ?? const []),
    );
  }
}

/// Where a chat was started from; the rules check that it justifies the chat.
class ChatContext {
  const ChatContext.game(this.id, this.title) : type = 'game';
  const ChatContext.seeker(this.id, this.title) : type = 'seeker';

  final String type; // game | seeker
  final String id;
  final String title;
}

class ChatMessage {
  const ChatMessage({required this.id, required this.senderUid, required this.text, this.createdAt});

  final String id;
  final String senderUid;
  final String text;
  final DateTime? createdAt;

  factory ChatMessage.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    return ChatMessage(
      id: doc.id,
      senderUid: m['senderUid'] as String,
      text: m['text'] as String? ?? '',
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
