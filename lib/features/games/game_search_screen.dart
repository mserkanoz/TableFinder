import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/game_options.dart';
import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/location_picker.dart';
import '../../widgets/page_padding.dart';
import '../profile/user_profile.dart';
import 'game_card.dart';
import 'game_detail_screen.dart';
import 'game_listing.dart';
import 'game_repository.dart';

class GameSearchScreen extends StatefulWidget {
  const GameSearchScreen({super.key, required this.uid, required this.profile});

  final String uid;
  final UserProfile profile;

  @override
  State<GameSearchScreen> createState() => _GameSearchScreenState();
}

class _GameSearchScreenState extends State<GameSearchScreen> {
  String? _system;
  String? _platform;
  int? _cityCode;
  String? _district;
  String? _gameType;
  String? _language;
  bool _beginnerOnly = false;
  bool _freeOnly = false;
  bool _filtersOpen = true;

  final List<GameListing> _results = [];
  DocumentSnapshot<Map<String, dynamic>>? _cursor;
  bool _hasMore = false;
  bool _loading = false;
  bool _searched = false;
  String? _error;

  GameFilters get _filters => GameFilters(
        system: _system,
        platform: _platform,
        cityCode: _platform == 'in_person' ? _cityCode : null,
        district: _platform == 'in_person' ? _district : null,
        gameType: _gameType,
        language: _language,
        beginnerOnly: _beginnerOnly,
        freeOnly: _freeOnly,
      );

  Future<void> _search({bool more = false}) async {
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
      final page = await GameRepository.instance.search(_filters, after: more ? _cursor : null);
      setState(() {
        _results.addAll(page.games);
        _cursor = page.cursor;
        _hasMore = page.hasMore;
        _searched = true;
      });
    } catch (e) {
      // A missing composite index shows up here with a console link in debug logs.
      debugPrint('Search error: $e');
      setState(() => _error = AppLocalizations.of(context).searchFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.findGame)),
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
          if (_error != null)
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          if (_searched && _results.isEmpty && !_loading && _error == null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.noResults, textAlign: TextAlign.center),
            ),
          for (final g in _results)
            GameCard(
              game: g,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => GameDetailScreen(gameId: g.id!, uid: widget.uid, profile: widget.profile),
              )),
            ),
          if (_loading) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
          if (_hasMore && !_loading)
            TextButton(onPressed: () => _search(more: true), child: Text(l10n.loadMore)),
        ],
      ),
    );
  }

  Widget _filterForm(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownMenu<String>(
            width: c.maxWidth,
            label: Text(l10n.systemLabel),
            initialSelection: _system ?? '',
            enableFilter: true,
            requestFocusOnTap: true,
            menuHeight: 320,
            dropdownMenuEntries: [
              DropdownMenuEntry(value: '', label: l10n.filterAll),
              for (final id in gameSystems.keys) DropdownMenuEntry(value: id, label: systemLabel(l10n, id)),
            ],
            onSelected: (id) => setState(() => _system = (id == null || id.isEmpty) ? null : id),
          ),
          const SizedBox(height: 12),
          DropdownMenu<String>(
            width: c.maxWidth,
            label: Text(l10n.platformLabel),
            initialSelection: _platform ?? '',
            dropdownMenuEntries: [
              DropdownMenuEntry(value: '', label: l10n.filterAll),
              for (final id in platformIds) DropdownMenuEntry(value: id, label: platformLabel(l10n, id)),
            ],
            onSelected: (id) => setState(() => _platform = (id == null || id.isEmpty) ? null : id),
          ),
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
                child: DropdownMenu<String>(
                  expandedInsets: EdgeInsets.zero,
                  label: Text(l10n.gameTypeLabel),
                  initialSelection: _gameType ?? '',
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: '', label: l10n.filterAll),
                    for (final id in gameTypeIds) DropdownMenuEntry(value: id, label: gameTypeLabel(l10n, id)),
                  ],
                  onSelected: (id) => setState(() => _gameType = (id == null || id.isEmpty) ? null : id),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownMenu<String>(
                  expandedInsets: EdgeInsets.zero,
                  label: Text(l10n.gameLanguageLabel),
                  initialSelection: _language ?? '',
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: '', label: l10n.filterAll),
                    for (final id in gameLanguageIds)
                      DropdownMenuEntry(value: id, label: gameLanguageLabel(l10n, id)),
                  ],
                  onSelected: (id) => setState(() => _language = (id == null || id.isEmpty) ? null : id),
                ),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.beginnerOnly),
            value: _beginnerOnly,
            onChanged: (v) => setState(() => _beginnerOnly = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.freeOnly),
            value: _freeOnly,
            onChanged: (v) => setState(() => _freeOnly = v),
          ),
        ],
      ),
    );
  }
}
