// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TableFinder';

  @override
  String get tagline => 'Find your table. Find your players.';

  @override
  String get ageConfirmation => 'I confirm that I am 18 years of age or older.';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInFailed => 'Sign-in failed. Please try again.';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get homePlaceholder => 'Game listings will appear here soon.';

  @override
  String get signOut => 'Sign out';

  @override
  String get profileSetupTitle => 'Create your profile';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameHelper =>
      'Shown to other users instead of your real name.';

  @override
  String get nicknameError => 'Enter 2–30 characters.';

  @override
  String get rolesLabel => 'Role';

  @override
  String get rolesHelper => 'You can pick both.';

  @override
  String get rolePlayer => 'Player';

  @override
  String get roleDm => 'DM / GM';

  @override
  String get systemsLabel => 'Game systems';

  @override
  String get platformsLabel => 'Where do you play?';

  @override
  String get platformInPerson => 'In person';

  @override
  String get optionOther => 'Other';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationHelperRequired => 'Required for in-person games.';

  @override
  String get locationHelperOptional => 'Optional if you only play online.';

  @override
  String get cityLabel => 'Province';

  @override
  String get districtLabel => 'District';

  @override
  String get bioLabel => 'About you';

  @override
  String get bioHint =>
      'Experience, favourite settings, when you\'re available…';

  @override
  String get selectAtLeastOne => 'Select at least one.';

  @override
  String get locationRequired => 'Select a province and a district.';

  @override
  String get save => 'Save';

  @override
  String get saveFailed => 'Could not save. Please try again.';
}
