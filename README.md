![](banner.png)

<h3 align="center">Get coinched ! ♦ ️♣️ ♥ ♠ ️</h3>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/flutter-blue?logo=flutter&style=for-the-badge"></a> 
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/firebase-grey?logo=firebase&style=for-the-badge"></a>
  <a href="https://algolia.com"><img src="https://img.shields.io/badge/algolia-white?logo=algolia&style=for-the-badge"></a>
</p>
<p align="center">
  <a href="https://codecov.io/gh/vareversat/carg/"><img src="https://img.shields.io/codecov/c/github/vareversat/carg?logo=codecov&style=for-the-badge&token=sA4XbJ7O5Z"></a>
  <a href="https://github.com/vareversat/carg/actions"><img src="https://img.shields.io/github/actions/workflow/status/vareversat/carg/repo.tag.yml?logo=github&style=for-the-badge"></a>
  <a href="https://github.com/vareversat/carg/releases"><img src="https://img.shields.io/github/v/tag/vareversat/carg?label=version&logo=git&logoColor=white&style=for-the-badge"></a>
  <a href="https://github.com/vareversat/carg/blob/dev/LICENSE.md"><img src="https://img.shields.io/github/license/vareversat/carg?style=for-the-badge"></a>
</p>

Mobile app where you to register with your own account and save your games of French Belote, Coinche Belote and Tarot !

# How to use it ?

For now, the app is only available on Android. You can go [here](https://play.google.com/store/apps/details?id=fr.vareversat.carg&pli=1) to download the app :)

# How to work on it ?

You need a couple of things to be able to start the app in dev mode on your own computer

1) Download the [Flutter SDK](https://flutter.dev/docs/get-started/install) according to your OS
2) Create a virtual device
3) Fork the source code (of course)

### Firebase
1) Create on project on the [Firebase console](https://console.firebase.google.com/u/0/?hl=fr)
2) Add the *google-services.json* into the android/app folder
3) Upload the functions into your Firebase project (you'll need npm) :
```shell script
$ cd functions
$ npm install -g firebase-tools
$ firebase deploy --only functions
```
### Algolia
1) Create a project on [Algolia](https://www.algolia.com/users/sign_in) (it's an indexation service)
2) Create an index named *player-dev*
3) Create a file named *algolia.json* in assets/config like this :
```json
{
  "app_id": "YOUR_APP_ID",
  "api_key": "YOUR_API_KEY"
}
```

Finally, you can run
```shell script
$ fluter run
```
And you are good to go :thumbsup:



