import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/page_padding.dart';
import '../safety/block_repository.dart';
import 'chat.dart';
import 'chat_repository.dart';
import 'chat_screen.dart';

/// "Today 14:05" style short time for list rows.
String shortTime(BuildContext context, DateTime t) {
  final locale = Localizations.localeOf(context).toString();
  final now = DateTime.now();
  final sameDay = t.year == now.year && t.month == now.month && t.day == now.day;
  return sameDay ? DateFormat.Hm(locale).format(t) : DateFormat.MMMd(locale).format(t);
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.messages)),
      body: StreamBuilder<List<Chat>>(
        stream: ChatRepository.instance.watchMine(uid),
        builder: (context, snapshot) => ValueListenableBuilder<Set<String>>(
          valueListenable: BlockRepository.instance.blocked,
          builder: (context, blocked, _) {
            if (snapshot.hasError) debugPrint('Chat list error: ${snapshot.error}');
            final chats = snapshot.data?.where((c) => !blocked.contains(c.otherUid(uid))).toList();
            if (chats == null) {
              return Center(child: snapshot.hasError ? Text(l10n.actionFailed) : const CircularProgressIndicator());
            }
            if (chats.isEmpty) {
              return Center(
                child: Padding(padding: const EdgeInsets.all(24), child: Text(l10n.noChats, textAlign: TextAlign.center)),
              );
            }
            return ListView(
              padding: pagePadding(context, top: 8),
              children: [
                for (final c in chats) _ChatTile(chat: c, uid: uid),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat, required this.uid});

  final Chat chat;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unread = chat.isUnreadFor(uid);
    final name = chat.otherNickname(uid) ?? l10n.deletedUser;
    final preview = chat.lastMessage.isEmpty
        ? chat.contextTitle
        : '${chat.lastSenderUid == uid ? l10n.youPrefix : ''}${chat.lastMessage}';

    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(name.characters.first.toUpperCase())),
        title: Text(name, style: TextStyle(fontWeight: unread ? FontWeight.bold : null)),
        subtitle: Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chat.updatedAt != null) Text(shortTime(context, chat.updatedAt!), style: const TextStyle(fontSize: 12)),
            if (unread) ...[
              const SizedBox(height: 4),
              Badge(backgroundColor: Theme.of(context).colorScheme.primary),
            ],
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChatScreen(chatId: chat.id, uid: uid)),
        ),
      ),
    );
  }
}
