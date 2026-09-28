// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'TableFinder';

  @override
  String get tagline => 'Masanı bul. Oyuncularını bul.';

  @override
  String get ageConfirmation => '18 yaşından büyük olduğumu onaylıyorum.';

  @override
  String get signInWithGoogle => 'Google ile giriş yap';

  @override
  String get signInFailed => 'Giriş yapılamadı. Lütfen tekrar deneyin.';

  @override
  String welcomeUser(String name) {
    return 'Hoş geldin, $name!';
  }

  @override
  String get homePlaceholder => 'Oyun ilanları yakında burada olacak.';

  @override
  String get signOut => 'Çıkış yap';
}
