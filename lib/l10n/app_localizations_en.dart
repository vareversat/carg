// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get sumTrickPointsAndContract => 'Add trick points and contract';

  @override
  String get sumTrickPointsAndContractYesExample =>
      'Example: The attack team announces 110 points. She wins with a total of 125.\n  The attack therefore scores 130 + 110 = 240 and the defense 40';

  @override
  String get sumTrickPointsAndContractNoExample =>
      'Example: The attack team announces 110 points. She wins with a total of 125.\n  The attack therefore scores 110 and the defense 0';

  @override
  String get admin => 'Admin';

  @override
  String get appDescription =>
      'The application to record your games of Belote, Coinche, Contrée and Tarot!';

  @override
  String get attack => 'Attack';

  @override
  String get back => 'Back';

  @override
  String get beloteRebelote => 'Belote and rebelote (+20)';

  @override
  String get bet => 'Bet';

  @override
  String get bonus => 'Bonus';

  @override
  String get buy => 'Buy';

  @override
  String get cannotPurchase => 'Cannot purchase. Please try again later';

  @override
  String get cannotRestorePurchase =>
      'Cannot restore purchase. Please try again later';

  @override
  String get cardColorAllTrump => 'All perks';

  @override
  String get cardColorClub => 'Club';

  @override
  String get cardColorDiamond => 'Diamond';

  @override
  String get cardColorHeart => 'Heart';

  @override
  String get cardColorNoTrump => 'No perks';

  @override
  String get cardColorSpade => 'Spade';

  @override
  String get changelog => 'Changelog';

  @override
  String get changeMyEmail => 'Change my email';

  @override
  String get changeMyPhoneNumber => 'Change my phone number';

  @override
  String get checkScores => 'Check scores';

  @override
  String get color => 'Color';

  @override
  String completedOn(Object date, Object hour) {
    return 'Completed on $date at $hour';
  }

  @override
  String get connection => 'Connection';

  @override
  String get continueWithEmail => 'Continue with email address';

  @override
  String get continueWithPhone => 'Continue with phone number';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get contract => 'Contract';

  @override
  String get contractTypeNormal => 'Normal';

  @override
  String get contractTypeCapot => 'Capot';

  @override
  String get contractTypeGenerale => 'Générale';

  @override
  String get contractTypeFailedGenerale => 'Failed générale';

  @override
  String get copyId => 'Copy the ID';

  @override
  String country(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count countries',
      one: '1 country',
      zero: 'Country',
    );
    return '$_temp0';
  }

  @override
  String get createNewPlayer => 'Create a new player';

  @override
  String get defense => 'Defense';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get dixDeDer => 'Dix de der (+10)';

  @override
  String get edition => 'Edition';

  @override
  String get ended => 'Ended';

  @override
  String get enterOtp => 'Please enter the OTP code sent to';

  @override
  String get error => 'Error';

  @override
  String get errorDuringPurchase => 'Error during purchase';

  @override
  String get errorInvalidPhoneNumber => 'The phone number is invalid';

  @override
  String get errorLoadingPage => 'Error encountered while loading the page';

  @override
  String get errorPlayerAlreadyLinked =>
      'This player is already linked to another account';

  @override
  String get errorPlayerNotFound => 'Player not found';

  @override
  String get errorWhileRestoring => 'Error while restoring';

  @override
  String get example => 'Example';

  @override
  String get gameAnticlockwiseDirection =>
      'This card game is played in a anticlockwise direction';

  @override
  String get gameClockwiseDirection =>
      'This card game is played in a clockwise direction';

  @override
  String get gameDistribution => 'Game distribution';

  @override
  String get gameIsStarting => 'Game is initializing';

  @override
  String get gameNotes => 'Game notes';

  @override
  String get games => 'Games';

  @override
  String get gameSelection => 'Game selection';

  @override
  String get gameSettings => 'Game settings';

  @override
  String get idCopied => 'ID copied to clipboard';

  @override
  String get infinite => 'Infinite';

  @override
  String get information => 'Information';

  @override
  String get informationAboutTheApp => 'Information about the app';

  @override
  String get inProgress => 'In progress';

  @override
  String get leave => 'Leave';

  @override
  String get linkPlayer => 'Link an existing player to this account';

  @override
  String get loading => 'Loading';

  @override
  String get logInToGoogle => 'Log in to your Google account';

  @override
  String get messageCreatePlayer =>
      'Create a new player without any associated games';

  @override
  String get messageDeleteGame => 'You are about to delete this game';

  @override
  String get messageDeleteLasRound =>
      'You are about to delete the last round of the game. This action cannot be reversed';

  @override
  String get messageDidYouReceiveOTP => 'You did not receive the OTP?';

  @override
  String get messageEnterUniqueId => 'Enter unique identifier of the player';

  @override
  String get messageEnterUsername => 'Enter your username';

  @override
  String get messageFindUniqueId =>
      'The unique identifier can be found on the player list of the Carg where you have already registered your player';

  @override
  String get messageLinkPlayer =>
      'If you have a player on one of your friend\'s Carg, you can link them to your new account!';

  @override
  String get messageNoRound => 'No rounds are recorded for this game';

  @override
  String get messagePlayerCreation => 'Create of the player';

  @override
  String get messagePlayerDistributeCardsFirsPart => 'It\'s';

  @override
  String get messagePlayerDistributeCardsSecondPart =>
      '\'s turn to distribute the cards!';

  @override
  String get messageSmsInfo =>
      'An SMS containing an OTP will be sent to you. Standard messaging and data rates apply';

  @override
  String get messageStopGame =>
      'You are about to complete this game. The winners as well as the losers (shameful) will be designated';

  @override
  String get messageWelcomeDescription =>
      'The application that allows you to record your games of Belote, Coinche, Contrée and Tarot!';

  @override
  String get myAccount => 'My account';

  @override
  String get myPlayers => 'My players';

  @override
  String get myProfile => 'My profile';

  @override
  String get myTeams => 'My teams';

  @override
  String get newGame => 'New game';

  @override
  String get newPhoneNumber => 'New phone number';

  @override
  String get newPhoneNumberValidate =>
      'New phone number validated successfully!';

  @override
  String get newPlayer => 'New player';

  @override
  String get newRound => 'New round';

  @override
  String get no => 'No';

  @override
  String get noGamesYet => 'No games yet';

  @override
  String get noName => 'No name';

  @override
  String get noPhoneNumberProvided => 'No phone number provided';

  @override
  String get noPlayerYet => 'No player yet';

  @override
  String get noProducts => 'No products are available for purchase';

  @override
  String get noScoreYet => 'No score yet';

  @override
  String get noStatisticYet => 'No statistics yet';

  @override
  String get numberOfPointToReach => 'Number of points to reach';

  @override
  String get otp => 'One-time password (OTP)';

  @override
  String get otpSend => 'OTP code sent successfully';

  @override
  String get or => 'or';

  @override
  String get orderOfPlay => 'Order of play';

  @override
  String get oudlerCount => 'Oudler count';

  @override
  String get ownedPlayersExplanation =>
      'This color indicates that this player was created by you. It is only accessible for the games that you created on your application';

  @override
  String trump(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trumps',
      zero: 'Trump',
    );
    return '$_temp0';
  }

  @override
  String get playedGames => 'Played games';

  @override
  String get playedGamesTotal => 'Total number of games played';

  @override
  String player(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Players',
      one: 'Player',
      zero: 'No players yet',
    );
    return '$_temp0';
  }

  @override
  String get playerCreated => 'Player created successfully';

  @override
  String get playerEdited => 'Player edited successfully';

  @override
  String get playerOrder => 'Players order';

  @override
  String get playerSelection => 'Player selection';

  @override
  String points(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      zero: 'Point',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get profilePicture => 'Profile picture (URL)';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSuccessfullyEdited => 'Profile successfully edited';

  @override
  String get realPlayersExplanation =>
      'This color indicates that this player has the Carg app';

  @override
  String get refresh => 'Refresh';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get resend => 'Resend';

  @override
  String get restoreMyPurchase => 'Restore my purchase';

  @override
  String get score => 'Score';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get signInAndUp => 'Sign In & Sing Up';

  @override
  String get signOut => 'Sing out';

  @override
  String startedOn(Object date, Object hour) {
    return 'Started on $date at $hour';
  }

  @override
  String get startTheGame => 'Start the game';

  @override
  String get startup => 'Startup';

  @override
  String get stop => 'Stop';

  @override
  String get sourceCode => 'Source code';

  @override
  String get seeTheRules => 'See the rules';

  @override
  String get takerTitleBelote => 'Takers';

  @override
  String takerTitleTarot(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      zero: 'Taker and called player',
      other: 'Taker',
    );
    return '$_temp0';
  }

  @override
  String get tarotAttackers => 'Attackers';

  @override
  String get tarotDefenders => 'Defenders';

  @override
  String get tarotCalled => 'Called';

  @override
  String get tarotChelem => 'Chelem (Slam)';

  @override
  String get tarotChelemWon => 'Won';

  @override
  String get tarotChelemAnnouncedAndWon => 'Announced and won';

  @override
  String get tarotChelemFailed => 'Failed';

  @override
  String get tarotGuardAgainstKitty =>
      'Garde contre le chien (Guard against the kitty)';

  @override
  String get tarotGuardNoKitty => 'Garde sans chien (Guard against the kitty)';

  @override
  String get tarotGuardWithKitty =>
      'Garde avec le chien (Guard with the kitty)';

  @override
  String get tarotGuard => 'Garde (Guard)';

  @override
  String get tarotPoignee => 'Poignee';

  @override
  String get tarotPoigneeSimple => 'Simple';

  @override
  String get tarotPoigneeDouble => 'Double';

  @override
  String get tarotPoigneeTriple => 'Triple';

  @override
  String get tarotSmall => 'Petite (Small)';

  @override
  String get tarotSmallToTheEnd => 'Small to the end';

  @override
  String get teamNameEdited => 'Team name edited successfully';

  @override
  String get testPlayers => 'Test players';

  @override
  String get testPlayersExplanation =>
      'This color indicates that this player is used for integration testing. If you see this type of players, it indicates that you are an administrator of the application';

  @override
  String get theAppWithoutAds => 'The Carg app without any ads!';

  @override
  String get them => 'Them';

  @override
  String get trickPoints => 'Trick points';

  @override
  String get type => 'Type';

  @override
  String get youDontHaveAnyPlayer => 'You don\'t have any players';

  @override
  String get unableAppInfo => 'Unable to get application information';

  @override
  String get unableToOpen => 'Unable to open the web page';

  @override
  String get us => 'Us';

  @override
  String get useMyGravatar => 'Use my Gravatar';

  @override
  String get username => 'Username';

  @override
  String get validate => 'Validate';

  @override
  String get validating => 'Validating';

  @override
  String get victories => 'Victories';

  @override
  String victoryPercentage(Object percentage) {
    return '$percentage% win';
  }

  @override
  String get warning => 'Warning';

  @override
  String welcomeMessage(Object appName) {
    return 'Welcome on $appName!';
  }

  @override
  String get wonGames => 'Won games';

  @override
  String get wonGamesTotal => 'Total number of games won';

  @override
  String get winPercentage => 'Win percentage';

  @override
  String get yes => 'Yes';
}
