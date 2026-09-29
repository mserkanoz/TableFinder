import 'package:flutter/material.dart';

import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/page_padding.dart';
import '../applications/application_repository.dart';
import '../games/game_listing.dart';
import '../games/game_repository.dart';
import '../invites/invite_repository.dart';
import '../profile/profile_summary_card.dart';
import '../profile/user_profile.dart';
import '../safety/safety_menu.dart';
import 'seeker_card.dart';
import 'seeker_form_screen.dart';
import 'seeker_post.dart';
import 'seeker_repository.dart';

class SeekerDetailScreen extends StatelessWidget {
  const SeekerDetailScreen({super.key, required this.postId, required this.uid, required this.profile});

  final String postId;
  final String uid;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<SeekerPost?>(
      stream: SeekerRepository.instance.watch(postId),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final p = snapshot.data;
        if (p == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.postNotFound)),
          );
        }
        final isOwner = p.ownerUid == uid;
        final canInvite = !isOwner && profile.roles.contains('dm') && p.status == 'open';

        return Scaffold(
          appBar: AppBar(
            title: Text(isOwner ? l10n.lookingForGroup : p.ownerNickname),
            actions: [
              if (isOwner)
                IconButton(
                  tooltip: l10n.edit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SeekerFormScreen(uid: uid, profile: profile, initial: p),
                    ),
                  ),
                )
              else
                SafetyMenuButton(
                  targetType: 'seeker',
                  targetId: p.id!,
                  targetUid: p.ownerUid,
                  targetNickname: p.ownerNickname,
                ),
            ],
          ),
          body: ListView(
            padding: pagePadding(context),
            children: [
              InkWell(
                onTap: isOwner
                    ? null
                    : () =>
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => ProfileViewScreen(uid: p.ownerUid))),
                child: Text(
                  l10n.postedBy(p.ownerNickname),
                  style: isOwner ? null : const TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 12),
              _row(Icons.flag_outlined, l10n.statusLabel, gameStatusLabel(l10n, p.status)),
              _row(
                Icons.menu_book_outlined,
                l10n.systemsLabel,
                p.systems.map((id) => systemLabel(l10n, id)).join(', '),
              ),
              _row(Icons.place_outlined, l10n.platformsLabel, seekerWhere(l10n, p)),
              _row(
                Icons.category_outlined,
                l10n.gameTypesLabel,
                p.gameTypes.map((id) => gameTypeLabel(l10n, id)).join(', '),
              ),
              _row(
                Icons.translate,
                l10n.languagesLabel,
                p.languages.map((id) => gameLanguageLabel(l10n, id)).join(', '),
              ),
              _row(Icons.school_outlined, l10n.experienceLabel, experienceLabel(l10n, p.experience)),
              if (p.availability.isNotEmpty) _row(Icons.schedule_outlined, l10n.availabilityLabel, p.availability),
              if (p.openToPaid) _row(Icons.payments_outlined, l10n.openToPaidLabel, '✓'),
              if (p.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l10n.descriptionLabel, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(p.description),
              ],
              if (canInvite) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => _InviteSheet(dmUid: uid, dmNickname: profile.nickname, playerUid: p.ownerUid),
                  ),
                  icon: const Icon(Icons.mail_outline),
                  label: Text(l10n.inviteToTable),
                ),
              ],
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

/// Lists the DM's open tables; tapping one sends the invitation.
class _InviteSheet extends StatelessWidget {
  const _InviteSheet({required this.dmUid, required this.dmNickname, required this.playerUid});

  final String dmUid;
  final String dmNickname;
  final String playerUid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: StreamBuilder<List<GameListing>>(
        stream: GameRepository.instance.watchMine(dmUid),
        builder: (context, games) => StreamBuilder<Set<String>>(
          stream: InviteRepository.instance.watchInvitedGameIds(dmUid, playerUid),
          builder: (context, invited) => StreamBuilder<Map<String, String>>(
            stream: ApplicationRepository.instance.watchStatusesForOwner(dmUid, playerUid),
            builder: (context, applied) {
              final open = games.data?.where((g) => g.status == 'open').toList();
              if (open == null || !invited.hasData || !applied.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              // Why a table can't be offered: the player already has an application
              // there (unless withdrawn), or was already invited.
              String? blockedReason(String gameId) {
                final status = applied.data![gameId];
                if (status != null && status != 'withdrawn') return applicationStatusLabel(l10n, status);
                return invited.data!.contains(gameId) ? l10n.invited : null;
              }

              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(title: Text(l10n.chooseTable, style: Theme.of(context).textTheme.titleMedium)),
                  if (open.isEmpty) ListTile(title: Text(l10n.noOpenTables)),
                  for (final g in open)
                    ListTile(
                      title: Text(g.title),
                      subtitle: Text(systemLabel(l10n, g.system)),
                      trailing: blockedReason(g.id!) == null ? null : Chip(label: Text(blockedReason(g.id!)!)),
                      enabled: blockedReason(g.id!) == null,
                      onTap: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        try {
                          await InviteRepository.instance.invite(g, dmNickname, playerUid);
                          navigator.pop();
                          messenger.showSnackBar(SnackBar(content: Text(l10n.inviteSent)));
                        } catch (e) {
                          debugPrint('Invite error: $e');
                          messenger.showSnackBar(SnackBar(content: Text(l10n.actionFailed)));
                        }
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
