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

String gameTypeLabel(AppLocalizations l10n, String id) =>
    id == 'campaign' ? l10n.gameTypeCampaign : l10n.gameTypeOneShot;

String campaignStageLabel(AppLocalizations l10n, String id) =>
    id == 'ongoing' ? l10n.campaignOngoing : l10n.campaignNew;

String frequencyLabel(AppLocalizations l10n, String id) => switch (id) {
      'weekly' => l10n.freqWeekly,
      'biweekly' => l10n.freqBiweekly,
      'monthly' => l10n.freqMonthly,
      _ => l10n.freqIrregular,
    };

String gameLanguageLabel(AppLocalizations l10n, String id) =>
    id == 'en' ? l10n.langEnglish : l10n.langTurkish;

String gameStatusLabel(AppLocalizations l10n, String id) => switch (id) {
      'full' => l10n.statusFull,
      'closed' => l10n.statusClosed,
      _ => l10n.statusOpen,
    };

String applicationStatusLabel(AppLocalizations l10n, String id) => switch (id) {
      'accepted' => l10n.appAccepted,
      'rejected' => l10n.appRejected,
      'removed' => l10n.appRemoved,
      'withdrawn' => l10n.appWithdrawn,
      _ => l10n.appPending,
    };

String experienceLabel(AppLocalizations l10n, String id) => switch (id) {
      'veteran' => l10n.expVeteran,
      'some' => l10n.expSome,
      _ => l10n.expNew,
    };
