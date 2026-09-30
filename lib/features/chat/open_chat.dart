import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'chat.dart';
import 'chat_repository.dart';
import 'chat_screen.dart';

/// Opens (creating if needed) the chat with [otherUid] and shows it.
Future<void> openChat(
  BuildContext context, {
  required String me,
  required String myNickname,
  required String otherUid,
  required String otherNickname,
  required ChatContext chatContext,
}) async {
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final failed = AppLocalizations.of(context).actionFailed;
  try {
    final chatId = await ChatRepository.instance.openOrCreate(
      me: me,
      myNickname: myNickname,
      other: otherUid,
      otherNickname: otherNickname,
      context: chatContext,
    );
    navigator.push(MaterialPageRoute(builder: (_) => ChatScreen(chatId: chatId, uid: me)));
  } catch (e) {
    debugPrint('Open chat error: $e');
    messenger.showSnackBar(SnackBar(content: Text(failed)));
  }
}
