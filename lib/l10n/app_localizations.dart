import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TableFinder'**
  String get appTitle;

  /// Short slogan shown on the sign-in screen
  ///
  /// In en, this message translates to:
  /// **'Find your table. Find your players.'**
  String get tagline;

  /// No description provided for @ageConfirmation.
  ///
  /// In en, this message translates to:
  /// **'I confirm that I am 18 years of age or older.'**
  String get ageConfirmation;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get signInFailed;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeUser(String name);

  /// No description provided for @homePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Game listings will appear here soon.'**
  String get homePlaceholder;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @profileSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your profile'**
  String get profileSetupTitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditTitle;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @nicknameHelper.
  ///
  /// In en, this message translates to:
  /// **'Shown to others instead of your real name. Must be unique.'**
  String get nicknameHelper;

  /// No description provided for @nicknameError.
  ///
  /// In en, this message translates to:
  /// **'Use 3–24 characters: English letters (A–Z) and digits, with single spaces, _ or . between words.'**
  String get nicknameError;

  /// No description provided for @nicknameTaken.
  ///
  /// In en, this message translates to:
  /// **'This nickname is already taken.'**
  String get nicknameTaken;

  /// No description provided for @rolesLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get rolesLabel;

  /// No description provided for @rolesHelper.
  ///
  /// In en, this message translates to:
  /// **'You can pick both.'**
  String get rolesHelper;

  /// No description provided for @rolePlayer.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get rolePlayer;

  /// No description provided for @roleDm.
  ///
  /// In en, this message translates to:
  /// **'DM / GM'**
  String get roleDm;

  /// No description provided for @systemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Game systems'**
  String get systemsLabel;

  /// No description provided for @platformsLabel.
  ///
  /// In en, this message translates to:
  /// **'Where do you play?'**
  String get platformsLabel;

  /// No description provided for @platformInPerson.
  ///
  /// In en, this message translates to:
  /// **'In person'**
  String get platformInPerson;

  /// No description provided for @optionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get optionOther;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @locationHelperRequired.
  ///
  /// In en, this message translates to:
  /// **'Required for in-person games.'**
  String get locationHelperRequired;

  /// No description provided for @locationHelperOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional if you only play online.'**
  String get locationHelperOptional;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get cityLabel;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get districtLabel;

  /// No description provided for @bioLabel.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get bioLabel;

  /// No description provided for @bioHint.
  ///
  /// In en, this message translates to:
  /// **'Experience, favourite settings, when you\'re available…'**
  String get bioHint;

  /// No description provided for @selectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one.'**
  String get selectAtLeastOne;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a province and a district.'**
  String get locationRequired;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Please try again.'**
  String get saveFailed;

  /// No description provided for @postGame.
  ///
  /// In en, this message translates to:
  /// **'Post a game'**
  String get postGame;

  /// No description provided for @findGame.
  ///
  /// In en, this message translates to:
  /// **'Find a game'**
  String get findGame;

  /// No description provided for @myTables.
  ///
  /// In en, this message translates to:
  /// **'My tables'**
  String get myTables;

  /// No description provided for @noTablesYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t posted any games yet.'**
  String get noTablesYet;

  /// No description provided for @newGameTitle.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGameTitle;

  /// No description provided for @editGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit game'**
  String get editGameTitle;

  /// No description provided for @gameTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get gameTitleLabel;

  /// No description provided for @gameTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Curse of Strahd – beginners welcome'**
  String get gameTitleHint;

  /// No description provided for @gameTitleError.
  ///
  /// In en, this message translates to:
  /// **'Enter 3–80 characters.'**
  String get gameTitleError;

  /// No description provided for @systemLabel.
  ///
  /// In en, this message translates to:
  /// **'Game system'**
  String get systemLabel;

  /// No description provided for @platformLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platformLabel;

  /// No description provided for @gameTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Game type'**
  String get gameTypeLabel;

  /// No description provided for @gameTypeOneShot.
  ///
  /// In en, this message translates to:
  /// **'One-shot'**
  String get gameTypeOneShot;

  /// No description provided for @gameTypeCampaign.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get gameTypeCampaign;

  /// No description provided for @campaignStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Campaign status'**
  String get campaignStageLabel;

  /// No description provided for @campaignNew.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get campaignNew;

  /// No description provided for @campaignOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing game'**
  String get campaignOngoing;

  /// No description provided for @campaignOngoingHelper.
  ///
  /// In en, this message translates to:
  /// **'Already running and looking for new players.'**
  String get campaignOngoingHelper;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'How often?'**
  String get frequencyLabel;

  /// No description provided for @freqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get freqWeekly;

  /// No description provided for @freqBiweekly.
  ///
  /// In en, this message translates to:
  /// **'Every 2 weeks'**
  String get freqBiweekly;

  /// No description provided for @freqMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get freqMonthly;

  /// No description provided for @freqIrregular.
  ///
  /// In en, this message translates to:
  /// **'Irregular'**
  String get freqIrregular;

  /// No description provided for @sessionFirst.
  ///
  /// In en, this message translates to:
  /// **'First session'**
  String get sessionFirst;

  /// No description provided for @sessionNext.
  ///
  /// In en, this message translates to:
  /// **'Next session'**
  String get sessionNext;

  /// No description provided for @sessionOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional for ongoing games.'**
  String get sessionOptional;

  /// No description provided for @pickDateTime.
  ///
  /// In en, this message translates to:
  /// **'Pick date & time'**
  String get pickDateTime;

  /// No description provided for @dateRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a date and time.'**
  String get dateRequired;

  /// No description provided for @dateInPast.
  ///
  /// In en, this message translates to:
  /// **'The date must be in the future.'**
  String get dateInPast;

  /// No description provided for @seatsTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Players at the table'**
  String get seatsTotalLabel;

  /// No description provided for @seatsOpenLabel.
  ///
  /// In en, this message translates to:
  /// **'Open seats'**
  String get seatsOpenLabel;

  /// No description provided for @seatsSummary.
  ///
  /// In en, this message translates to:
  /// **'{open}/{total} seats open'**
  String seatsSummary(int open, int total);

  /// No description provided for @gameLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Game language'**
  String get gameLanguageLabel;

  /// No description provided for @langTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get langTurkish;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @beginnerFriendlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Beginners welcome'**
  String get beginnerFriendlyLabel;

  /// No description provided for @paidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid game'**
  String get paidLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per player per session (₺)'**
  String get priceLabel;

  /// No description provided for @priceError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get priceError;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @pricePerSession.
  ///
  /// In en, this message translates to:
  /// **'₺{price} / session'**
  String pricePerSession(int price);

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Setting, tone, house rules, what you expect from players…'**
  String get descriptionHint;

  /// No description provided for @contactNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact note (private)'**
  String get contactNoteLabel;

  /// No description provided for @contactNoteHelper.
  ///
  /// In en, this message translates to:
  /// **'Only players you accept will see this: Discord invite, group link, exact address…'**
  String get contactNoteHelper;

  /// No description provided for @gameLocationHelper.
  ///
  /// In en, this message translates to:
  /// **'Only the province and district are public. Put the exact address in the contact note.'**
  String get gameLocationHelper;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @statusFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get statusFull;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get statusClosed;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteGameConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this listing? This cannot be undone.'**
  String get deleteGameConfirm;

  /// No description provided for @hostedBy.
  ///
  /// In en, this message translates to:
  /// **'DM: {name}'**
  String hostedBy(String name);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @beginnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Beginner-friendly only'**
  String get beginnerOnly;

  /// No description provided for @freeOnly.
  ///
  /// In en, this message translates to:
  /// **'Free games only'**
  String get freeOnly;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No games match your filters.'**
  String get noResults;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @gameNotFound.
  ///
  /// In en, this message translates to:
  /// **'This listing no longer exists.'**
  String get gameNotFound;

  /// No description provided for @yourListing.
  ///
  /// In en, this message translates to:
  /// **'This is your listing.'**
  String get yourListing;

  /// No description provided for @applyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Applying to games is coming in the next update.'**
  String get applyComingSoon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
