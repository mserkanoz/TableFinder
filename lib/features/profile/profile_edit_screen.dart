import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/game_options.dart';
import '../../data/option_labels.dart';
import '../../data/turkey_locations.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_service.dart';
import 'profile_repository.dart';
import 'user_profile.dart';

/// Creates a profile (when [initial] is null) or edits an existing one.
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key, required this.user, this.initial});

  final User user;
  final UserProfile? initial;

  bool get isNew => initial == null;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nickname;
  late final TextEditingController _bio;
  late final Set<String> _roles;
  late final Set<String> _systems;
  late final Set<String> _platforms;
  int? _cityCode;
  String? _district;
  bool _showErrors = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    final googleFirstName = (widget.user.displayName ?? '').split(' ').first;
    _nickname = TextEditingController(text: p?.nickname ?? googleFirstName);
    _bio = TextEditingController(text: p?.bio ?? '');
    _roles = {...?p?.roles};
    _systems = {...?p?.systems};
    _platforms = {...?p?.platforms};
    _cityCode = p?.cityCode;
    _district = p?.district;
  }

  @override
  void dispose() {
    _nickname.dispose();
    _bio.dispose();
    super.dispose();
  }

  bool get _locationRequired => _platforms.contains('in_person');
  bool get _locationValid => !_locationRequired || (_cityCode != null && _district != null);

  Future<void> _save() async {
    setState(() => _showErrors = true);
    final formOk = _formKey.currentState!.validate();
    if (!formOk || _roles.isEmpty || _systems.isEmpty || _platforms.isEmpty || !_locationValid) {
      return;
    }
    setState(() => _saving = true);
    final profile = UserProfile(
      nickname: _nickname.text.trim(),
      roles: _roles,
      systems: _systems,
      platforms: _platforms,
      cityCode: _cityCode,
      district: _cityCode == null ? null : _district,
      bio: _bio.text.trim(),
    );
    try {
      await ProfileRepository.instance.save(widget.user.uid, profile, isNew: widget.isNew);
      // New profiles are picked up by AuthGate; edits return to the previous screen.
      if (mounted && !widget.isNew) Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Profile save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).saveFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? l10n.profileSetupTitle : l10n.profileEditTitle),
        actions: [
          if (widget.isNew)
            IconButton(
              tooltip: l10n.signOut,
              icon: const Icon(Icons.logout),
              onPressed: AuthService.instance.signOut,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            TextFormField(
              controller: _nickname,
              maxLength: 30,
              decoration: InputDecoration(
                labelText: l10n.nicknameLabel,
                helperText: l10n.nicknameHelper,
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                final len = (v ?? '').trim().length;
                return len < 2 || len > 30 ? l10n.nicknameError : null;
              },
            ),
            _Section(
              title: l10n.rolesLabel,
              helper: l10n.rolesHelper,
              error: _showErrors && _roles.isEmpty ? l10n.selectAtLeastOne : null,
              child: _chips(roleIds, _roles, (id) => roleLabel(l10n, id)),
            ),
            _Section(
              title: l10n.systemsLabel,
              error: _showErrors && _systems.isEmpty ? l10n.selectAtLeastOne : null,
              child: _chips(gameSystems.keys, _systems, (id) => systemLabel(l10n, id)),
            ),
            _Section(
              title: l10n.platformsLabel,
              error: _showErrors && _platforms.isEmpty ? l10n.selectAtLeastOne : null,
              child: _chips(platformIds, _platforms, (id) => platformLabel(l10n, id)),
            ),
            _Section(
              title: l10n.locationLabel,
              helper: _locationRequired ? l10n.locationHelperRequired : l10n.locationHelperOptional,
              error: _showErrors && !_locationValid ? l10n.locationRequired : null,
              child: _locationPickers(l10n),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _bio,
              maxLength: 500,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: l10n.bioLabel,
                hintText: l10n.bioHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
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

  Widget _locationPickers(AppLocalizations l10n) {
    final province = provinceByCode(_cityCode);
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          DropdownMenu<int>(
            width: constraints.maxWidth,
            label: Text(l10n.cityLabel),
            initialSelection: _cityCode,
            enableFilter: true,
            requestFocusOnTap: true,
            menuHeight: 320,
            dropdownMenuEntries: [
              for (final p in provincesSorted) DropdownMenuEntry(value: p.code, label: p.name),
            ],
            onSelected: (code) => setState(() {
              if (code != _cityCode) _district = null;
              _cityCode = code;
            }),
          ),
          const SizedBox(height: 12),
          DropdownMenu<String>(
            // Rebuild when the province changes so the old district is cleared.
            key: ValueKey(_cityCode),
            width: constraints.maxWidth,
            label: Text(l10n.districtLabel),
            enabled: province != null,
            initialSelection: _district,
            enableFilter: true,
            requestFocusOnTap: true,
            menuHeight: 320,
            dropdownMenuEntries: [
              if (province != null)
                for (final d in sortedDistricts(province)) DropdownMenuEntry(value: d, label: d),
            ],
            onSelected: (d) => setState(() => _district = d),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.helper, this.error});

  final String title;
  final String? helper;
  final String? error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          if (helper != null)
            Text(helper!, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          child,
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(error!, style: TextStyle(color: theme.colorScheme.error)),
            ),
        ],
      ),
    );
  }
}
