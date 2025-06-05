import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('fr'),
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @sumTrickPointsAndContract.
  ///
  /// In en, this message translates to:
  /// **'Add trick points and contract'**
  String get sumTrickPointsAndContract;

  /// No description provided for @sumTrickPointsAndContractYesExample.
  ///
  /// In en, this message translates to:
  /// **'Example: The attack team announces 110 points. She wins with a total of 125.\n  The attack therefore scores 130 + 110 = 240 and the defense 40'**
  String get sumTrickPointsAndContractYesExample;

  /// No description provided for @sumTrickPointsAndContractNoExample.
  ///
  /// In en, this message translates to:
  /// **'Example: The attack team announces 110 points. She wins with a total of 125.\n  The attack therefore scores 110 and the defense 0'**
  String get sumTrickPointsAndContractNoExample;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'The application to record your games of Belote, Coinche, Contrée and Tarot!'**
  String get appDescription;

  /// No description provided for @attack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get attack;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @beloteRebelote.
  ///
  /// In en, this message translates to:
  /// **'Belote and rebelote'**
  String get beloteRebelote;

  /// No description provided for @bet.
  ///
  /// In en, this message translates to:
  /// **'Bet'**
  String get bet;

  /// No description provided for @bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonus;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @cannotPurchase.
  ///
  /// In en, this message translates to:
  /// **'Cannot purchase. Please try again later'**
  String get cannotPurchase;

  /// No description provided for @cannotRestorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Cannot restore purchase. Please try again later'**
  String get cannotRestorePurchase;

  /// No description provided for @cardColorAllTrump.
  ///
  /// In en, this message translates to:
  /// **'All perks'**
  String get cardColorAllTrump;

  /// No description provided for @cardColorClub.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get cardColorClub;

  /// No description provided for @cardColorDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get cardColorDiamond;

  /// No description provided for @cardColorHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get cardColorHeart;

  /// No description provided for @cardColorNoTrump.
  ///
  /// In en, this message translates to:
  /// **'No perks'**
  String get cardColorNoTrump;

  /// No description provided for @cardColorSpade.
  ///
  /// In en, this message translates to:
  /// **'Spade'**
  String get cardColorSpade;

  /// No description provided for @changelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelog;

  /// No description provided for @changeMyEmail.
  ///
  /// In en, this message translates to:
  /// **'Change my email'**
  String get changeMyEmail;

  /// No description provided for @changeMyPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change my phone number'**
  String get changeMyPhoneNumber;

  /// No description provided for @checkScores.
  ///
  /// In en, this message translates to:
  /// **'Check scores'**
  String get checkScores;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @completedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date} at {hour}'**
  String completedOn(Object date, Object hour);

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email address'**
  String get continueWithEmail;

  /// No description provided for @continueWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone number'**
  String get continueWithPhone;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @contractTypeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get contractTypeNormal;

  /// No description provided for @contractTypeCapot.
  ///
  /// In en, this message translates to:
  /// **'Capot'**
  String get contractTypeCapot;

  /// No description provided for @contractTypeGenerale.
  ///
  /// In en, this message translates to:
  /// **'Générale'**
  String get contractTypeGenerale;

  /// No description provided for @contractTypeFailedGenerale.
  ///
  /// In en, this message translates to:
  /// **'Failed générale'**
  String get contractTypeFailedGenerale;

  /// No description provided for @copyId.
  ///
  /// In en, this message translates to:
  /// **'Copy the ID'**
  String get copyId;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{Country} =1{1 country} other{{count} countries} }'**
  String country(num count);

  /// No description provided for @createNewPlayer.
  ///
  /// In en, this message translates to:
  /// **'Create a new player'**
  String get createNewPlayer;

  /// No description provided for @defense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get defense;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @dixDeDer.
  ///
  /// In en, this message translates to:
  /// **'Dix de der'**
  String get dixDeDer;

  /// No description provided for @edition.
  ///
  /// In en, this message translates to:
  /// **'Edition'**
  String get edition;

  /// No description provided for @ended.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ended;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP code sent to'**
  String get enterOtp;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorDuringPurchase.
  ///
  /// In en, this message translates to:
  /// **'Error during purchase'**
  String get errorDuringPurchase;

  /// No description provided for @errorInvalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'The phone number is invalid'**
  String get errorInvalidPhoneNumber;

  /// No description provided for @errorLoadingPage.
  ///
  /// In en, this message translates to:
  /// **'Error encountered while loading the page'**
  String get errorLoadingPage;

  /// No description provided for @errorPlayerAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This player is already linked to another account'**
  String get errorPlayerAlreadyLinked;

  /// No description provided for @errorPlayerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Player not found'**
  String get errorPlayerNotFound;

  /// No description provided for @errorWhileRestoring.
  ///
  /// In en, this message translates to:
  /// **'Error while restoring'**
  String get errorWhileRestoring;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get example;

  /// No description provided for @gameAnticlockwiseDirection.
  ///
  /// In en, this message translates to:
  /// **'This card game is played in a anticlockwise direction'**
  String get gameAnticlockwiseDirection;

  /// No description provided for @gameClockwiseDirection.
  ///
  /// In en, this message translates to:
  /// **'This card game is played in a clockwise direction'**
  String get gameClockwiseDirection;

  /// No description provided for @gameDistribution.
  ///
  /// In en, this message translates to:
  /// **'Game distribution'**
  String get gameDistribution;

  /// No description provided for @gameIsStarting.
  ///
  /// In en, this message translates to:
  /// **'Game is initializing'**
  String get gameIsStarting;

  /// No description provided for @gameNotes.
  ///
  /// In en, this message translates to:
  /// **'Game notes'**
  String get gameNotes;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @gameSelection.
  ///
  /// In en, this message translates to:
  /// **'Game selection'**
  String get gameSelection;

  /// No description provided for @gameSettings.
  ///
  /// In en, this message translates to:
  /// **'Game settings'**
  String get gameSettings;

  /// No description provided for @idCopied.
  ///
  /// In en, this message translates to:
  /// **'ID copied to clipboard'**
  String get idCopied;

  /// No description provided for @infinite.
  ///
  /// In en, this message translates to:
  /// **'Infinite'**
  String get infinite;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @informationAboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'Information about the app'**
  String get informationAboutTheApp;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @linkPlayer.
  ///
  /// In en, this message translates to:
  /// **'Link an existing player to this account'**
  String get linkPlayer;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @logInToGoogle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your Google account'**
  String get logInToGoogle;

  /// No description provided for @messageCreatePlayer.
  ///
  /// In en, this message translates to:
  /// **'Create a new player without any associated games'**
  String get messageCreatePlayer;

  /// No description provided for @messageDeleteGame.
  ///
  /// In en, this message translates to:
  /// **'You are about to delete this game'**
  String get messageDeleteGame;

  /// No description provided for @messageDeleteRound.
  ///
  /// In en, this message translates to:
  /// **'You are about to delete a round of the game. This action cannot be reversed'**
  String get messageDeleteRound;

  /// No description provided for @messageDidYouReceiveOTP.
  ///
  /// In en, this message translates to:
  /// **'You did not receive the OTP?'**
  String get messageDidYouReceiveOTP;

  /// No description provided for @messageEnterUniqueId.
  ///
  /// In en, this message translates to:
  /// **'Enter unique identifier of the player'**
  String get messageEnterUniqueId;

  /// No description provided for @messageEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get messageEnterUsername;

  /// No description provided for @messageFindUniqueId.
  ///
  /// In en, this message translates to:
  /// **'The unique identifier can be found on the player list of the Carg where you have already registered your player'**
  String get messageFindUniqueId;

  /// No description provided for @messageLinkPlayer.
  ///
  /// In en, this message translates to:
  /// **'If you have a player on one of your friend\'s Carg, you can link them to your new account!'**
  String get messageLinkPlayer;

  /// No description provided for @messageNoRound.
  ///
  /// In en, this message translates to:
  /// **'No rounds are recorded for this game'**
  String get messageNoRound;

  /// No description provided for @messagePlayerCreation.
  ///
  /// In en, this message translates to:
  /// **'Create of the player'**
  String get messagePlayerCreation;

  /// No description provided for @messagePlayerDistributeCardsFirsPart.
  ///
  /// In en, this message translates to:
  /// **'It\'s'**
  String get messagePlayerDistributeCardsFirsPart;

  /// No description provided for @messagePlayerDistributeCardsSecondPart.
  ///
  /// In en, this message translates to:
  /// **'\'s turn to distribute the cards!'**
  String get messagePlayerDistributeCardsSecondPart;

  /// No description provided for @messageSmsInfo.
  ///
  /// In en, this message translates to:
  /// **'An SMS containing an OTP will be sent to you. Standard messaging and data rates apply'**
  String get messageSmsInfo;

  /// No description provided for @messageStopGame.
  ///
  /// In en, this message translates to:
  /// **'You are about to complete this game. The winners as well as the losers (shameful) will be designated'**
  String get messageStopGame;

  /// No description provided for @messageWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'The application that allows you to record your games of Belote, Coinche, Contrée and Tarot!'**
  String get messageWelcomeDescription;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get myAccount;

  /// No description provided for @myPlayers.
  ///
  /// In en, this message translates to:
  /// **'My players'**
  String get myPlayers;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @myTeams.
  ///
  /// In en, this message translates to:
  /// **'My teams'**
  String get myTeams;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGame;

  /// No description provided for @newPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'New phone number'**
  String get newPhoneNumber;

  /// No description provided for @newPhoneNumberValidate.
  ///
  /// In en, this message translates to:
  /// **'New phone number validated successfully!'**
  String get newPhoneNumberValidate;

  /// No description provided for @newPlayer.
  ///
  /// In en, this message translates to:
  /// **'New player'**
  String get newPlayer;

  /// No description provided for @newRound.
  ///
  /// In en, this message translates to:
  /// **'New round'**
  String get newRound;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noGamesYet.
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get noGamesYet;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @noPhoneNumberProvided.
  ///
  /// In en, this message translates to:
  /// **'No phone number provided'**
  String get noPhoneNumberProvided;

  /// No description provided for @noPlayerYet.
  ///
  /// In en, this message translates to:
  /// **'No player yet'**
  String get noPlayerYet;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products are available for purchase'**
  String get noProducts;

  /// No description provided for @noScoreYet.
  ///
  /// In en, this message translates to:
  /// **'No score yet'**
  String get noScoreYet;

  /// No description provided for @noStatisticYet.
  ///
  /// In en, this message translates to:
  /// **'No statistics yet'**
  String get noStatisticYet;

  /// No description provided for @numberOfPointToReach.
  ///
  /// In en, this message translates to:
  /// **'Number of points to reach'**
  String get numberOfPointToReach;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'One-time password (OTP)'**
  String get otp;

  /// No description provided for @otpSend.
  ///
  /// In en, this message translates to:
  /// **'OTP code sent successfully'**
  String get otpSend;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @orderOfPlay.
  ///
  /// In en, this message translates to:
  /// **'Order of play'**
  String get orderOfPlay;

  /// No description provided for @oudlerCount.
  ///
  /// In en, this message translates to:
  /// **'Oudler count'**
  String get oudlerCount;

  /// No description provided for @ownedPlayersExplanation.
  ///
  /// In en, this message translates to:
  /// **'This color indicates that this player was created by you. It is only accessible for the games that you created on your application'**
  String get ownedPlayersExplanation;

  /// No description provided for @trump.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{Trump} other{{count} trumps}}'**
  String trump(num count);

  /// No description provided for @playedGames.
  ///
  /// In en, this message translates to:
  /// **'Played games'**
  String get playedGames;

  /// No description provided for @playedGamesTotal.
  ///
  /// In en, this message translates to:
  /// **'Total number of games played'**
  String get playedGamesTotal;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{No players yet} =1{Player} other{Players}}'**
  String player(num count);

  /// No description provided for @playerCreated.
  ///
  /// In en, this message translates to:
  /// **'Player created successfully'**
  String get playerCreated;

  /// No description provided for @playerEdited.
  ///
  /// In en, this message translates to:
  /// **'Player edited successfully'**
  String get playerEdited;

  /// No description provided for @playerOrder.
  ///
  /// In en, this message translates to:
  /// **'Players order'**
  String get playerOrder;

  /// No description provided for @playerSelection.
  ///
  /// In en, this message translates to:
  /// **'Player selection'**
  String get playerSelection;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{Point} other{{count} points}}'**
  String points(num count);

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile picture (URL)'**
  String get profilePicture;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSuccessfullyEdited.
  ///
  /// In en, this message translates to:
  /// **'Profile successfully edited'**
  String get profileSuccessfullyEdited;

  /// No description provided for @realPlayersExplanation.
  ///
  /// In en, this message translates to:
  /// **'This color indicates that this player has the Carg app'**
  String get realPlayersExplanation;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @restoreMyPurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore my purchase'**
  String get restoreMyPurchase;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signInAndUp.
  ///
  /// In en, this message translates to:
  /// **'Sign In & Sing Up'**
  String get signInAndUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sing out'**
  String get signOut;

  /// No description provided for @startedOn.
  ///
  /// In en, this message translates to:
  /// **'Started on {date} at {hour}'**
  String startedOn(Object date, Object hour);

  /// No description provided for @startTheGame.
  ///
  /// In en, this message translates to:
  /// **'Start the game'**
  String get startTheGame;

  /// No description provided for @startup.
  ///
  /// In en, this message translates to:
  /// **'Startup'**
  String get startup;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get sourceCode;

  /// No description provided for @seeTheRules.
  ///
  /// In en, this message translates to:
  /// **'See the rules'**
  String get seeTheRules;

  /// No description provided for @takerTitleBelote.
  ///
  /// In en, this message translates to:
  /// **'Takers'**
  String get takerTitleBelote;

  /// Takes as parameter the number of players modulo 5
  ///
  /// In en, this message translates to:
  /// **'{count,plural, other{Taker} =0{Taker and called player}}'**
  String takerTitleTarot(num count);

  /// No description provided for @tarotAttackers.
  ///
  /// In en, this message translates to:
  /// **'Attackers'**
  String get tarotAttackers;

  /// No description provided for @tarotDefenders.
  ///
  /// In en, this message translates to:
  /// **'Defenders'**
  String get tarotDefenders;

  /// No description provided for @tarotCalled.
  ///
  /// In en, this message translates to:
  /// **'Called'**
  String get tarotCalled;

  /// No description provided for @tarotChelem.
  ///
  /// In en, this message translates to:
  /// **'Chelem (Slam)'**
  String get tarotChelem;

  /// No description provided for @tarotChelemWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get tarotChelemWon;

  /// No description provided for @tarotChelemAnnouncedAndWon.
  ///
  /// In en, this message translates to:
  /// **'Announced and won'**
  String get tarotChelemAnnouncedAndWon;

  /// No description provided for @tarotChelemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get tarotChelemFailed;

  /// No description provided for @tarotGuardAgainstKitty.
  ///
  /// In en, this message translates to:
  /// **'Garde contre le chien (Guard against the kitty)'**
  String get tarotGuardAgainstKitty;

  /// No description provided for @tarotGuardNoKitty.
  ///
  /// In en, this message translates to:
  /// **'Garde sans chien (Guard against the kitty)'**
  String get tarotGuardNoKitty;

  /// No description provided for @tarotGuardWithKitty.
  ///
  /// In en, this message translates to:
  /// **'Garde avec le chien (Guard with the kitty)'**
  String get tarotGuardWithKitty;

  /// No description provided for @tarotGuard.
  ///
  /// In en, this message translates to:
  /// **'Garde (Guard)'**
  String get tarotGuard;

  /// No description provided for @tarotPoignee.
  ///
  /// In en, this message translates to:
  /// **'Poignee'**
  String get tarotPoignee;

  /// No description provided for @tarotPoigneeSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get tarotPoigneeSimple;

  /// No description provided for @tarotPoigneeDouble.
  ///
  /// In en, this message translates to:
  /// **'Double'**
  String get tarotPoigneeDouble;

  /// No description provided for @tarotPoigneeTriple.
  ///
  /// In en, this message translates to:
  /// **'Triple'**
  String get tarotPoigneeTriple;

  /// No description provided for @tarotSmall.
  ///
  /// In en, this message translates to:
  /// **'Petite (Small)'**
  String get tarotSmall;

  /// No description provided for @tarotSmallToTheEnd.
  ///
  /// In en, this message translates to:
  /// **'Small to the end'**
  String get tarotSmallToTheEnd;

  /// No description provided for @teamNameEdited.
  ///
  /// In en, this message translates to:
  /// **'Team name edited successfully'**
  String get teamNameEdited;

  /// No description provided for @testPlayers.
  ///
  /// In en, this message translates to:
  /// **'Test players'**
  String get testPlayers;

  /// No description provided for @testPlayersExplanation.
  ///
  /// In en, this message translates to:
  /// **'This color indicates that this player is used for integration testing. If you see this type of players, it indicates that you are an administrator of the application'**
  String get testPlayersExplanation;

  /// No description provided for @theAppWithoutAds.
  ///
  /// In en, this message translates to:
  /// **'The Carg app without any ads!'**
  String get theAppWithoutAds;

  /// No description provided for @them.
  ///
  /// In en, this message translates to:
  /// **'Them'**
  String get them;

  /// No description provided for @trickPoints.
  ///
  /// In en, this message translates to:
  /// **'Trick points'**
  String get trickPoints;

  /// No description provided for @trickPointsOverride.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get trickPointsOverride;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @youDontHaveAnyPlayer.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any players'**
  String get youDontHaveAnyPlayer;

  /// No description provided for @unableAppInfo.
  ///
  /// In en, this message translates to:
  /// **'Unable to get application information'**
  String get unableAppInfo;

  /// No description provided for @unableToOpen.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the web page'**
  String get unableToOpen;

  /// No description provided for @us.
  ///
  /// In en, this message translates to:
  /// **'Us'**
  String get us;

  /// No description provided for @useMyGravatar.
  ///
  /// In en, this message translates to:
  /// **'Use my Gravatar'**
  String get useMyGravatar;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @validating.
  ///
  /// In en, this message translates to:
  /// **'Validating'**
  String get validating;

  /// No description provided for @victories.
  ///
  /// In en, this message translates to:
  /// **'Victories'**
  String get victories;

  /// No description provided for @victoryPercentage.
  ///
  /// In en, this message translates to:
  /// **'{percentage}% win'**
  String victoryPercentage(Object percentage);

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome on {appName}!'**
  String welcomeMessage(Object appName);

  /// No description provided for @wonGames.
  ///
  /// In en, this message translates to:
  /// **'Won games'**
  String get wonGames;

  /// No description provided for @wonGamesTotal.
  ///
  /// In en, this message translates to:
  /// **'Total number of games won'**
  String get wonGamesTotal;

  /// No description provided for @winPercentage.
  ///
  /// In en, this message translates to:
  /// **'Win percentage'**
  String get winPercentage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
