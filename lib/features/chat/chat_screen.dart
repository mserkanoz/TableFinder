import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../profile/profile_summary_card.dart';
import '../safety/block_repository.dart';
import '../safety/safety_menu.dart';
import 'chat.dart';
import 'chat_list_screen.dart';
import 'chat_repository.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatId, required this.uid});

  final String chatId;
  final String uid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  bool _sending = false;
  String? _lastMarkedMessageId;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ChatRepository.instance.send(widget.chatId, widget.uid, text);
      _input.clear();
    } catch (e) {
      debugPrint('Send error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).actionFailed)));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  /// Marks the chat read whenever a new message from the other member shows up.
  void _markReadIfNeeded(List<ChatMessage> messages) {
    if (messages.isEmpty) return;
    final newest = messages.first;
    if (newest.id == _lastMarkedMessageId || newest.senderUid == widget.uid) return;
    _lastMarkedMessageId = newest.id;
    ChatRepository.instance.markRead(widget.chatId, widget.uid).catchError((Object e) {
      debugPrint('Mark read error: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<Chat?>(
      stream: ChatRepository.instance.watch(widget.chatId),
      builder: (context, chatSnap) {
        final chat = chatSnap.data;
        if (chat == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
        }
        final otherUid = chat.otherUid(widget.uid);
        final otherName = chat.otherNickname(widget.uid);

        return ValueListenableBuilder<Set<String>>(
          valueListenable: BlockRepository.instance.blocked,
          builder: (context, blocked, _) {
            final isBlocked = blocked.contains(otherUid);
            final notice = chat.closed ? l10n.chatClosed : (isBlocked ? l10n.chatBlocked : null);

            return Scaffold(
              appBar: AppBar(
                title: InkWell(
                  onTap: otherName == null
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProfileViewScreen(uid: otherUid))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(otherName ?? l10n.deletedUser),
                      Text(chat.contextTitle, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                actions: [
                  if (otherName != null)
                    SafetyMenuButton(
                      targetType: 'user',
                      targetId: otherUid,
                      targetUid: otherUid,
                      targetNickname: otherName,
                    ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(child: _messageList(context, l10n)),
                  if (notice != null)
                    SafeArea(
                      top: false,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Text(notice, textAlign: TextAlign.center),
                      ),
                    )
                  else
                    _inputBar(l10n),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _messageList(BuildContext context, AppLocalizations l10n) {
    return StreamBuilder<List<ChatMessage>>(
      stream: ChatRepository.instance.watchMessages(widget.chatId),
      builder: (context, snapshot) {
        final messages = snapshot.data;
        if (messages == null) return const Center(child: CircularProgressIndicator());
        _markReadIfNeeded(messages);
        if (messages.isEmpty) return Center(child: Text(l10n.noMessagesYet));
        return ListView.builder(
          reverse: true, // newest at the bottom, list starts scrolled there
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          itemCount: messages.length,
          itemBuilder: (context, i) => _Bubble(message: messages[i], mine: messages[i].senderUid == widget.uid),
        );
      },
    );
  }

  Widget _inputBar(AppLocalizations l10n) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _input,
                minLines: 1,
                maxLines: 5,
                maxLength: 1000,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: l10n.messageHint,
                  border: const OutlineInputBorder(),
                  counterText: '',
                  isDense: true,
                ),
              ),
            ),
            IconButton.filled(
              onPressed: _sending ? null : _send,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine});

  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          decoration: BoxDecoration(
            color: mine ? scheme.primaryContainer : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SelectableText(message.text),
              if (message.createdAt != null)
                Text(shortTime(context, message.createdAt!), style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
