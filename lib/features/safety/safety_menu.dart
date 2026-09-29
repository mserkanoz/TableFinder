import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'block_repository.dart';
import 'report_repository.dart';

/// App-bar "⋮" menu with Report and Block for someone else's profile or content.
class SafetyMenuButton extends StatelessWidget {
  const SafetyMenuButton({
    super.key,
    required this.targetType,
    required this.targetId,
    required this.targetUid,
    required this.targetNickname,
  });

  final String targetType; // user | game | seeker
  final String targetId;
  final String targetUid;
  final String targetNickname;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ValueListenableBuilder<Set<String>>(
      valueListenable: BlockRepository.instance.blocked,
      builder: (context, blocked, _) {
        final isBlocked = blocked.contains(targetUid);
        return PopupMenuButton<String>(
          onSelected: (action) => switch (action) {
            'report' => _report(context),
            'block' => _block(context),
            _ => BlockRepository.instance.unblock(_myUid, targetUid),
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'report', child: Text(l10n.report)),
            PopupMenuItem(value: isBlocked ? 'unblock' : 'block', child: Text(isBlocked ? l10n.unblock : l10n.block)),
          ],
        );
      },
    );
  }

  String get _myUid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _report(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await showDialog<({String reason, String details})>(
      context: context,
      builder: (_) => const _ReportDialog(),
    );
    if (result == null) return;
    try {
      await ReportRepository.instance.report(
        reporterUid: _myUid,
        targetType: targetType,
        targetId: targetId,
        targetUid: targetUid,
        reason: result.reason,
        details: result.details,
      );
      messenger.showSnackBar(SnackBar(content: Text(l10n.reportSent)));
    } catch (e) {
      debugPrint('Report error: $e');
      messenger.showSnackBar(SnackBar(content: Text(l10n.actionFailed)));
    }
  }

  Future<void> _block(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.blockConfirm(targetNickname)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.block)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await BlockRepository.instance.block(_myUid, targetUid, targetNickname);
      messenger.showSnackBar(SnackBar(content: Text(l10n.userBlocked)));
    } catch (e) {
      debugPrint('Block error: $e');
      messenger.showSnackBar(SnackBar(content: Text(l10n.actionFailed)));
    }
  }
}

/// Pops with the chosen reason and details, or null if cancelled.
class _ReportDialog extends StatefulWidget {
  const _ReportDialog();

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  final _details = TextEditingController();
  String? _reason;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  String _label(AppLocalizations l10n, String id) => switch (id) {
        'spam' => l10n.reasonSpam,
        'harassment' => l10n.reasonHarassment,
        'inappropriate' => l10n.reasonInappropriate,
        'fake' => l10n.reasonFake,
        _ => l10n.optionOther,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.report),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.reportReasonLabel, style: Theme.of(context).textTheme.titleSmall),
            RadioGroup<String>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v),
              child: Column(
                children: [
                  for (final id in reportReasonIds)
                    RadioListTile<String>(
                      value: id,
                      title: Text(_label(l10n, id)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                ],
              ),
            ),
            TextField(
              controller: _details,
              maxLength: 500,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: l10n.reportDetailsLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: _reason == null
              ? null
              : () => Navigator.pop(context, (reason: _reason!, details: _details.text.trim())),
          child: Text(l10n.send),
        ),
      ],
    );
  }
}
