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
  String get signOut => 'Çıkış yap';

  @override
  String get profileSetupTitle => 'Profilini oluştur';

  @override
  String get profileEditTitle => 'Profili düzenle';

  @override
  String get nicknameLabel => 'Takma ad';

  @override
  String get nicknameHelper =>
      'Diğer kullanıcılar gerçek adın yerine bunu görür. Benzersiz olmalı.';

  @override
  String get nicknameError =>
      '3–24 karakter kullan: İngilizce harfler (A–Z) ve rakamlar; kelimeler arasında tek boşluk, _ veya . olabilir.';

  @override
  String get nicknameTaken => 'Bu takma ad zaten alınmış.';

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

  @override
  String get postGame => 'İlan ver';

  @override
  String get findGame => 'İlan ara';

  @override
  String get myTables => 'Masalarım';

  @override
  String get noTablesYet => 'Henüz ilan vermedin.';

  @override
  String get newGameTitle => 'Yeni ilan';

  @override
  String get editGameTitle => 'İlanı düzenle';

  @override
  String get gameTitleLabel => 'Başlık';

  @override
  String get gameTitleHint => 'Örn. Curse of Strahd – yeni başlayanlara açık';

  @override
  String get gameTitleError => '3–80 karakter gir.';

  @override
  String get systemLabel => 'Oyun sistemi';

  @override
  String get platformLabel => 'Platform';

  @override
  String get gameTypeLabel => 'Oyun tipi';

  @override
  String get gameTypeOneShot => 'Tek seferlik';

  @override
  String get gameTypeCampaign => 'Kampanya';

  @override
  String get campaignStageLabel => 'Kampanya durumu';

  @override
  String get campaignNew => 'Yeni oyun';

  @override
  String get campaignOngoing => 'Devam eden oyun';

  @override
  String get campaignOngoingHelper =>
      'Oyun zaten sürüyor, yeni oyuncu aranıyor.';

  @override
  String get frequencyLabel => 'Ne sıklıkla?';

  @override
  String get freqWeekly => 'Haftalık';

  @override
  String get freqBiweekly => 'İki haftada bir';

  @override
  String get freqMonthly => 'Aylık';

  @override
  String get freqIrregular => 'Düzensiz';

  @override
  String get sessionFirst => 'İlk oturum';

  @override
  String get sessionNext => 'Sonraki oturum';

  @override
  String get sessionOptional => 'Devam eden oyunlarda isteğe bağlı.';

  @override
  String get pickDateTime => 'Tarih ve saat seç';

  @override
  String get dateRequired => 'Bir tarih ve saat seç.';

  @override
  String get dateInPast => 'Tarih ileri bir zaman olmalı.';

  @override
  String get seatsTotalLabel => 'Masadaki oyuncu sayısı';

  @override
  String get seatsOpenLabel => 'Boş yer';

  @override
  String seatsSummary(int open, int total) {
    return '$open/$total yer boş';
  }

  @override
  String get gameLanguageLabel => 'Oyun dili';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langEnglish => 'İngilizce';

  @override
  String get langBulgarian => 'Bulgarca';

  @override
  String get beginnerFriendlyLabel => 'Yeni başlayanlara uygun';

  @override
  String get paidLabel => 'Ücretli oyun';

  @override
  String get priceLabel => 'Oyuncu başı oturum ücreti (₺)';

  @override
  String get priceError => 'Geçerli bir tutar gir.';

  @override
  String get free => 'Ücretsiz';

  @override
  String pricePerSession(int price) {
    return 'Oturum başı ₺$price';
  }

  @override
  String get descriptionLabel => 'Açıklama';

  @override
  String get descriptionHint =>
      'Evren, oyunun havası, ev kuralları, oyunculardan beklentilerin…';

  @override
  String get contactNoteLabel => 'İletişim notu (gizli)';

  @override
  String get contactNoteHelper =>
      'Bunu sadece kabul ettiğin oyuncular görür: Discord daveti, grup linki, açık adres…';

  @override
  String get gameLocationHelper =>
      'Herkes sadece il ve ilçeyi görür. Açık adresi iletişim notuna yaz.';

  @override
  String get statusLabel => 'Durum';

  @override
  String get statusOpen => 'Açık';

  @override
  String get statusFull => 'Dolu';

  @override
  String get statusClosed => 'Kapalı';

  @override
  String get delete => 'Sil';

  @override
  String get cancel => 'İptal';

  @override
  String get deleteGameConfirm =>
      'Bu ilan silinsin mi? Bu işlem geri alınamaz.';

  @override
  String hostedBy(String name) {
    return 'DM: $name';
  }

  @override
  String get edit => 'Düzenle';

  @override
  String get filtersTitle => 'Filtreler';

  @override
  String get filterAll => 'Tümü';

  @override
  String get beginnerOnly => 'Sadece yeni başlayanlara uygun';

  @override
  String get freeOnly => 'Sadece ücretsiz oyunlar';

  @override
  String get searchButton => 'Ara';

  @override
  String get noResults => 'Filtrelere uyan ilan bulunamadı.';

  @override
  String get loadMore => 'Daha fazla yükle';

  @override
  String get gameNotFound => 'Bu ilan artık mevcut değil.';

  @override
  String get yourListing => 'Bu senin ilanın.';

  @override
  String get apply => 'Başvur';

  @override
  String get applyDialogTitle => 'Bu oyuna başvur';

  @override
  String get applyMessageLabel => 'DM\'e mesaj (isteğe bağlı)';

  @override
  String get applyMessageHint =>
      'Kendini tanıt: deneyimin, ne zaman uygun olduğun…';

  @override
  String get send => 'Gönder';

  @override
  String get applicationStatusLabel => 'Başvurun';

  @override
  String get appPending => 'Bekliyor';

  @override
  String get appAccepted => 'Kabul edildi';

  @override
  String get appRejected => 'Kabul edilmedi';

  @override
  String get appWithdrawn => 'Geri çekildi';

  @override
  String get appRemoved => 'Masadan çıkarıldı';

  @override
  String get withdraw => 'Geri çek';

  @override
  String get withdrawConfirm => 'Başvurun geri çekilsin mi?';

  @override
  String get applyAgain => 'Tekrar başvur';

  @override
  String get contactNoteTitle => 'DM\'in iletişim notu';

  @override
  String get noContactNote => 'DM henüz iletişim notu eklemedi.';

  @override
  String get applicationsTitle => 'Başvurular';

  @override
  String get noApplications => 'Henüz başvuru yok.';

  @override
  String get accept => 'Kabul et';

  @override
  String get reject => 'Reddet';

  @override
  String get removePlayer => 'Masadan çıkar';

  @override
  String removePlayerConfirm(String name) {
    return '$name masadan çıkarılsın mı? Yeri tekrar açılacak.';
  }

  @override
  String get playerRoleNeeded => 'Başvurmak için profiline Oyuncu rolünü ekle.';

  @override
  String get gameNotOpen => 'Bu ilan şu an başvuru kabul etmiyor.';

  @override
  String get myApplications => 'Başvurularım';

  @override
  String get noApplicationsYet => 'Henüz bir oyuna başvurmadın.';

  @override
  String pendingApplications(int count) {
    return '$count yeni başvuru';
  }

  @override
  String get actionFailed => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get searchFailed => 'Arama yapılamadı. Biraz sonra tekrar deneyin.';

  @override
  String get postSeeker => 'Grup ilanı ver';

  @override
  String get findPlayers => 'Oyuncu ara';

  @override
  String get mySeekerPosts => 'Grup ilanlarım';

  @override
  String get noSeekerPostsYet => 'Henüz \"grup arıyorum\" ilanın yok.';

  @override
  String get seekerLimitReached =>
      'En fazla 3 grup ilanın olabilir. Yenisi için birini sil.';

  @override
  String get newSeekerTitle => 'Grup arıyorum';

  @override
  String get editSeekerTitle => 'Grup ilanını düzenle';

  @override
  String get lookingForGroup => 'Grup arıyor';

  @override
  String get gameTypesLabel => 'Oyun tipleri';

  @override
  String get languagesLabel => 'Diller';

  @override
  String get experienceLabel => 'Deneyim';

  @override
  String get expNew => 'Yeni başlayan';

  @override
  String get expSome => 'Biraz deneyimli';

  @override
  String get expVeteran => 'Tecrübeli';

  @override
  String get availabilityLabel => 'Ne zaman uygunsun?';

  @override
  String get availabilityHint => 'Örn. hafta içi akşamları, cumartesi gündüz';

  @override
  String get openToPaidLabel => 'Ücretli oyunlara açığım';

  @override
  String get seekerDescriptionHint => 'Nasıl bir oyun ve grup arıyorsun?';

  @override
  String postedBy(String name) {
    return 'Oyuncu: $name';
  }

  @override
  String get inviteToTable => 'Masama davet et';

  @override
  String get chooseTable => 'Bir masa seç';

  @override
  String get noOpenTables => 'Davet edebileceğin açık bir masan yok.';

  @override
  String get invited => 'Davet edildi';

  @override
  String get inviteSent => 'Davet gönderildi.';

  @override
  String get myInvites => 'Davetlerim';

  @override
  String inviteText(String dm, String game) {
    return '$dm seni $game masasına davet etti';
  }

  @override
  String get dismiss => 'Yoksay';

  @override
  String get noSeekerResults => 'Filtrelere uyan oyuncu bulunamadı.';

  @override
  String get postNotFound => 'Bu ilan artık mevcut değil.';

  @override
  String get deletePostConfirm =>
      'Bu ilan silinsin mi? Bu işlem geri alınamaz.';

  @override
  String get report => 'Şikâyet et';

  @override
  String get reportReasonLabel => 'Sebep';

  @override
  String get reasonSpam => 'Spam';

  @override
  String get reasonHarassment => 'Taciz veya zorbalık';

  @override
  String get reasonInappropriate => 'Uygunsuz içerik';

  @override
  String get reasonFake => 'Sahte veya yanıltıcı';

  @override
  String get reportDetailsLabel => 'Açıklama (isteğe bağlı)';

  @override
  String get reportSent => 'Teşekkürler, şikâyetini inceleyeceğiz.';

  @override
  String get block => 'Engelle';

  @override
  String get unblock => 'Engeli kaldır';

  @override
  String blockConfirm(String name) {
    return '$name engellensin mi? İlanlarını ve davetlerini görmeyeceksin; sana başvuramayacak ve seni davet edemeyecek.';
  }

  @override
  String get userBlocked => 'Kullanıcı engellendi.';

  @override
  String get blockedUsers => 'Engellenen kullanıcılar';

  @override
  String get noBlockedUsers => 'Kimseyi engellemedin.';

  @override
  String get blockedNotice => 'Bu kullanıcıyı engelledin.';

  @override
  String get deleteAccount => 'Hesabımı sil';

  @override
  String get deleteAccountConfirm =>
      'Bu işlem profilini, takma adını, ilanlarını, grup ilanlarını, başvurularını ve davetlerini kalıcı olarak siler. Geri alınamaz. Onay için Google hesabınla tekrar giriş yapman istenecek.';

  @override
  String get deleteAccountButton => 'Kalıcı olarak sil';

  @override
  String get deletingAccount => 'Hesabın siliniyor…';

  @override
  String get deleteAccountFailed => 'Hesabın silinemedi. Lütfen tekrar dene.';

  @override
  String get messages => 'Mesajlar';

  @override
  String get noChats =>
      'Henüz konuşman yok. Bir ilandan DM\'e, bir başvurudan veya grup ilanından oyuncuya mesaj atabilirsin.';

  @override
  String get messageDm => 'DM\'e mesaj gönder';

  @override
  String get messagePlayer => 'Mesaj gönder';

  @override
  String get messageHint => 'Mesaj yaz…';

  @override
  String get deletedUser => 'Silinmiş kullanıcı';

  @override
  String get chatClosed =>
      'Bu kullanıcı hesabını sildi. Geçmişi okuyabilirsin ama mesaj gönderemezsin.';

  @override
  String get chatBlocked =>
      'Bu kullanıcıyı engelledin. Mesaj göndermek için engeli kaldır.';

  @override
  String get youPrefix => 'Sen: ';

  @override
  String get noMessagesYet => 'Henüz mesaj yok. Bir merhaba de!';

  @override
  String get open => 'Aç';
}
