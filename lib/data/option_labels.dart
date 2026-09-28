import '../l10n/app_localizations.dart';
import 'game_options.dart';

String roleLabel(AppLocalizations l10n, String id) =>
    id == 'dm' ? l10n.roleDm : l10n.rolePlayer;

String platformLabel(AppLocalizations l10n, String id) => switch (id) {
      'in_person' => l10n.platformInPerson,
      'other' => l10n.optionOther,
      _ => platformBrandNames[id] ?? id,
    };

String systemLabel(AppLocalizations l10n, String id) =>
    id == 'other' ? l10n.optionOther : gameSystems[id] ?? id;
