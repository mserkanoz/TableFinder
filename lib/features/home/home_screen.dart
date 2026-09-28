import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../applications/application.dart';
import '../applications/application_repository.dart';
import '../auth/auth_service.dart';
import '../games/game_card.dart';
import '../games/game_detail_screen.dart';
import '../games/game_form_screen.dart';
import '../games/game_listing.dart';
import '../games/game_repository.dart';
import '../games/game_search_screen.dart';
import '../profile/profile_edit_screen.dart';
import '../profile/profile_summary_card.dart';
import '../profile/user_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user, required this.profile});

  final User user;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDm = profile.roles.contains('dm');
    final isPlayer = profile.roles.contains('player');
    void openGame(String gameId) =>
        _push(context, GameDetailScreen(gameId: gameId, uid: user.uid, profile: profile));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.profileEditTitle,
            icon: const Icon(Icons.person_outline),
            onPressed: () => _push(context, ProfileEditScreen(user: user, initial: profile)),
          ),
          IconButton(
            tooltip: l10n.signOut,
            icon: const Icon(Icons.logout),
            onPressed: AuthService.instance.signOut,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.welcomeUser(profile.nickname), style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          ProfileSummaryCard(profile: profile),
          const SizedBox(height: 12),
          Row(
            children: [
              if (isDm)
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _push(context, GameFormScreen(uid: user.uid, profile: profile)),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.postGame),
                  ),
                ),
              if (isDm && isPlayer) const SizedBox(width: 12),
              if (isPlayer)
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => _push(context, GameSearchScreen(uid: user.uid, profile: profile)),
                    icon: const Icon(Icons.search),
                    label: Text(l10n.findGame),
                  ),
                ),
            ],
          ),
          if (isDm) ...[
            _heading(context, l10n.myTables),
            _MyTables(uid: user.uid, onOpen: openGame),
          ],
          if (isPlayer) ...[
            _heading(context, l10n.myApplications),
            _MyApplications(uid: user.uid, onOpen: openGame),
          ],
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}

void _push(BuildContext context, Widget screen) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

const _spinner = Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));

class _MyTables extends StatelessWidget {
  const _MyTables({required this.uid, required this.onOpen});

  final String uid;
  final void Function(String gameId) onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<GameListing>>(
      stream: GameRepository.instance.watchMine(uid),
      builder: (context, snapshot) {
        final games = snapshot.data;
        if (games == null) return _spinner;
        if (games.isEmpty) return Text(l10n.noTablesYet);
        return StreamBuilder<Map<String, int>>(
          stream: ApplicationRepository.instance.watchPendingCounts(uid),
          builder: (context, counts) => Column(
            children: [
              for (final g in games)
                GameCard(
                  game: g,
                  showStatus: true,
                  badge: (counts.data?[g.id] ?? 0) > 0 ? l10n.pendingApplications(counts.data![g.id]!) : null,
                  onTap: () => onOpen(g.id!),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MyApplications extends StatelessWidget {
  const _MyApplications({required this.uid, required this.onOpen});

  final String uid;
  final void Function(String gameId) onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<GameApplication>>(
      stream: ApplicationRepository.instance.watchByApplicant(uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) debugPrint('My applications error: ${snapshot.error}');
        final apps = snapshot.data?.where((a) => a.status != 'withdrawn').toList();
        if (apps == null) return snapshot.hasError ? Text(l10n.actionFailed) : _spinner;
        if (apps.isEmpty) return Text(l10n.noApplicationsYet);
        return Column(
          children: [
            for (final a in apps)
              Card(
                child: ListTile(
                  title: Text(a.gameTitle),
                  trailing: Chip(
                    label: Text(applicationStatusLabel(l10n, a.status)),
                    visualDensity: VisualDensity.compact,
                  ),
                  onTap: () => onOpen(a.gameId),
                ),
              ),
          ],
        );
      },
    );
  }
}
