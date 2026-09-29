import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/game_options.dart';
import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/location_picker.dart';
import '../../widgets/page_padding.dart';
import '../profile/user_profile.dart';
import '../safety/block_repository.dart';
import 'seeker_card.dart';
import 'seeker_detail_screen.dart';
import 'seeker_post.dart';
import 'seeker_repository.dart';

/// DM-side search over players' "looking for group" posts.
class SeekerSearchScreen extends StatefulWidget {
  const SeekerSearchScreen({super.key, required this.uid, required this.profile});

  final String uid;
  final UserProfile profile;

  @override
  State<SeekerSearchScreen> createState() => _SeekerSearchScreenState();
}

class _SeekerSearchScreenState extends State<SeekerSearchScreen> {
  String? _system;
  String? _platform;
  int? _cityCode;
  String? _district;
  String? _language;
  String? _experience;
  bool _filtersOpen = true;

  final List<SeekerPost> _results = [];
  DocumentSnapshot<Map<String, dynamic>>? _cursor;
  bool _hasMore = false;
  bool _loading = false;
  bool _searched = false;
  String? _error;

  SeekerFilters get _filters => SeekerFilters(
        system: _system,
        platform: _platform,
        cityCode: _platform == 'in_person' ? _cityCode : null,
        district: _platform == 'in_person' ? _district : null,
        language: _language,
        experience: _experience,
      );

  Future<void> _search({bool more = false}) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _loading = true;
      _error = null;
      if (!more) {
        _results.clear();
        _cursor = null;
        _filtersOpen = false;
      }
    });
    try {
      final page = await SeekerRepository.instance.search(_filters, after: more ? _cursor : null);
      if (!mounted) return;
      setState(() {
        // Don't list the searcher's own posts.
        _results.addAll(page.posts.where(
            (p) => p.ownerUid != widget.uid && !BlockRepository.instance.isBlocked(p.ownerUid)));
        _cursor = page.cursor;
        _hasMore = page.hasMore;
        _searched = true;
      });
    } catch (e) {
      debugPrint('Seeker search error: $e');
      if (mounted) setState(() => _error = l10n.searchFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.findPlayers)),
      body: ListView(
        padding: pagePadding(context, top: 8),
        children: [
          Card(
            child: ExpansionTile(
              key: ValueKey(_filtersOpen),
              initiallyExpanded: _filtersOpen,
              title: Text(l10n.filtersTitle),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [_filterForm(l10n)],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _loading ? null : _search,
            icon: const Icon(Icons.search),
            label: Text(l10n.searchButton),
          ),
          const SizedBox(height: 16),
          if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          if (_searched && _results.isEmpty && !_loading && _error == null)
            Padding(padding: const EdgeInsets.all(24), child: Text(l10n.noSeekerResults, textAlign: TextAlign.center)),
          for (final p in _results)
            SeekerCard(
              post: p,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SeekerDetailScreen(postId: p.id!, uid: widget.uid, profile: widget.profile),
              )),
            ),
          if (_loading) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
          if (_hasMore && !_loading) TextButton(onPressed: () => _search(more: true), child: Text(l10n.loadMore)),
        ],
      ),
    );
  }

  Widget _dropdown(AppLocalizations l10n, String label, String? value, Iterable<String> ids,
      String Function(String) labelOf, void Function(String?) onChanged,
      {bool filter = false}) {
    return DropdownMenu<String>(
      expandedInsets: EdgeInsets.zero,
      label: Text(label),
      initialSelection: value ?? '',
      enableFilter: filter,
      requestFocusOnTap: filter,
      menuHeight: 320,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: '', label: l10n.filterAll),
        for (final id in ids) DropdownMenuEntry(value: id, label: labelOf(id)),
      ],
      onSelected: (id) => setState(() => onChanged(id == null || id.isEmpty ? null : id)),
    );
  }

  Widget _filterForm(AppLocalizations l10n) {
    return Column(
      children: [
        _dropdown(l10n, l10n.systemLabel, _system, gameSystems.keys, (id) => systemLabel(l10n, id),
            (v) => _system = v, filter: true),
        const SizedBox(height: 12),
        _dropdown(l10n, l10n.platformLabel, _platform, platformIds, (id) => platformLabel(l10n, id),
            (v) => _platform = v),
        if (_platform == 'in_person') ...[
          const SizedBox(height: 12),
          LocationPicker(
            cityCode: _cityCode,
            district: _district,
            anyLabel: l10n.filterAll,
            onChanged: (city, district) => setState(() {
              _cityCode = city;
              _district = district;
            }),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _dropdown(l10n, l10n.gameLanguageLabel, _language, gameLanguageIds,
                  (id) => gameLanguageLabel(l10n, id), (v) => _language = v),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _dropdown(l10n, l10n.experienceLabel, _experience, experienceIds,
                  (id) => experienceLabel(l10n, id), (v) => _experience = v),
            ),
          ],
        ),
      ],
    );
  }
}
