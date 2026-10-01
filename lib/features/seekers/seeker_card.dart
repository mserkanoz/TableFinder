import 'package:flutter/material.dart';

import '../../data/locations.dart';
import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import 'seeker_post.dart';

/// "Kadıköy, İstanbul" when the player plays in person, otherwise their platforms.
String seekerWhere(AppLocalizations l10n, SeekerPost p) {
  final online = p.platforms.where((id) => id != 'in_person').map((id) => platformLabel(l10n, id));
  return [
    if (p.cityCode != null) placeLabel(l10n, l10n.localeName, p.country, p.cityCode, p.district),
    ...online,
  ].join(' · ');
}

/// Compact post summary for search results and "My LFG posts".
class SeekerCard extends StatelessWidget {
  const SeekerCard({super.key, required this.post, required this.onTap, this.showOwner = true});

  final SeekerPost post;
  final VoidCallback onTap;
  final bool showOwner;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = post;

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
                  Expanded(
                    child: Text(showOwner ? p.ownerNickname : l10n.lookingForGroup,
                        style: theme.textTheme.titleMedium),
                  ),
                  Chip(
                    label: Text(showOwner ? experienceLabel(l10n, p.experience) : gameStatusLabel(l10n, p.status)),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              Text(p.systems.map((id) => systemLabel(l10n, id)).join(', '), style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.place_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(seekerWhere(l10n, p))),
                ],
              ),
              if (p.availability.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule_outlined, size: 16),
                    const SizedBox(width: 4),
                    Expanded(child: Text(p.availability)),
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
