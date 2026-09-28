import 'package:flutter/material.dart';

import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
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
              Text(l10n.hostedBy(g.ownerNickname)),
              const SizedBox(height: 16),
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
              if (g.beginnerFriendly)
                _row(Icons.school_outlined, l10n.beginnerFriendlyLabel, '✓'),
              if (g.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l10n.descriptionLabel, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(g.description),
              ],
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(isOwner ? l10n.yourListing : l10n.applyComingSoon),
                ),
              ),
            ],
          ),
        );
      },
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
