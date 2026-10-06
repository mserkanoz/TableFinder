// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'TableFinder';

  @override
  String get tagline => 'Намери своята маса. Намери своите играчи.';

  @override
  String get ageConfirmation => 'Потвърждавам, че съм навършил/а 18 години.';

  @override
  String get signInWithGoogle => 'Вход с Google';

  @override
  String get signInFailed => 'Входът не беше успешен. Опитай отново.';

  @override
  String welcomeUser(String name) {
    return 'Добре дошъл/дошла, $name!';
  }

  @override
  String get signOut => 'Изход';

  @override
  String get profileSetupTitle => 'Създай профила си';

  @override
  String get profileEditTitle => 'Редактиране на профила';

  @override
  String get nicknameLabel => 'Псевдоним';

  @override
  String get nicknameHelper =>
      'Показва се на другите вместо истинското ти име. Трябва да е уникален.';

  @override
  String get nicknameError =>
      'Използвай 3–24 знака: английски букви (A–Z) и цифри, с единичен интервал, _ или . между думите.';

  @override
  String get nicknameTaken => 'Този псевдоним вече е зает.';

  @override
  String get rolesLabel => 'Роля';

  @override
  String get rolesHelper => 'Можеш да избереш и двете.';

  @override
  String get rolePlayer => 'Играч';

  @override
  String get roleDm => 'DM / GM';

  @override
  String get systemsLabel => 'Игрови системи';

  @override
  String get platformsLabel => 'Къде играеш?';

  @override
  String get platformInPerson => 'На живо';

  @override
  String get optionOther => 'Друго';

  @override
  String get locationLabel => 'Местоположение';

  @override
  String get locationHelperRequired => 'Задължително за игри на живо.';

  @override
  String get locationHelperOptional => 'По избор, ако играеш само онлайн.';

  @override
  String get cityLabel => 'Област';

  @override
  String get districtLabel => 'Район';

  @override
  String get bioLabel => 'За теб';

  @override
  String get bioHint => 'Опит, любими светове, кога си свободен/свободна…';

  @override
  String get selectAtLeastOne => 'Избери поне едно.';

  @override
  String get locationRequired => 'Избери област и район.';

  @override
  String get save => 'Запази';

  @override
  String get saveFailed => 'Не можа да се запази. Опитай отново.';

  @override
  String get postGame => 'Публикувай игра';

  @override
  String get findGame => 'Намери игра';

  @override
  String get myTables => 'Моите маси';

  @override
  String get noTablesYet => 'Все още не си публикувал/а игра.';

  @override
  String get newGameTitle => 'Нова игра';

  @override
  String get editGameTitle => 'Редактиране на играта';

  @override
  String get gameTitleLabel => 'Заглавие';

  @override
  String get gameTitleHint => 'напр. Curse of Strahd – подходяща за начинаещи';

  @override
  String get gameTitleError => 'Въведи 3–80 знака.';

  @override
  String get systemLabel => 'Игрова система';

  @override
  String get platformLabel => 'Платформа';

  @override
  String get gameTypeLabel => 'Тип игра';

  @override
  String get gameTypeOneShot => 'Еднократна';

  @override
  String get gameTypeCampaign => 'Кампания';

  @override
  String get campaignStageLabel => 'Състояние на кампанията';

  @override
  String get campaignNew => 'Нова игра';

  @override
  String get campaignOngoing => 'Текуща игра';

  @override
  String get campaignOngoingHelper => 'Вече върви и търси нови играчи.';

  @override
  String get frequencyLabel => 'Колко често?';

  @override
  String get freqWeekly => 'Всяка седмица';

  @override
  String get freqBiweekly => 'През седмица';

  @override
  String get freqMonthly => 'Всеки месец';

  @override
  String get freqIrregular => 'Нередовно';

  @override
  String get sessionFirst => 'Първа сесия';

  @override
  String get sessionNext => 'Следваща сесия';

  @override
  String get sessionOptional => 'По избор за текущи игри.';

  @override
  String get pickDateTime => 'Избери дата и час';

  @override
  String get dateRequired => 'Избери дата и час.';

  @override
  String get dateInPast => 'Датата трябва да е в бъдещето.';

  @override
  String get seatsTotalLabel => 'Играчи на масата';

  @override
  String get seatsOpenLabel => 'Свободни места';

  @override
  String seatsSummary(int open, int total) {
    return '$open/$total свободни места';
  }

  @override
  String get gameLanguageLabel => 'Език на играта';

  @override
  String get langTurkish => 'Турски';

  @override
  String get langEnglish => 'Английски';

  @override
  String get langBulgarian => 'Български';

  @override
  String get beginnerFriendlyLabel => 'Подходяща за начинаещи';

  @override
  String get paidLabel => 'Платена игра';

  @override
  String priceLabel(String currency) {
    return 'Цена на играч за сесия ($currency)';
  }

  @override
  String get priceError => 'Въведи валидна сума.';

  @override
  String get free => 'Безплатна';

  @override
  String pricePerSession(String price) {
    return '$price / сесия';
  }

  @override
  String get descriptionLabel => 'Описание';

  @override
  String get descriptionHint =>
      'Свят, атмосфера, домашни правила, какво очакваш от играчите…';

  @override
  String get contactNoteLabel => 'Бележка за контакт (лична)';

  @override
  String get contactNoteHelper =>
      'Виждат я само приетите от теб играчи: покана за Discord, линк към група, точен адрес…';

  @override
  String get gameLocationHelper =>
      'Публични са само областта и районът. Напиши точния адрес в бележката за контакт.';

  @override
  String get statusLabel => 'Статус';

  @override
  String get statusOpen => 'Отворена';

  @override
  String get statusFull => 'Пълна';

  @override
  String get statusClosed => 'Затворена';

  @override
  String get delete => 'Изтрий';

  @override
  String get cancel => 'Отказ';

  @override
  String get deleteGameConfirm =>
      'Да се изтрие ли тази обява? Действието е необратимо.';

  @override
  String hostedBy(String name) {
    return 'DM: $name';
  }

  @override
  String get edit => 'Редактирай';

  @override
  String get filtersTitle => 'Филтри';

  @override
  String get filterAll => 'Всички';

  @override
  String get beginnerOnly => 'Само подходящи за начинаещи';

  @override
  String get freeOnly => 'Само безплатни игри';

  @override
  String get searchButton => 'Търси';

  @override
  String get noResults => 'Няма игри, отговарящи на филтрите.';

  @override
  String get loadMore => 'Зареди още';

  @override
  String get gameNotFound => 'Тази обява вече не съществува.';

  @override
  String get yourListing => 'Това е твоята обява.';

  @override
  String get apply => 'Кандидатствай';

  @override
  String get applyDialogTitle => 'Кандидатствай за тази игра';

  @override
  String get applyMessageLabel => 'Съобщение до DM (по избор)';

  @override
  String get applyMessageHint =>
      'Представи се: опит, кога си свободен/свободна…';

  @override
  String get send => 'Изпрати';

  @override
  String get applicationStatusLabel => 'Твоята кандидатура';

  @override
  String get appPending => 'Чака отговор';

  @override
  String get appAccepted => 'Приета';

  @override
  String get appRejected => 'Не е приета';

  @override
  String get appWithdrawn => 'Оттеглена';

  @override
  String get appRemoved => 'Отстранен/а от масата';

  @override
  String get withdraw => 'Оттегли';

  @override
  String get withdrawConfirm => 'Да оттеглиш ли кандидатурата си?';

  @override
  String get applyAgain => 'Кандидатствай отново';

  @override
  String get contactNoteTitle => 'Бележка за контакт от DM';

  @override
  String get noContactNote => 'DM все още не е добавил бележка за контакт.';

  @override
  String get applicationsTitle => 'Кандидатури';

  @override
  String get noApplications => 'Все още няма кандидатури.';

  @override
  String get accept => 'Приеми';

  @override
  String get reject => 'Откажи';

  @override
  String get removePlayer => 'Отстрани от масата';

  @override
  String removePlayerConfirm(String name) {
    return 'Да се отстрани ли $name от масата? Мястото ще се освободи отново.';
  }

  @override
  String get playerRoleNeeded =>
      'Добави ролята „Играч“ в профила си, за да кандидатстваш.';

  @override
  String get gameNotOpen => 'Тази игра в момента не приема кандидатури.';

  @override
  String get myApplications => 'Моите кандидатури';

  @override
  String get noApplicationsYet => 'Все още не си кандидатствал/а за игра.';

  @override
  String pendingApplications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нови кандидатури',
      one: '1 нова кандидатура',
    );
    return '$_temp0';
  }

  @override
  String get actionFailed => 'Нещо се обърка. Опитай отново.';

  @override
  String get searchFailed => 'Търсенето не успя. Опитай отново след малко.';

  @override
  String get postSeeker => 'Търся група';

  @override
  String get findPlayers => 'Намери играчи';

  @override
  String get mySeekerPosts => 'Моите обяви „Търся група“';

  @override
  String get noSeekerPostsYet => 'Все още нямаш обяви „Търся група“.';

  @override
  String get seekerLimitReached =>
      'Можеш да имаш до 3 обяви. Изтрий една, за да добавиш нова.';

  @override
  String get newSeekerTitle => 'Търся група';

  @override
  String get editSeekerTitle => 'Редактиране на обявата';

  @override
  String get lookingForGroup => 'Търси група';

  @override
  String get gameTypesLabel => 'Типове игри';

  @override
  String get languagesLabel => 'Езици';

  @override
  String get experienceLabel => 'Опит';

  @override
  String get expNew => 'Начинаещ/а';

  @override
  String get expSome => 'Малко опит';

  @override
  String get expVeteran => 'Ветеран';

  @override
  String get availabilityLabel => 'Кога си свободен/свободна?';

  @override
  String get availabilityHint => 'напр. делнични вечери, събота следобед';

  @override
  String get openToPaidLabel => 'Отворен/а за платени игри';

  @override
  String get seekerDescriptionHint => 'Каква игра и група търсиш?';

  @override
  String postedBy(String name) {
    return 'Играч: $name';
  }

  @override
  String get inviteToTable => 'Покани на моята маса';

  @override
  String get chooseTable => 'Избери маса';

  @override
  String get noOpenTables => 'Нямаш отворени маси, на които да поканиш.';

  @override
  String get invited => 'Поканен/а';

  @override
  String get inviteSent => 'Поканата е изпратена.';

  @override
  String get myInvites => 'Покани';

  @override
  String inviteText(String dm, String game) {
    return '$dm те покани на $game';
  }

  @override
  String get dismiss => 'Отхвърли';

  @override
  String get noSeekerResults => 'Няма играчи, отговарящи на филтрите.';

  @override
  String get postNotFound => 'Тази обява вече не съществува.';

  @override
  String get deletePostConfirm =>
      'Да се изтрие ли тази обява? Действието е необратимо.';

  @override
  String get report => 'Докладвай';

  @override
  String get reportReasonLabel => 'Причина';

  @override
  String get reasonSpam => 'Спам';

  @override
  String get reasonHarassment => 'Тормоз или заплахи';

  @override
  String get reasonInappropriate => 'Неподходящо съдържание';

  @override
  String get reasonFake => 'Фалшиво или подвеждащо';

  @override
  String get reportDetailsLabel => 'Подробности (по избор)';

  @override
  String get reportSent => 'Благодарим! Ще прегледаме сигнала ти.';

  @override
  String get block => 'Блокирай';

  @override
  String get unblock => 'Отблокирай';

  @override
  String blockConfirm(String name) {
    return 'Да блокираш ли $name? Няма да виждаш обявите и поканите му/ѝ, а той/тя няма да може да кандидатства за твоите игри или да те кани.';
  }

  @override
  String get userBlocked => 'Потребителят е блокиран.';

  @override
  String get blockedUsers => 'Блокирани потребители';

  @override
  String get noBlockedUsers => 'Не си блокирал/а никого.';

  @override
  String get blockedNotice => 'Блокирал/а си този потребител.';

  @override
  String get deleteAccount => 'Изтрий акаунта';

  @override
  String get deleteAccountConfirm =>
      'Това изтрива завинаги профила, псевдонима, обявите, обявите „Търся група“, кандидатурите и поканите ти. Действието е необратимо. Ще трябва да потвърдиш с Google акаунта си.';

  @override
  String get deleteAccountButton => 'Изтрий завинаги';

  @override
  String get deletingAccount => 'Акаунтът ти се изтрива…';

  @override
  String get deleteAccountFailed =>
      'Акаунтът не можа да бъде изтрит. Опитай отново.';

  @override
  String get messages => 'Съобщения';

  @override
  String get noChats =>
      'Все още нямаш разговори. Можеш да пишеш на DM от обявата му, а на играч – от кандидатурата или обявата му „Търся група“.';

  @override
  String get messageDm => 'Пиши на DM';

  @override
  String get messagePlayer => 'Изпрати съобщение';

  @override
  String get messageHint => 'Напиши съобщение…';

  @override
  String get deletedUser => 'Изтрит потребител';

  @override
  String get chatClosed =>
      'Този потребител е изтрил акаунта си. Можеш да четеш историята, но не и да пишеш.';

  @override
  String get chatBlocked =>
      'Блокирал/а си този потребител. Отблокирай го/я, за да пишеш.';

  @override
  String get youPrefix => 'Ти: ';

  @override
  String get noMessagesYet => 'Все още няма съобщения. Кажи здравей!';

  @override
  String get open => 'Отвори';

  @override
  String get countryFieldLabel => 'Държава';

  @override
  String get countryTurkey => 'Турция';

  @override
  String get countryBulgaria => 'България';

  @override
  String get systemUndecided => 'Все още не знам / начинаещ';

  @override
  String allSystems(int count) {
    return 'Всички системи ($count)…';
  }

  @override
  String get searchSystemsHint => 'Търси система…';

  @override
  String get done => 'Готово';
}
