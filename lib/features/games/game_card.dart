import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/option_labels.dart';
import '../../data/turkey_locations.dart';
import '../../l10n/app_localizations.dart';
import 'game_listing.dart';

/// "Kadıköy, İstanbul" for in-person games, otherwise the platform name.
String gameWhere(AppLocalizations l10n, GameListing g) {
  final province = provinceByCode(g.cityCode);
  if (g.platform == 'in_person' && province != null) {
    return [g.district, province.name].whereType<String>().join(', ');
  }
  return platformLabel(l10n, g.platform);
}

String formatSessionTime(BuildContext context, DateTime t) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMEd(locale).add_Hm().format(t);
}

/// Compact listing summary used in search results and "My tables".
class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.game, required this.onTap, this.showStatus = false});

  final GameListing game;
  final VoidCallback onTap;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final g = game;

    final tags = <String>[
      systemLabel(l10n, g.system),
      g.gameType == 'campaign'
          ? '${l10n.gameTypeCampaign} · ${campaignStageLabel(l10n, g.campaignStage ?? 'new')}'
          : l10n.gameTypeOneShot,
      gameLanguageLabel(l10n, g.language),
      if (g.beginnerFriendly) l10n.beginnerFriendlyLabel,
      g.paid && g.price != null ? l10n.pricePerSession(g.price!) : l10n.free,
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(g.title, style: theme.textTheme.titleMedium)),
                  if (showStatus)
                    Chip(
                      label: Text(gameStatusLabel(l10n, g.status)),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(tags.join(' · '), style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.place_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(gameWhere(l10n, g))),
                  const Icon(Icons.event_seat_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text(l10n.seatsSummary(g.seatsOpen, g.seatsTotal)),
                ],
              ),
              if (g.sessionAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.event_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(formatSessionTime(context, g.sessionAt!)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
