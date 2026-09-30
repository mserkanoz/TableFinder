import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat.dart';

class ChatRepository {
  ChatRepository._();
  static final instance = ChatRepository._();

  static const messageLimit = 200;

  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _chats => _db.collection('chats');

  /// The user's chats, most recent first.
  Stream<List<Chat>> watchMine(String uid) => _chats
      .where('members', arrayContains: uid)
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Chat.fromDoc).toList());

  Stream<Chat?> watch(String chatId) =>
      _chats.doc(chatId).snapshots().map((d) => d.exists ? Chat.fromDoc(d) : null);

  /// The latest messages, newest first.
  Stream<List<ChatMessage>> watchMessages(String chatId) => _chats
      .doc(chatId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .limit(messageLimit)
      .snapshots()
      .map((s) => s.docs.map(ChatMessage.fromDoc).toList());

  /// Returns the chat between the two users, creating it from [context] if needed.
  Future<String> openOrCreate({
    required String me,
    required String myNickname,
    required String other,
    required String otherNickname,
    required ChatContext context,
  }) async {
    final ref = _chats.doc(Chat.idFor(me, other));
    final existing = await ref.get();
    if (!existing.exists) {
      final members = [me, other]..sort();
      await ref.set({
        'members': members,
        'nicknames': {me: myNickname, other: otherNickname},
        'contextType': context.type,
        'contextId': context.id,
        'contextTitle': context.title,
        'lastMessage': '',
        'lastSenderUid': null,
        'readAt': <String, dynamic>{},
        'closed': false,
        'deletedUids': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    return ref.id;
  }

  Future<void> send(String chatId, String me, String text) {
    final chat = _chats.doc(chatId);
    final batch = _db.batch();
    batch.set(chat.collection('messages').doc(), {
      'senderUid': me,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(chat, {
      'lastMessage': text.length > 100 ? '${text.substring(0, 100)}…' : text,
      'lastSenderUid': me,
      'updatedAt': FieldValue.serverTimestamp(),
      'readAt.$me': FieldValue.serverTimestamp(),
    });
    return batch.commit();
  }

  Future<void> markRead(String chatId, String me) =>
      _chats.doc(chatId).update({'readAt.$me': FieldValue.serverTimestamp()});

  /// On account deletion: close the user's chats but keep the history for the
  /// other member; the user's nickname is dropped.
  Future<void> archiveAllFor(String me) async {
    final snap = await _chats.where('members', arrayContains: me).get();
    final batch = _db.batch();
    for (final d in snap.docs) {
      batch.update(d.reference, {
        'closed': true,
        'deletedUids': FieldValue.arrayUnion([me]),
        'nicknames.$me': '',
      });
    }
    await batch.commit();
  }
}
