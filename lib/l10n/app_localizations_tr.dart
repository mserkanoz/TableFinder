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

  @override
  String get profileSetupTitle => 'Profilini oluştur';

  @override
  String get profileEditTitle => 'Profili düzenle';

  @override
  String get nicknameLabel => 'Takma ad';

  @override
  String get nicknameHelper =>
      'Diğer kullanıcılar gerçek adın yerine bunu görür.';

  @override
  String get nicknameError => '2–30 karakter gir.';

  @override
  String get rolesLabel => 'Rol';

  @override
  String get rolesHelper => 'İkisini birden seçebilirsin.';

  @override
  String get rolePlayer => 'Oyuncu';

  @override
  String get roleDm => 'DM / GM';

  @override
  String get systemsLabel => 'Oyun sistemleri';

  @override
  String get platformsLabel => 'Nerede oynuyorsun?';

  @override
  String get platformInPerson => 'Yüz yüze';

  @override
  String get optionOther => 'Diğer';

  @override
  String get locationLabel => 'Konum';

  @override
  String get locationHelperRequired => 'Yüz yüze oyunlar için gerekli.';

  @override
  String get locationHelperOptional => 'Sadece online oynuyorsan isteğe bağlı.';

  @override
  String get cityLabel => 'İl';

  @override
  String get districtLabel => 'İlçe';

  @override
  String get bioLabel => 'Hakkında';

  @override
  String get bioHint => 'Deneyimin, sevdiğin evrenler, ne zaman uygun olduğun…';

  @override
  String get selectAtLeastOne => 'En az birini seç.';

  @override
  String get locationRequired => 'Bir il ve ilçe seç.';

  @override
  String get save => 'Kaydet';

  @override
  String get saveFailed => 'Kaydedilemedi. Lütfen tekrar deneyin.';
}
