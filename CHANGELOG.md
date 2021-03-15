# **v0.12.0** :

- *New stuff* :
  - Add rules for each type of card game

***

# **v0.11.8** :

- *New stuff* :
  - New Login screen
  - Proper screen for settings

***

# **v0.11.5** :

- *Dev stuff* :
  - com.google.firebase:perf-plugin 1.3.4 => 1.3.5
  - com.google.firebase:firebase-bom 26.2.0 => 26.6.0 
  - All firebase dependencies are now dictated by the BOM version

- *New stuff* :
  - New UI for the UserScreen
  - Games are now paginated
  - AppBar buttons are now white instead of accent color

***

# **v0.11.0** :

- *Dev stuff* :
  - Bump to Flutter 2
  - Migrate to Dart null-safety
  - Upgrade all packages
  - Replace all deprecated packages

***

# **v0.10.4** :

- *New stuff* :
  - Better transitions between screens
  - User screen get a better look
  - More statistics are display on the user screen
  - Player widget use a dash instead of a pipe to display stats

***

# **v0.10.3** :

- *Dev stuff* :
  - Preliminary work to add iOS pipeline for the CI
  - Move the Consumer from the PlayerWidget
  - All changelogs are now displayed
- *New stuff* :
  - Statistics are display on the user screen

***

# **v0.10.0** :

- *Dev stuff* :
  - Android SDK 29 => 30
  - com.google.android.gms:play-services-base 17.5.0 => 17.6.0
  - Kotlin 1.4.21 => 1.4.31
  - com.google.firebase:firebase-crashlytics-gradle 2.4.1 => 2.5.0
  - Remove algolia dependency (blocking for future upgrades)

- *New stuff* :
  - Increment the number of played game at the end of the game instead at the beginning
  - You only see your games now
  - Redesign of the user page

***

# **v0.9.5** :

- *Fixed bugs* :
  - Fix bug that block the user to add a round to a coinche game
  - Fix bug where picking players for tarot game were broken
- *New stuff* :
  - We can see now stats per type of game
  - Reset selected player when move to picking screen to choosing the order screen
  - New UI for belote, coinche and tarot game screen
  - When press on player name, by default show he's stats

***

# **v0.9.0** :

- *Fixed bugs* :
  - Fix the belote / rebolte not taken in count for the contract
  - Fix the handful bad behaviour in a tarot game
- *New stuff* :
  - Add the possibility of ordering the players and see the user who will gave the cards
  - UI : bigger buttons on round screens and game setup screens
- *Dev stuff* :
  - Upgrade google-services
  - Upgrade firebase dependencies
  - Upgrade Gradle dependencies
  - Translate card colors
  - Add 'com.google.android.gms:play-services-base' to prevent error from service registration
  - Upgrade crashlytics dans analytic versions
  - Refactor : change class name (TeamGame => Belote, Coinche => CoincheBelote, Belote => FrenchBelote)

***

# **v0.8.4** :

- *Fixed bugs* :
  - Fix a bug which prevented players to get the points of te he Belote / Rebolete if the taker lost in a Coinche game
  - Fix the handful bad behaviour in a tarot game
- *New stuff* :
  - Add an icon to directly know if a game is still running on the list
  - Tapping outside the dialog of the tarot round perk keep the value previously selected
- *Dev stuff* :
  - Add crashlytics and performances libraries from Firebase
  - Move to Kotlin build
  - Add support for AndroidX
  - Move firebase functions into a proper directory
  - Create tests (Belote, Coinche and Tarot rounds)
  - Upload coverage to Codecov

***

# **v0.8.0** :

- *Bug fixes* :
  - The number of game played is now correctly increment when a tarot game is started
  - Same for the won counter (if the game is won)
  - Them / Us is now correctly displayed if we edit the last round in Belote / Coinche
  - Minor fixes
  - The displaying of rounds for Coinche / Belote is now larger
- *New stuff* :
  - The ending of a tarot game is now correctly handle
  - Display "Continue" instead of "Play" to continue a game
  - The score a tarot game can be seen even of the game has ended

***

# **v0.7.0+1** :

- Tarot game are now here !!!!
- Visual refactor of the "About" pop up
- Visual refactor of Game Cards (Belote and Coinche)
- Huge refactor behind the scene (use of Providers)

***

# **v0.6.0** :

- Contract types (Normal, Coinche, Surcoinche, ...) are now working properly for a Coinche Game
- Screen instead of a pop up to add a round to a Game (Belote and Coinche)
- Autofill the score for Coinche and Belote
- Auto update for the score when a property is changed (Belote and Coinche)
- Display the contract symbol for Belote and Coinche
- Add the "Search by Algolia" logo

***

# **0.5.2** :

- Split dev / prod database
- Change > to => to know if the taker team fulfilled the contract
- Belote Rebelote is no more count for the contract

***

# **0.5.0** :

- Add app icon
- Add licenses of used dependencies
- Add LICENCE.md
- Fix : A round of Coinche was lost if the takers exactly scored the contract
- New : + You can now add a player
  + You can now search players

***

# **0.4.8** :

- L'utilisateur a maintenant la possibilité de chercher les joueurs
- La création d'une partie a été améliorée
- L'affichage des manches comporte maintenant des pictogrammes pour comprendre le déroulement