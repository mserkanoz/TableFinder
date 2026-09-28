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
  String get signOut => 'Sign out';

  @override
  String get profileSetupTitle => 'Create your profile';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameHelper =>
      'Shown to others instead of your real name. Must be unique.';

  @override
  String get nicknameError =>
      'Use 3–24 characters: English letters (A–Z) and digits, with single spaces, _ or . between words.';

  @override
  String get nicknameTaken => 'This nickname is already taken.';

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

  @override
  String get postGame => 'Post a game';

  @override
  String get findGame => 'Find a game';

  @override
  String get myTables => 'My tables';

  @override
  String get noTablesYet => 'You haven\'t posted any games yet.';

  @override
  String get newGameTitle => 'New game';

  @override
  String get editGameTitle => 'Edit game';

  @override
  String get gameTitleLabel => 'Title';

  @override
  String get gameTitleHint => 'e.g. Curse of Strahd – beginners welcome';

  @override
  String get gameTitleError => 'Enter 3–80 characters.';

  @override
  String get systemLabel => 'Game system';

  @override
  String get platformLabel => 'Platform';

  @override
  String get gameTypeLabel => 'Game type';

  @override
  String get gameTypeOneShot => 'One-shot';

  @override
  String get gameTypeCampaign => 'Campaign';

  @override
  String get campaignStageLabel => 'Campaign status';

  @override
  String get campaignNew => 'New game';

  @override
  String get campaignOngoing => 'Ongoing game';

  @override
  String get campaignOngoingHelper =>
      'Already running and looking for new players.';

  @override
  String get frequencyLabel => 'How often?';

  @override
  String get freqWeekly => 'Weekly';

  @override
  String get freqBiweekly => 'Every 2 weeks';

  @override
  String get freqMonthly => 'Monthly';

  @override
  String get freqIrregular => 'Irregular';

  @override
  String get sessionFirst => 'First session';

  @override
  String get sessionNext => 'Next session';

  @override
  String get sessionOptional => 'Optional for ongoing games.';

  @override
  String get pickDateTime => 'Pick date & time';

  @override
  String get dateRequired => 'Choose a date and time.';

  @override
  String get dateInPast => 'The date must be in the future.';

  @override
  String get seatsTotalLabel => 'Players at the table';

  @override
  String get seatsOpenLabel => 'Open seats';

  @override
  String seatsSummary(int open, int total) {
    return '$open/$total seats open';
  }

  @override
  String get gameLanguageLabel => 'Game language';

  @override
  String get langTurkish => 'Turkish';

  @override
  String get langEnglish => 'English';

  @override
  String get beginnerFriendlyLabel => 'Beginners welcome';

  @override
  String get paidLabel => 'Paid game';

  @override
  String get priceLabel => 'Price per player per session (₺)';

  @override
  String get priceError => 'Enter a valid amount.';

  @override
  String get free => 'Free';

  @override
  String pricePerSession(int price) {
    return '₺$price / session';
  }

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint =>
      'Setting, tone, house rules, what you expect from players…';

  @override
  String get contactNoteLabel => 'Contact note (private)';

  @override
  String get contactNoteHelper =>
      'Only players you accept will see this: Discord invite, group link, exact address…';

  @override
  String get gameLocationHelper =>
      'Only the province and district are public. Put the exact address in the contact note.';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusFull => 'Full';

  @override
  String get statusClosed => 'Closed';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteGameConfirm => 'Delete this listing? This cannot be undone.';

  @override
  String hostedBy(String name) {
    return 'DM: $name';
  }

  @override
  String get edit => 'Edit';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get filterAll => 'All';

  @override
  String get beginnerOnly => 'Beginner-friendly only';

  @override
  String get freeOnly => 'Free games only';

  @override
  String get searchButton => 'Search';

  @override
  String get noResults => 'No games match your filters.';

  @override
  String get loadMore => 'Load more';

  @override
  String get gameNotFound => 'This listing no longer exists.';

  @override
  String get yourListing => 'This is your listing.';

  @override
  String get apply => 'Apply';

  @override
  String get applyDialogTitle => 'Apply to this game';

  @override
  String get applyMessageLabel => 'Message to the DM (optional)';

  @override
  String get applyMessageHint =>
      'Introduce yourself: experience, availability…';

  @override
  String get send => 'Send';

  @override
  String get applicationStatusLabel => 'Your application';

  @override
  String get appPending => 'Pending';

  @override
  String get appAccepted => 'Accepted';

  @override
  String get appRejected => 'Not accepted';

  @override
  String get appWithdrawn => 'Withdrawn';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get withdrawConfirm => 'Withdraw your application?';

  @override
  String get applyAgain => 'Apply again';

  @override
  String get contactNoteTitle => 'Contact note from the DM';

  @override
  String get noContactNote => 'The DM hasn\'t added a contact note yet.';

  @override
  String get applicationsTitle => 'Applications';

  @override
  String get noApplications => 'No applications yet.';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get removePlayer => 'Remove from table';

  @override
  String removePlayerConfirm(String name) {
    return 'Remove $name from the table? Their seat will open up again.';
  }

  @override
  String get playerRoleNeeded =>
      'Add the Player role to your profile to apply.';

  @override
  String get gameNotOpen =>
      'This game isn\'t accepting applications right now.';

  @override
  String get myApplications => 'My applications';

  @override
  String get noApplicationsYet => 'You haven\'t applied to any games yet.';

  @override
  String pendingApplications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new applications',
      one: '1 new application',
    );
    return '$_temp0';
  }

  @override
  String get actionFailed => 'Something went wrong. Please try again.';

  @override
  String get searchFailed => 'Search failed. Please try again in a moment.';

  @override
  String get postSeeker => 'Post LFG';

  @override
  String get findPlayers => 'Find players';

  @override
  String get mySeekerPosts => 'My LFG posts';

  @override
  String get noSeekerPostsYet => 'You have no \"looking for group\" posts yet.';

  @override
  String get seekerLimitReached =>
      'You can have up to 3 posts. Delete one to add another.';

  @override
  String get newSeekerTitle => 'Looking for a group';

  @override
  String get editSeekerTitle => 'Edit LFG post';

  @override
  String get lookingForGroup => 'Looking for a group';

  @override
  String get gameTypesLabel => 'Game types';

  @override
  String get languagesLabel => 'Languages';

  @override
  String get experienceLabel => 'Experience';

  @override
  String get expNew => 'New to RPGs';

  @override
  String get expSome => 'Some experience';

  @override
  String get expVeteran => 'Veteran';

  @override
  String get availabilityLabel => 'When are you available?';

  @override
  String get availabilityHint => 'e.g. weekday evenings, Saturday afternoons';

  @override
  String get openToPaidLabel => 'Open to paid games';

  @override
  String get seekerDescriptionHint =>
      'What kind of game and group are you looking for?';

  @override
  String postedBy(String name) {
    return 'Player: $name';
  }

  @override
  String get inviteToTable => 'Invite to my table';

  @override
  String get chooseTable => 'Choose a table';

  @override
  String get noOpenTables => 'You have no open tables to invite to.';

  @override
  String get invited => 'Invited';

  @override
  String get inviteSent => 'Invitation sent.';

  @override
  String get myInvites => 'Invitations';

  @override
  String inviteText(String dm, String game) {
    return '$dm invited you to $game';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String get noSeekerResults => 'No players match your filters.';

  @override
  String get postNotFound => 'This post no longer exists.';

  @override
  String get deletePostConfirm => 'Delete this post? This cannot be undone.';
}
