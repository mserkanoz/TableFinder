import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/game_options.dart';
import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/page_padding.dart';
import '../applications/application.dart';
import '../applications/application_repository.dart';
import '../auth/auth_service.dart';
import '../games/game_card.dart';
import '../games/game_detail_screen.dart';
import '../games/game_form_screen.dart';
import '../games/game_listing.dart';
import '../games/game_repository.dart';
import '../games/game_search_screen.dart';
import '../invites/invite.dart';
import '../invites/invite_repository.dart';
import '../profile/profile_edit_screen.dart';
import '../profile/profile_summary_card.dart';
import '../profile/user_profile.dart';
import '../safety/account_deletion.dart';
import '../safety/block_repository.dart';
import '../safety/blocked_users_screen.dart';
import '../seekers/seeker_card.dart';
import '../seekers/seeker_detail_screen.dart';
import '../seekers/seeker_form_screen.dart';
import '../seekers/seeker_post.dart';
import '../seekers/seeker_repository.dart';
import '../seekers/seeker_search_screen.dart';

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
          PopupMenuButton<String>(
            onSelected: (action) => switch (action) {
              'blocked' => _push(context, BlockedUsersScreen(uid: user.uid)),
              'delete' => _deleteAccount(context),
              _ => AuthService.instance.signOut(),
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'blocked', child: Text(l10n.blockedUsers)),
              PopupMenuItem(value: 'signout', child: Text(l10n.signOut)),
              PopupMenuItem(
                value: 'delete',
                child: Text(l10n.deleteAccount, style: TextStyle(color: theme.colorScheme.error)),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: pagePadding(context),
        children: [
          Text(l10n.welcomeUser(profile.nickname), style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          ProfileSummaryCard(profile: profile),
          const SizedBox(height: 12),
          if (isDm)
            _ButtonRow(
              left: FilledButton.icon(
                onPressed: () => _push(context, GameFormScreen(uid: user.uid, profile: profile)),
                icon: const Icon(Icons.add),
                label: Text(l10n.postGame),
              ),
              right: FilledButton.tonalIcon(
                onPressed: () => _push(context, SeekerSearchScreen(uid: user.uid, profile: profile)),
                icon: const Icon(Icons.person_search_outlined),
                label: Text(l10n.findPlayers),
              ),
            ),
          if (isPlayer)
            StreamBuilder<List<SeekerPost>>(
              stream: SeekerRepository.instance.watchMine(user.uid),
              builder: (context, posts) => _ButtonRow(
                left: FilledButton.icon(
                  onPressed: () => _push(context, GameSearchScreen(uid: user.uid, profile: profile)),
                  icon: const Icon(Icons.search),
                  label: Text(l10n.findGame),
                ),
                right: FilledButton.tonalIcon(
                  onPressed: posts.data == null
                      ? null
                      : posts.data!.length >= maxSeekerPosts
                          ? () => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(l10n.seekerLimitReached)))
                          : () => _push(
                              context,
                              SeekerFormScreen(uid: user.uid, profile: profile, existing: posts.data!),
                            ),
                  icon: const Icon(Icons.campaign_outlined),
                  label: Text(l10n.postSeeker),
                ),
              ),
            ),
          if (isPlayer) _MyInvites(uid: user.uid, onOpen: openGame, heading: _heading(context, l10n.myInvites)),
          if (isDm) ...[
            _heading(context, l10n.myTables),
            _MyTables(uid: user.uid, onOpen: openGame),
          ],
          if (isPlayer) ...[
            _heading(context, l10n.myApplications),
            _MyApplications(uid: user.uid, onOpen: openGame),
            _heading(context, l10n.mySeekerPosts),
            _MySeekerPosts(uid: user.uid, profile: profile),
          ],
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteAccountButton),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    // Non-dismissible progress dialog; the home screen underneath goes away
    // as the profile and sign-in are deleted, so close it via the navigator.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 16),
          Expanded(child: Text(l10n.deletingAccount)),
        ]),
      ),
    );
    try {
      await AccountDeletion.deleteAccount(user.uid);
    } catch (e) {
      debugPrint('Account deletion error: $e');
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteAccountFailed)));
    } finally {
      navigator.popUntil((route) => route.isFirst);
    }
  }

  Widget _heading(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}

void _push(BuildContext context, Widget screen) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

class _ButtonRow extends StatelessWidget {
  const _ButtonRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [Expanded(child: left), const SizedBox(width: 12), Expanded(child: right)]),
      );
}

/// Pending invitations; renders nothing (not even the heading) when empty.
class _MyInvites extends StatelessWidget {
  const _MyInvites({required this.uid, required this.onOpen, required this.heading});

  final String uid;
  final void Function(String gameId) onOpen;
  final Widget heading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<Invite>>(
      stream: InviteRepository.instance.watchPendingFor(uid),
      builder: (context, snapshot) => ValueListenableBuilder<Set<String>>(
        valueListenable: BlockRepository.instance.blocked,
        builder: (context, blocked, _) {
        final invites = snapshot.data?.where((i) => !blocked.contains(i.dmUid)).toList();
        if (invites == null || invites.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            heading,
            for (final i in invites)
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: Text(l10n.inviteText(i.dmNickname, i.gameTitle)),
                  trailing: TextButton(
                    onPressed: () => InviteRepository.instance.dismiss(i.id),
                    child: Text(l10n.dismiss),
                  ),
                  onTap: () => onOpen(i.gameId),
                ),
              ),
          ],
        );
        },
      ),
    );
  }
}

class _MySeekerPosts extends StatelessWidget {
  const _MySeekerPosts({required this.uid, required this.profile});

  final String uid;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<SeekerPost>>(
      stream: SeekerRepository.instance.watchMine(uid),
      builder: (context, snapshot) {
        final posts = snapshot.data;
        if (posts == null) return _spinner;
        if (posts.isEmpty) return Text(l10n.noSeekerPostsYet);
        return Column(
          children: [
            for (final p in posts)
              SeekerCard(
                post: p,
                showOwner: false,
                onTap: () => _push(context, SeekerDetailScreen(postId: p.id!, uid: uid, profile: profile)),
              ),
          ],
        );
      },
    );
  }
}

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
