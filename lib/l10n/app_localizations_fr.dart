// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'À propos';

  @override
  String get sumTrickPointsAndContract => 'Additionner points fait et contrat';

  @override
  String get sumTrickPointsAndContractYesExample =>
      'Exemple : L\'attaque annonce 110 points. Elle remporte en faisant un total de 125.\n L\'attaque marque donc 130 + 110 = 240 et la défense 40';

  @override
  String get sumTrickPointsAndContractNoExample =>
      'Exemple : L\'attaque annonce 110 points. Elle remporte en faisant un total de 125.\n L\'attaque marque donc 110 et la défense 0';

  @override
  String get admin => 'Admin';

  @override
  String get appDescription =>
      'L\'application pour enregistrer vos parties de Belote, Coinche, Contrée et Tarot !';

  @override
  String get appTheme => 'Thème de l\'application';

  @override
  String get attack => 'Attaque';

  @override
  String get back => 'Retour';

  @override
  String get beloteRebelote => 'Belote & rebelote';

  @override
  String get bet => 'Mise';

  @override
  String get bonus => 'Bonus';

  @override
  String get buy => 'Acheter';

  @override
  String get cannotPurchase =>
      'Impossible de réaliser l\'achat pour le moment. Veuillez réessayer plus tard';

  @override
  String get cannotRestorePurchase =>
      'Impossible de restorer les achats pour le moment. Veuillez réessayer plus tard';

  @override
  String get cardColorAllTrump => 'Tout atout';

  @override
  String get cardColorClub => 'Trèfle';

  @override
  String get cardColorDiamond => 'Carreau';

  @override
  String get cardColorHeart => 'Cœur';

  @override
  String get cardColorNoTrump => 'Sans atout';

  @override
  String get cardColorSpade => 'Pic';

  @override
  String get changelog => 'Journal des modifications';

  @override
  String get changeMyEmail => 'Changer mon adresse e-mail';

  @override
  String get changeMyPhoneNumber => 'Changer mon numéro de téléphone';

  @override
  String get checkScores => 'Consulter les scores';

  @override
  String get color => 'Couleur';

  @override
  String completedOn(Object date, Object hour) {
    return 'Terminée le $date à $hour';
  }

  @override
  String get connection => 'Connexion';

  @override
  String get continueWithEmail => 'Continuer avec une adresse email';

  @override
  String get continueWithPhone => 'Continuer avec un numéro de téléphone';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get contract => 'Contrat';

  @override
  String get contractTypeNormal => 'Normal';

  @override
  String get contractTypeCapot => 'Capot';

  @override
  String get contractTypeGenerale => 'Générale';

  @override
  String get contractTypeFailedGenerale => 'Générale chutée';

  @override
  String get copyId => 'Copier l\'ID';

  @override
  String country(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pays',
      zero: 'Pays',
    );
    return '$_temp0';
  }

  @override
  String get createNewPlayer => 'Créer un nouveau joueur';

  @override
  String get defense => 'Défense';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get dixDeDer => 'Dix de der';

  @override
  String get edition => 'Édition';

  @override
  String get ended => 'Terminée';

  @override
  String get enterOtp => 'Veuillez entrer le code OTP envoyé au';

  @override
  String get error => 'Erreur';

  @override
  String get errorDuringPurchase => 'Erreur durant l\'achat';

  @override
  String get errorInvalidPhoneNumber => 'Le numéro de téléphone est invalide';

  @override
  String get errorLoadingPage =>
      'Erreur rencontrée lors du chargement de la page';

  @override
  String get errorPlayerAlreadyLinked =>
      'Ce joueur est déjà associé à un autre compte';

  @override
  String get errorPlayerNotFound => 'Joueur introuvable';

  @override
  String get errorWhileRestoring => 'Erreur durant la restoration';

  @override
  String get example => 'Exemple';

  @override
  String get gameAnticlockwiseDirection =>
      'Ce jeu de carte se joue dans le sens antihorraire';

  @override
  String get gameClockwiseDirection =>
      'Ce jeu de carte se joue dans le sens horraire';

  @override
  String get gameDistribution => 'Distribution des parties';

  @override
  String get gameIsStarting => 'Partie en cours d\'initialisation';

  @override
  String get gameNotes => 'Notes de partie';

  @override
  String get games => 'Parties';

  @override
  String get gameSelection => 'Sélection du jeu';

  @override
  String get gameSettings => 'Paramètres de la partie';

  @override
  String get idCopied => 'ID copié dans le presse papier';

  @override
  String get information => 'Informations';

  @override
  String get informationAboutTheApp => 'Informations concernant l\'application';

  @override
  String get inProgress => 'En cours';

  @override
  String get leave => 'Quitter';

  @override
  String get linkPlayer => 'Lier un joueur existant à ce compte';

  @override
  String get loading => 'Chargement';

  @override
  String get logInToGoogle => 'Connexion à votre compte Google';

  @override
  String get messageCreatePlayer =>
      'Créer un nouveau joueur sans aucune parties associées';

  @override
  String get messageDeleteGame =>
      'Tu es sur le point de supprimer cette partie';

  @override
  String get messageDeleteRound =>
      'Tu es sur le point de supprimer une manche de la partie. Cette action est irréversible';

  @override
  String get messageDidYouReceiveOTP => 'Vous n\'avez pas reçu le code OTP';

  @override
  String get messageEnterUniqueId =>
      'Saisissez l\'identifiant unique du joueur';

  @override
  String get messageEnterUsername => 'Saisissez votre nom d\'utilisateur';

  @override
  String get messageFindUniqueId =>
      'L\'identifiant unique peut être retrouvé sur la liste des joueurs du Carg où vous avez déjà enregistré votre joueur';

  @override
  String get messageLinkPlayer =>
      'Si vous avez un joueur sur le Carg de l\'un de vos amis, vous pouvez le lier à votre nouveau compte !';

  @override
  String get messageNoRound =>
      'Aucune manche n\'est enregistrée pour cette partie';

  @override
  String get messagePlayerCreation => 'Création du joueur';

  @override
  String get messagePlayerDistributeCardsFirsPart => 'C\'est au tours de';

  @override
  String get messagePlayerDistributeCardsSecondPart =>
      ' de distribuer les cartes !';

  @override
  String get messageSmsInfo =>
      'Un SMS contenant un OTP va vous être envoyé. Des frais standards d\'envoi de messages et d\'échange de données s\'appliquent';

  @override
  String get messageStopGame =>
      'Tu es sur le point de terminer cette partie. Les gagnants ainsi que les perdants (honteux) vont être désignés';

  @override
  String get messageWelcomeDescription =>
      'L\'application qui vous permet d\'enregistrer vos parties de Belote, Coinche, Contrée et Tarot !';

  @override
  String get myAccount => 'Mon compte';

  @override
  String get myPlayers => 'Mes joueurs';

  @override
  String get myProfile => 'Mon profil';

  @override
  String get myTeams => 'Mes équipes';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get newPhoneNumber => 'Nouveau numéro de téléphone';

  @override
  String get newPhoneNumberValidate =>
      'Nouveau numéro de téléphone validé avec succès !';

  @override
  String get newPlayer => 'Nouveau.elle joueur.euse';

  @override
  String get newRound => 'Nouvelle manche';

  @override
  String get no => 'Non';

  @override
  String get noGamesYet => 'Pas encore de parties';

  @override
  String get noLimits => 'Aucune limite';

  @override
  String get noName => 'Sans nom';

  @override
  String get noPhoneNumberProvided => 'Pas de numéro de téléphone renseigné';

  @override
  String get noPlayerYet => 'Pas encore de joueurs.euses';

  @override
  String get noProducts => 'Aucun produit n\'est diponible à l\'achat';

  @override
  String get noScoreYet => 'Pas encore de score';

  @override
  String get noStatisticYet => 'Pas encore de statistiques';

  @override
  String get numberOfPointsToReach => 'Nombre de points à atteindre';

  @override
  String get otp => 'Mot de passe à usage unique (OTP)';

  @override
  String get otpSend => 'Code OTP envoyé avec succès';

  @override
  String get or => 'ou';

  @override
  String get orderOfPlay => 'Ordre de jeu';

  @override
  String get oudlerCount => 'Nombre de bout';

  @override
  String get ownedPlayersExplanation =>
      'Cette couleur indique que ce joueur a été créé par vous. Il n\'est accessible que pour les parties que vous créé sur votre application';

  @override
  String trump(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count atouts',
      zero: 'Atout',
    );
    return '$_temp0';
  }

  @override
  String get playedGames => 'Parties jouées';

  @override
  String get playedGamesTotal => 'Nombre total de parties jouées';

  @override
  String player(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Joueurs.euses',
      one: 'Joueur.euses',
      zero: 'Pas encore de joueurs.euses',
    );
    return '$_temp0';
  }

  @override
  String get playerCreated => 'Joueur créé avec succès';

  @override
  String get playerEdited => 'Joueur modifié avec succès';

  @override
  String get playerOrder => 'Ordre des joueurs';

  @override
  String get playerSelection => 'Sélection des joueurs';

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
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get profilePicture => 'Image de profil (URL)';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSuccessfullyEdited => 'Profil modifié avec succès';

  @override
  String get realPlayersExplanation =>
      'Cette couleur indique que ce joueur dispose de l\'application Carg';

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get removeAds => 'Supprimer les publicités';

  @override
  String get resend => 'Renvoyer';

  @override
  String get restoreMyPurchase => 'Restorer mon achat';

  @override
  String get score => 'Score';

  @override
  String get search => 'Rechercher';

  @override
  String get settings => 'Paramètres';

  @override
  String get signInAndUp => 'Connexion & Inscription';

  @override
  String get signOut => 'Déconnexion';

  @override
  String startedOn(Object date, Object hour) {
    return 'Commencée le $date à $hour';
  }

  @override
  String get startTheGame => 'Démarrer la partie';

  @override
  String get startup => 'Démarrage';

  @override
  String get stop => 'Arrêter';

  @override
  String get sourceCode => 'Code source';

  @override
  String get checkTheRules => 'Consulter les règles';

  @override
  String get takerTitleBelote => 'Preneurs';

  @override
  String takerTitleTarot(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      zero: 'Preneur et appelé',
      other: 'Preneur',
    );
    return '$_temp0';
  }

  @override
  String get tarotAttackers => 'Attaquants';

  @override
  String get tarotDefenders => 'Defenseurs';

  @override
  String get tarotCalled => 'Appelé';

  @override
  String get tarotChelem => 'Chelem';

  @override
  String get tarotChelemWon => 'Remporté';

  @override
  String get tarotChelemAnnouncedAndWon => 'Annoncé et remporté';

  @override
  String get tarotChelemFailed => 'Échoué';

  @override
  String get tarotGuardAgainstKitty => 'Garde contre le chien';

  @override
  String get tarotGuardNoKitty => 'Garde sans chien';

  @override
  String get tarotGuardWithKitty => 'Garde avec le chien';

  @override
  String get tarotGuard => 'Garde (Guard)';

  @override
  String get tarotPoignee => 'Poignée';

  @override
  String get tarotPoigneeSimple => 'Simple';

  @override
  String get tarotPoigneeDouble => 'Double';

  @override
  String get tarotPoigneeTriple => 'Triple';

  @override
  String get tarotSmall => 'Petite';

  @override
  String get tarotSmallToTheEnd => 'Petit au bout';

  @override
  String get teamNameEdited => 'Nom d\'équipe modifié avec succès';

  @override
  String get testPlayers => 'Joueurs de test';

  @override
  String get testPlayersExplanation =>
      'Cette couleur indique que ce joueur est utilisé pour les tests d\'intégrations. Si vous voyez ce type de joueurs, cela indique que vous ếtes administrateur de l\'application';

  @override
  String get theAppWithoutAds =>
      'L\'application Carg sans aucunes publicités !';

  @override
  String get them => 'Eux';

  @override
  String get trickPoints => 'Point des plis';

  @override
  String get trickPointsOverride => 'Points';

  @override
  String get type => 'Type';

  @override
  String get youDontHaveAnyPlayer => 'Vous ne disposez pas de joueur';

  @override
  String get unableAppInfo =>
      'mpossible d\'obtenir les informations de l\'application';

  @override
  String get unableToOpen => 'Impossible d\'ouvrir la page ';

  @override
  String get us => 'Nous';

  @override
  String get useMyGravatar => 'Utiliser mon Gravatar';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get confirm => 'Confirmer';

  @override
  String get validating => 'Validation';

  @override
  String get victories => 'Victoires';

  @override
  String victoryPercentage(Object percentage) {
    return '$percentage% de victoire';
  }

  @override
  String get warning => 'Attention';

  @override
  String welcomeMessage(Object appName) {
    return 'Bienvenue sur $appName !';
  }

  @override
  String get wonGames => 'Parties gagnées';

  @override
  String get wonGamesTotal => 'Nombre total de parties remportées';

  @override
  String get winPercentage => 'Pourcentages de victoires';

  @override
  String get yes => 'Oui';
}
