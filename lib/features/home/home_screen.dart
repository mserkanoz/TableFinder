import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/option_labels.dart';
import '../../data/turkey_locations.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_service.dart';
import '../games/game_card.dart';
import '../games/game_detail_screen.dart';
import '../games/game_form_screen.dart';
import '../games/game_listing.dart';
import '../games/game_repository.dart';
import '../games/game_search_screen.dart';
import '../profile/profile_edit_screen.dart';
import '../profile/user_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user, required this.profile});

  final User user;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final province = provinceByCode(profile.cityCode);
    final isDm = profile.roles.contains('dm');
    final isPlayer = profile.roles.contains('player');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.profileEditTitle,
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProfileEditScreen(user: user, initial: profile),
            )),
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(Icons.theater_comedy_outlined,
                      profile.roles.map((id) => roleLabel(l10n, id)).join(', ')),
                  _InfoRow(Icons.menu_book_outlined,
                      profile.systems.map((id) => systemLabel(l10n, id)).join(', ')),
                  _InfoRow(Icons.table_restaurant_outlined,
                      profile.platforms.map((id) => platformLabel(l10n, id)).join(', ')),
                  if (province != null)
                    _InfoRow(Icons.place_outlined,
                        [profile.district, province.name].whereType<String>().join(', ')),
                ],
              ),
            ),
          ),
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
            const SizedBox(height: 24),
            Text(l10n.myTables, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            StreamBuilder<List<GameListing>>(
              stream: GameRepository.instance.watchMine(user.uid),
              builder: (context, snapshot) {
                final games = snapshot.data;
                if (games == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (games.isEmpty) return Text(l10n.noTablesYet);
                return Column(
                  children: [
                    for (final g in games)
                      GameCard(
                        game: g,
                        showStatus: true,
                        onTap: () => _push(
                          context,
                          GameDetailScreen(gameId: g.id!, uid: user.uid, profile: profile),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

void _push(BuildContext context, Widget screen) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
