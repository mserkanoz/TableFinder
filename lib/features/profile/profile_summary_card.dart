import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/option_labels.dart';
import '../../data/turkey_locations.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/page_padding.dart';
import 'user_profile.dart';

/// Roles, systems, platforms, location (and optionally bio) in a card.
class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({super.key, required this.profile, this.showBio = false});

  final UserProfile profile;
  final bool showBio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final province = provinceByCode(profile.cityCode);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(Icons.theater_comedy_outlined, profile.roles.map((id) => roleLabel(l10n, id)).join(', ')),
            _InfoRow(Icons.menu_book_outlined, profile.systems.map((id) => systemLabel(l10n, id)).join(', ')),
            _InfoRow(Icons.table_restaurant_outlined,
                profile.platforms.map((id) => platformLabel(l10n, id)).join(', ')),
            if (province != null)
              _InfoRow(Icons.place_outlined, [profile.district, province.name].whereType<String>().join(', ')),
            if (showBio && profile.bio.isNotEmpty) _InfoRow(Icons.notes_outlined, profile.bio),
          ],
        ),
      ),
    );
  }
}

/// Another user's public profile.
class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        final doc = snapshot.data;
        final profile = doc != null && doc.exists ? UserProfile.fromMap(doc.data()!) : null;
        return Scaffold(
          appBar: AppBar(title: Text(profile?.nickname ?? '')),
          body: profile == null
              ? Center(child: snapshot.hasData ? const Icon(Icons.person_off_outlined) : const CircularProgressIndicator())
              : ListView(
                  padding: pagePadding(context),
                  children: [ProfileSummaryCard(profile: profile, showBio: true)],
                ),
        );
      },
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
