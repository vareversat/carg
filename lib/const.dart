class Const {
  /// App
  static const String appName = 'Carg';
  static const String appBottomList = '♦ ️♣ ♥ ♠ ';
  static const String deepLinkScheme = 'https://carg.page.link/';

  /// Paths
  static const String changelogPath = 'CHANGELOG.md';
  static const String svgLogoPath = 'assets/images/card_game.svg';
  static const String algoliaConfigPath = 'assets/config/algolia.json';
  static const String googleApiKey = 'assets/config/google-play-api-key.json';
  static const String algoliaLogo = 'assets/images/algolia_logo.png';

  /// Link
  static const String githubLink = 'https://github.com/vareversat/carg';
  static const String privacyInfoLink = 'https://carg.vareversat.fr/privacy';

  /// Package id
  static const String packageId = 'fr.vareversat.carg';
  static const String appStoreSharedSecret = 'WIP';

  /// IAP
  static const String iapFreeAdsProductId = 'carg.free.ads';

  /// AdMod
  static const String androidInlineBanner =
      'ca-app-pub-4365376442391282/9655168903';
  static const String iosInlineBanner =
      'ca-app-pub-3940256099942544/2934735716';

  /// Build related ENVs
  static const String defaultEnv = 'dev';
  static const String dartVarEnv = 'FLAVOR';

  /// Databases
  static const String teamDB = 'team';
  static const String playerDB = 'player';
  static const String contreeBeloteGameDB = 'contree-game';
  static const String coincheBeloteGameDB = 'coinche-game';
  static const String frenchBeloteGameDB = 'belote-game';
  static const String tarotGameDB = 'tarot-game';
  static const String contreeBeloteScoreDB = 'contree-score';
  static const String coincheBeloteScoreDB = 'coinche-score';
  static const String frenchBeloteScoreDB = 'belote-score';
  static const String tarotScoreDB = 'tarot-score';
  static const String purchaseDB = 'iap';
}
