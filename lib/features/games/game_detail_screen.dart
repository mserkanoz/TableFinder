import 'package:flutter/material.dart';

import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../applications/application.dart';
import '../applications/application_repository.dart';
import '../profile/profile_summary_card.dart';
import '../profile/user_profile.dart';
import 'game_card.dart';
import 'game_form_screen.dart';
import 'game_listing.dart';
import 'game_repository.dart';

class GameDetailScreen extends StatelessWidget {
  const GameDetailScreen({super.key, required this.gameId, required this.uid, required this.profile});

  final String gameId;
  final String uid;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<GameListing?>(
      stream: GameRepository.instance.watch(gameId),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final g = snapshot.data;
        if (g == null) {
          return Scaffold(appBar: AppBar(), body: Center(child: Text(l10n.gameNotFound)));
        }
        final isOwner = g.ownerUid == uid;

        return Scaffold(
          appBar: AppBar(
            title: Text(g.title),
            actions: [
              if (isOwner)
                IconButton(
                  tooltip: l10n.edit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GameFormScreen(uid: uid, profile: profile, initial: g),
                  )),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(g.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              InkWell(
                onTap: isOwner ? null : () => _openProfile(context, g.ownerUid),
                child: Text(l10n.hostedBy(g.ownerNickname),
                    style: isOwner ? null : const TextStyle(decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 16),
              _GameFacts(game: g),
              const SizedBox(height: 24),
              if (isOwner)
                _OwnerApplications(game: g)
              else
                _ApplicantPanel(game: g, uid: uid, profile: profile),
            ],
          ),
        );
      },
    );
  }
}

void _openProfile(BuildContext context, String uid) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileViewScreen(uid: uid)));

void _showError(BuildContext context) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).actionFailed)));

Future<bool> _confirm(BuildContext context, String text, String okLabel) async {
  final l10n = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(text),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(okLabel)),
      ],
    ),
  );
  return ok == true;
}

class _GameFacts extends StatelessWidget {
  const _GameFacts({required this.game});

  final GameListing game;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final g = game;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(Icons.flag_outlined, l10n.statusLabel, gameStatusLabel(l10n, g.status)),
        _row(Icons.menu_book_outlined, l10n.systemLabel, systemLabel(l10n, g.system)),
        _row(Icons.place_outlined, l10n.platformLabel, gameWhere(l10n, g)),
        _row(
          Icons.category_outlined,
          l10n.gameTypeLabel,
          [
            gameTypeLabel(l10n, g.gameType),
            if (g.campaignStage != null) campaignStageLabel(l10n, g.campaignStage!),
            if (g.frequency != null) frequencyLabel(l10n, g.frequency!),
          ].join(' · '),
        ),
        if (g.sessionAt != null)
          _row(Icons.event_outlined, g.isOngoing ? l10n.sessionNext : l10n.sessionFirst,
              formatSessionTime(context, g.sessionAt!)),
        _row(Icons.event_seat_outlined, l10n.seatsOpenLabel, l10n.seatsSummary(g.seatsOpen, g.seatsTotal)),
        _row(Icons.translate, l10n.gameLanguageLabel, gameLanguageLabel(l10n, g.language)),
        _row(Icons.payments_outlined, l10n.paidLabel,
            g.paid && g.price != null ? l10n.pricePerSession(g.price!) : l10n.free),
        if (g.beginnerFriendly) _row(Icons.school_outlined, l10n.beginnerFriendlyLabel, '✓'),
        if (g.description.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l10n.descriptionLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(g.description),
        ],
      ],
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12)),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Owner view: everyone who applied, with accept / reject / remove actions.
class _OwnerApplications extends StatelessWidget {
  const _OwnerApplications({required this.game});

  final GameListing game;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ApplicationRepository.instance;

    return StreamBuilder<List<GameApplication>>(
      stream: repo.watchForGame(game),
      builder: (context, snapshot) {
        final apps = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.applicationsTitle} (${apps?.length ?? 0})',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (apps == null)
              const Center(child: CircularProgressIndicator())
            else if (apps.isEmpty)
              Text(l10n.noApplications)
            else
              for (final a in apps)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _openProfile(context, a.applicantUid),
                                child: Text(a.applicantNickname,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                              ),
                            ),
                            Chip(
                              label: Text(applicationStatusLabel(l10n, a.status)),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        if (a.message.isNotEmpty) Text(a.message),
                        if (a.isPending || a.isAccepted)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (a.isPending) ...[
                                TextButton(
                                  onPressed: () => _run(context, () => repo.reject(game, a)),
                                  child: Text(l10n.reject),
                                ),
                                FilledButton(
                                  onPressed: () => _run(context, () => repo.accept(game, a.applicantUid)),
                                  child: Text(l10n.accept),
                                ),
                              ],
                              if (a.isAccepted)
                                TextButton(
                                  onPressed: () async {
                                    if (await _confirm(context, l10n.removePlayerConfirm(a.applicantNickname),
                                            l10n.removePlayer) &&
                                        context.mounted) {
                                      await _run(context, () => repo.reject(game, a));
                                    }
                                  },
                                  child: Text(l10n.removePlayer),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }

  Future<void> _run(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('Application action error: $e');
      if (context.mounted) _showError(context);
    }
  }
}

/// Non-owner view: apply, see your application status, and the contact note
/// once accepted.
class _ApplicantPanel extends StatelessWidget {
  const _ApplicantPanel({required this.game, required this.uid, required this.profile});

  final GameListing game;
  final String uid;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ApplicationRepository.instance;

    if (!profile.roles.contains('player')) return _InfoCard(l10n.playerRoleNeeded);

    return StreamBuilder<GameApplication?>(
      stream: repo.watchMine(game.id!, uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final app = snapshot.data;
        final canApply = game.status == 'open' && (app == null || app.status == 'withdrawn');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (app != null && app.status != 'withdrawn')
              Card(
                child: ListTile(
                  title: Text(l10n.applicationStatusLabel),
                  subtitle: Text(applicationStatusLabel(l10n, app.status)),
                  trailing: app.isPending || app.isAccepted
                      ? TextButton(
                          onPressed: () async {
                            if (await _confirm(context, l10n.withdrawConfirm, l10n.withdraw)) {
                              try {
                                await repo.withdraw(game.id!, uid);
                              } catch (e) {
                                debugPrint('Withdraw error: $e');
                                if (context.mounted) _showError(context);
                              }
                            }
                          },
                          child: Text(l10n.withdraw),
                        )
                      : null,
                ),
              ),
            if (app != null && app.isAccepted) _ContactNote(gameId: game.id!),
            if (canApply)
              FilledButton.icon(
                onPressed: () => _apply(context),
                icon: const Icon(Icons.send_outlined),
                label: Text(app == null ? l10n.apply : l10n.applyAgain),
              )
            else if (app == null || app.status == 'withdrawn')
              _InfoCard(l10n.gameNotOpen),
          ],
        );
      },
    );
  }

  Future<void> _apply(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final send = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.applyDialogTitle),
        content: TextField(
          controller: controller,
          maxLength: 500,
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: l10n.applyMessageLabel,
            hintText: l10n.applyMessageHint,
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.send)),
        ],
      ),
    );
    final message = controller.text.trim();
    controller.dispose();
    if (send != true) return;
    try {
      await ApplicationRepository.instance.apply(game, uid, profile, message);
    } catch (e) {
      debugPrint('Apply error: $e');
      if (context.mounted) _showError(context);
    }
  }
}

class _ContactNote extends StatelessWidget {
  const _ContactNote({required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<String>(
      future: GameRepository.instance.loadContactNote(gameId),
      builder: (context, snapshot) {
        final note = snapshot.data;
        return Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.contactNoteTitle, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                if (note == null)
                  const LinearProgressIndicator()
                else
                  SelectableText(note.isEmpty ? l10n.noContactNote : note),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(text)));
}
