import 'package:flutter/material.dart';

import '../../data/game_options.dart';
import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/form_section.dart';
import '../../widgets/location_picker.dart';
import '../../widgets/page_padding.dart';
import '../profile/user_profile.dart';
import 'seeker_post.dart';
import 'seeker_repository.dart';

/// Creates a "looking for group" post (when [initial] is null) or edits one.
class SeekerFormScreen extends StatefulWidget {
  const SeekerFormScreen({
    super.key,
    required this.uid,
    required this.profile,
    this.initial,
    this.existing = const [],
  });

  final String uid;
  final UserProfile profile;
  final SeekerPost? initial;

  /// The user's current posts, used to pick a free slot for a new one.
  final List<SeekerPost> existing;

  bool get isNew => initial == null;

  @override
  State<SeekerFormScreen> createState() => _SeekerFormScreenState();
}

class _SeekerFormScreenState extends State<SeekerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _availability;
  late final TextEditingController _description;
  late final Set<String> _systems;
  late final Set<String> _platforms;
  late final Set<String> _gameTypes;
  late final Set<String> _languages;
  int? _cityCode;
  String? _district;
  String? _experience;
  late bool _openToPaid;
  late String _status;
  bool _showErrors = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    final p = widget.profile;
    // New posts start from the player's profile.
    _availability = TextEditingController(text: s?.availability ?? '');
    _description = TextEditingController(text: s?.description ?? '');
    _systems = {...(s?.systems ?? p.systems)};
    _platforms = {...(s?.platforms ?? p.platforms)};
    _gameTypes = {...(s?.gameTypes ?? gameTypeIds)};
    final deviceLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    _languages = {...(s?.languages ?? {deviceLang == 'en' ? 'en' : 'tr'})};
    _cityCode = s?.cityCode ?? p.cityCode;
    _district = s?.district ?? p.district;
    _experience = s?.experience;
    _openToPaid = s?.openToPaid ?? false;
    _status = s?.status ?? 'open';
  }

  @override
  void dispose() {
    _availability.dispose();
    _description.dispose();
    super.dispose();
  }

  bool get _inPerson => _platforms.contains('in_person');

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _showErrors = true);
    final valid = _formKey.currentState!.validate() &&
        _systems.isNotEmpty &&
        _platforms.isNotEmpty &&
        _gameTypes.isNotEmpty &&
        _languages.isNotEmpty &&
        _experience != null &&
        (!_inPerson || (_cityCode != null && _district != null));
    if (!valid) return;

    setState(() => _saving = true);
    final post = SeekerPost(
      id: widget.initial?.id,
      ownerUid: widget.uid,
      ownerNickname: widget.profile.nickname,
      systems: _systems,
      platforms: _platforms,
      cityCode: _inPerson ? _cityCode : null,
      district: _inPerson ? _district : null,
      gameTypes: _gameTypes,
      languages: _languages,
      experience: _experience!,
      availability: _availability.text.trim(),
      openToPaid: _openToPaid,
      description: _description.text.trim(),
      status: _status,
    );
    try {
      await SeekerRepository.instance.save(post, existing: widget.existing);
      if (mounted) Navigator.of(context).pop();
    } on SeekerLimitException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.seekerLimitReached)));
      }
    } catch (e) {
      debugPrint('Seeker save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.deletePostConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await SeekerRepository.instance.delete(widget.initial!.id!);
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String? missing(bool empty) => _showErrors && empty ? l10n.selectAtLeastOne : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? l10n.newSeekerTitle : l10n.editSeekerTitle),
        actions: [
          if (!widget.isNew)
            IconButton(tooltip: l10n.delete, icon: const Icon(Icons.delete_outline), onPressed: _delete),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: pagePadding(context, top: 0),
          children: [
            FormSection(
              title: l10n.systemsLabel,
              error: missing(_systems.isEmpty),
              child: _chips(gameSystems.keys, _systems, (id) => systemLabel(l10n, id)),
            ),
            FormSection(
              title: l10n.platformsLabel,
              error: missing(_platforms.isEmpty),
              child: _chips(platformIds, _platforms, (id) => platformLabel(l10n, id)),
            ),
            if (_inPerson)
              FormSection(
                title: l10n.locationLabel,
                helper: l10n.locationHelperRequired,
                error: _showErrors && (_cityCode == null || _district == null) ? l10n.locationRequired : null,
                child: LocationPicker(
                  cityCode: _cityCode,
                  district: _district,
                  onChanged: (city, district) => setState(() {
                    _cityCode = city;
                    _district = district;
                  }),
                ),
              ),
            FormSection(
              title: l10n.gameTypesLabel,
              error: missing(_gameTypes.isEmpty),
              child: _chips(gameTypeIds, _gameTypes, (id) => gameTypeLabel(l10n, id)),
            ),
            FormSection(
              title: l10n.languagesLabel,
              error: missing(_languages.isEmpty),
              child: _chips(gameLanguageIds, _languages, (id) => gameLanguageLabel(l10n, id)),
            ),
            FormSection(
              title: l10n.experienceLabel,
              error: missing(_experience == null),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final id in experienceIds)
                    ChoiceChip(
                      label: Text(experienceLabel(l10n, id)),
                      selected: _experience == id,
                      onSelected: (_) => setState(() => _experience = id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _availability,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: l10n.availabilityLabel,
                hintText: l10n.availabilityHint,
                border: const OutlineInputBorder(),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.openToPaidLabel),
              value: _openToPaid,
              onChanged: (v) => setState(() => _openToPaid = v),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _description,
              maxLength: 1000,
              minLines: 3,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: l10n.descriptionLabel,
                hintText: l10n.seekerDescriptionHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            if (!widget.isNew)
              FormSection(
                title: l10n.statusLabel,
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: [
                      for (final id in seekerStatusIds)
                        ButtonSegment(value: id, label: Text(gameStatusLabel(l10n, id))),
                    ],
                    selected: {_status},
                    onSelectionChanged: (s) => setState(() => _status = s.first),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chips(Iterable<String> ids, Set<String> selected, String Function(String) label) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final id in ids)
          FilterChip(
            label: Text(label(id)),
            selected: selected.contains(id),
            onSelected: (on) => setState(() => on ? selected.add(id) : selected.remove(id)),
          ),
      ],
    );
  }
}
