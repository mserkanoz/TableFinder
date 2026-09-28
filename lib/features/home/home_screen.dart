import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/option_labels.dart';
import '../../data/turkey_locations.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_service.dart';
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
          const SizedBox(height: 32),
          Text(l10n.homePlaceholder, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

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
