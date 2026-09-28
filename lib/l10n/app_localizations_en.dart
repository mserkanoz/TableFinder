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
}
