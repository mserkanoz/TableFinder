import 'package:flutter/material.dart';

import '../../data/game_options.dart';
import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/form_section.dart';
import '../../widgets/location_picker.dart';
import '../profile/user_profile.dart';
import 'game_card.dart';
import 'game_listing.dart';
import 'game_repository.dart';

/// Creates a listing (when [initial] is null) or edits an existing one.
class GameFormScreen extends StatefulWidget {
  const GameFormScreen({super.key, required this.uid, required this.profile, this.initial});

  final String uid;
  final UserProfile profile;
  final GameListing? initial;

  bool get isNew => initial == null;

  @override
  State<GameFormScreen> createState() => _GameFormScreenState();
}

class _GameFormScreenState extends State<GameFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _contact;
  late final TextEditingController _price;
  String? _system;
  String? _platform;
  int? _cityCode;
  String? _district;
  late String _gameType;
  late String _campaignStage;
  String? _frequency;
  DateTime? _sessionAt;
  late int _seatsTotal;
  late int _seatsOpen;
  late String _language;
  late bool _beginnerFriendly;
  late bool _paid;
  late String _status;
  bool _showErrors = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final g = widget.initial;
    final p = widget.profile;
    _title = TextEditingController(text: g?.title ?? '');
    _description = TextEditingController(text: g?.description ?? '');
    _contact = TextEditingController();
    _price = TextEditingController(text: g?.price?.toString() ?? '');
    // New listings start from the DM's profile where it makes sense.
    _system = g?.system ?? (p.systems.length == 1 ? p.systems.first : null);
    _platform = g?.platform ?? (p.platforms.length == 1 ? p.platforms.first : null);
    _cityCode = g?.cityCode ?? p.cityCode;
    _district = g?.district ?? p.district;
    _gameType = g?.gameType ?? 'campaign';
    _campaignStage = g?.campaignStage ?? 'new';
    _frequency = g?.frequency;
    _sessionAt = g?.sessionAt;
    _seatsTotal = g?.seatsTotal ?? 4;
    _seatsOpen = g?.seatsOpen ?? 4;
    final deviceLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    _language = g?.language ?? (deviceLang == 'en' ? 'en' : 'tr');
    _beginnerFriendly = g?.beginnerFriendly ?? false;
    _paid = g?.paid ?? false;
    _status = g?.status ?? 'open';
    if (g?.id != null) {
      GameRepository.instance.loadContactNote(g!.id!).then((note) {
        if (mounted && _contact.text.isEmpty) _contact.text = note;
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _contact.dispose();
    _price.dispose();
    super.dispose();
  }

  bool get _isCampaign => _gameType == 'campaign';
  bool get _isOngoing => _isCampaign && _campaignStage == 'ongoing';
  bool get _inPerson => _platform == 'in_person';

  String? _sessionError(AppLocalizations l10n) {
    if (_sessionAt == null) return _isOngoing ? null : l10n.dateRequired;
    final changed = _sessionAt != widget.initial?.sessionAt;
    return changed && _sessionAt!.isBefore(DateTime.now()) ? l10n.dateInPast : null;
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initial = _sessionAt ?? now.add(const Duration(days: 7));
    final date = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 19, minute: 0));
    if (time == null) return;
    setState(() => _sessionAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _showErrors = true);
    final formOk = _formKey.currentState!.validate();
    final valid = formOk &&
        _system != null &&
        _platform != null &&
        (!_inPerson || (_cityCode != null && _district != null)) &&
        (!_isCampaign || _frequency != null) &&
        _sessionError(l10n) == null;
    if (!valid) return;

    setState(() => _saving = true);
    final game = GameListing(
      id: widget.initial?.id,
      ownerUid: widget.uid,
      ownerNickname: widget.profile.nickname,
      title: _title.text.trim(),
      system: _system!,
      platform: _platform!,
      cityCode: _inPerson ? _cityCode : null,
      district: _inPerson ? _district : null,
      gameType: _gameType,
      campaignStage: _isCampaign ? _campaignStage : null,
      frequency: _isCampaign ? _frequency : null,
      sessionAt: _sessionAt,
      seatsTotal: _seatsTotal,
      seatsOpen: _seatsOpen,
      language: _language,
      beginnerFriendly: _beginnerFriendly,
      paid: _paid,
      price: _paid ? int.parse(_price.text.trim()) : null,
      description: _description.text.trim(),
      // No open seats means the table is full.
      status: _status == 'open' && _seatsOpen == 0 ? 'full' : _status,
    );
    try {
      await GameRepository.instance.save(game, _contact.text.trim());
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Game save error: $e');
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
        content: Text(l10n.deleteGameConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await GameRepository.instance.delete(widget.initial!.id!, widget.uid);
    // Close the form and the detail screen behind it.
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sessionError = _showErrors ? _sessionError(l10n) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? l10n.newGameTitle : l10n.editGameTitle),
        actions: [
          if (!widget.isNew)
            IconButton(tooltip: l10n.delete, icon: const Icon(Icons.delete_outline), onPressed: _delete),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            TextFormField(
              controller: _title,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: l10n.gameTitleLabel,
                hintText: l10n.gameTitleHint,
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                final len = (v ?? '').trim().length;
                return len < 3 || len > 80 ? l10n.gameTitleError : null;
              },
            ),
            FormSection(
              title: l10n.systemLabel,
              error: _showErrors && _system == null ? l10n.selectAtLeastOne : null,
              child: LayoutBuilder(
                builder: (context, c) => DropdownMenu<String>(
                  width: c.maxWidth,
                  initialSelection: _system,
                  enableFilter: true,
                  requestFocusOnTap: true,
                  menuHeight: 320,
                  dropdownMenuEntries: [
                    for (final id in gameSystems.keys)
                      DropdownMenuEntry(value: id, label: systemLabel(l10n, id)),
                  ],
                  onSelected: (id) => setState(() => _system = id),
                ),
              ),
            ),
            FormSection(
              title: l10n.platformLabel,
              error: _showErrors && _platform == null ? l10n.selectAtLeastOne : null,
              child: _choiceChips(platformIds, _platform, (id) => platformLabel(l10n, id),
                  (id) => _platform = id),
            ),
            if (_inPerson)
              FormSection(
                title: l10n.locationLabel,
                helper: l10n.gameLocationHelper,
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
              title: l10n.gameTypeLabel,
              child: _segmented(gameTypeIds, _gameType, (id) => gameTypeLabel(l10n, id),
                  (id) => _gameType = id),
            ),
            if (_isCampaign) ...[
              FormSection(
                title: l10n.campaignStageLabel,
                helper: _isOngoing ? l10n.campaignOngoingHelper : null,
                child: _segmented(campaignStageIds, _campaignStage,
                    (id) => campaignStageLabel(l10n, id), (id) => _campaignStage = id),
              ),
              FormSection(
                title: l10n.frequencyLabel,
                error: _showErrors && _frequency == null ? l10n.selectAtLeastOne : null,
                child: _choiceChips(frequencyIds, _frequency, (id) => frequencyLabel(l10n, id),
                    (id) => _frequency = id),
              ),
            ],
            FormSection(
              title: _isOngoing ? l10n.sessionNext : l10n.sessionFirst,
              helper: _isOngoing ? l10n.sessionOptional : null,
              error: sessionError,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDateTime,
                      icon: const Icon(Icons.event_outlined),
                      label: Text(_sessionAt == null
                          ? l10n.pickDateTime
                          : formatSessionTime(context, _sessionAt!)),
                    ),
                  ),
                  if (_isOngoing && _sessionAt != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _sessionAt = null),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Expanded(
                    child: _numberDropdown(l10n.seatsTotalLabel, _seatsTotal, 1, maxTableSize, (v) {
                      _seatsTotal = v;
                      if (_seatsOpen > v) _seatsOpen = v;
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberDropdown(l10n.seatsOpenLabel, _seatsOpen, 0, _seatsTotal,
                        (v) => _seatsOpen = v),
                  ),
                ],
              ),
            ),
            FormSection(
              title: l10n.gameLanguageLabel,
              child: _segmented(gameLanguageIds, _language, (id) => gameLanguageLabel(l10n, id),
                  (id) => _language = id),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.beginnerFriendlyLabel),
              value: _beginnerFriendly,
              onChanged: (v) => setState(() => _beginnerFriendly = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.paidLabel),
              value: _paid,
              onChanged: (v) => setState(() => _paid = v),
            ),
            if (_paid)
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.priceLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  return n == null || n < 1 || n > 100000 ? l10n.priceError : null;
                },
              ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _description,
              maxLength: 2000,
              minLines: 4,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: l10n.descriptionLabel,
                hintText: l10n.descriptionHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contact,
              maxLength: 500,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: l10n.contactNoteLabel,
                helperText: l10n.contactNoteHelper,
                helperMaxLines: 3,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            if (!widget.isNew)
              FormSection(
                title: l10n.statusLabel,
                child: _segmented(gameStatusIds, _status, (id) => gameStatusLabel(l10n, id),
                    (id) => _status = id),
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

  Widget _choiceChips(List<String> ids, String? selected, String Function(String) label,
      void Function(String) onSelect) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final id in ids)
          ChoiceChip(
            label: Text(label(id)),
            selected: selected == id,
            onSelected: (_) => setState(() => onSelect(id)),
          ),
      ],
    );
  }

  Widget _segmented(List<String> ids, String selected, String Function(String) label,
      void Function(String) onSelect) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [for (final id in ids) ButtonSegment(value: id, label: Text(label(id)))],
        selected: {selected},
        onSelectionChanged: (s) => setState(() => onSelect(s.first)),
      ),
    );
  }

  Widget _numberDropdown(String label, int value, int min, int max, void Function(int) onChanged) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      // Re-create when the range changes so the value stays within it.
      key: ValueKey('$label-$min-$max-$value'),
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: [for (var i = min; i <= max; i++) DropdownMenuItem(value: i, child: Text('$i'))],
      onChanged: (v) => setState(() => onChanged(v!)),
    );
  }
}
