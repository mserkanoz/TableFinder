import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/page_padding.dart';
import 'block_repository.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.blockedUsers)),
      body: StreamBuilder<List<({String uid, String nickname})>>(
        stream: BlockRepository.instance.watchList(uid),
        builder: (context, snapshot) {
          final users = snapshot.data;
          if (users == null) return const Center(child: CircularProgressIndicator());
          if (users.isEmpty) return Center(child: Text(l10n.noBlockedUsers));
          return ListView(
            padding: pagePadding(context, top: 8),
            children: [
              for (final u in users)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.block),
                    title: Text(u.nickname),
                    trailing: TextButton(
                      onPressed: () => BlockRepository.instance.unblock(uid, u.uid),
                      child: Text(l10n.unblock),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
