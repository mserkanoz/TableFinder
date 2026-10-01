import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/game_options.dart';
import '../../data/locations.dart';
import '../../data/option_labels.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/form_section.dart';
import '../../widgets/location_picker.dart';
import '../../widgets/page_padding.dart';
import '../auth/auth_service.dart';
import 'nickname.dart';
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
  late String _country;
  int? _cityCode;
  String? _district;
  bool _showErrors = false;
  bool _nicknameTaken = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    final googleFirstName = (widget.user.displayName ?? '').split(' ').first;
    _nickname = TextEditingController(
        text: p?.nickname ?? (isValidNickname(googleFirstName) ? googleFirstName : ''));
    _bio = TextEditingController(text: p?.bio ?? '');
    _roles = {...?p?.roles};
    _systems = {...?p?.systems};
    _platforms = {...?p?.platforms};
    final deviceLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    _country = p?.country ?? countryForLanguage(deviceLang);
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
      country: _country,
      cityCode: _cityCode,
      district: _cityCode == null ? null : _district,
      bio: _bio.text.trim(),
    );
    try {
      await ProfileRepository.instance.save(widget.user.uid, profile, isNew: widget.isNew);
      // New profiles are picked up by AuthGate; edits return to the previous screen.
      if (mounted && !widget.isNew) Navigator.of(context).pop();
    } on NicknameTakenException {
      if (mounted) setState(() => _nicknameTaken = true);
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
          padding: pagePadding(context),
          children: [
            TextFormField(
              controller: _nickname,
              maxLength: nicknameMaxLength,
              decoration: InputDecoration(
                labelText: l10n.nicknameLabel,
                helperText: l10n.nicknameHelper,
                helperMaxLines: 2,
                errorMaxLines: 3,
                border: const OutlineInputBorder(),
              ),
              forceErrorText: _nicknameTaken ? l10n.nicknameTaken : null,
              onChanged: (_) {
                if (_nicknameTaken) setState(() => _nicknameTaken = false);
              },
              validator: (v) => isValidNickname((v ?? '').trim()) ? null : l10n.nicknameError,
            ),
            FormSection(
              title: l10n.rolesLabel,
              helper: l10n.rolesHelper,
              error: _showErrors && _roles.isEmpty ? l10n.selectAtLeastOne : null,
              child: _chips(roleIds, _roles, (id) => roleLabel(l10n, id)),
            ),
            FormSection(
              title: l10n.systemsLabel,
              error: _showErrors && _systems.isEmpty ? l10n.selectAtLeastOne : null,
              child: _chips(gameSystems.keys, _systems, (id) => systemLabel(l10n, id)),
            ),
            FormSection(
              title: l10n.platformsLabel,
              error: _showErrors && _platforms.isEmpty ? l10n.selectAtLeastOne : null,
              child: _chips(platformIds, _platforms, (id) => platformLabel(l10n, id)),
            ),
            FormSection(
              title: l10n.locationLabel,
              helper: _locationRequired ? l10n.locationHelperRequired : l10n.locationHelperOptional,
              error: _showErrors && !_locationValid ? l10n.locationRequired : null,
              child: LocationPicker(
                country: _country,
                cityCode: _cityCode,
                district: _district,
                onChanged: (country, city, district) => setState(() {
                  _country = country;
                  _cityCode = city;
                  _district = district;
                }),
              ),
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
}

