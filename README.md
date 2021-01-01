[![flutter](https://img.shields.io/badge/flutter-blue?logo=flutter&style=for-the-badge)](https://flutter.dev) 
[![firebase](https://img.shields.io/badge/firebase-grey?logo=firebase&style=for-the-badge)](https://firebase.google.com)
[![algolia](https://img.shields.io/badge/algolia-grey?logo=algolia&style=for-the-badge)](https://algolia.com)
[![codecov](https://img.shields.io/codecov/c/github/devosud/carg?logo=codecov&style=for-the-badge&token=7EXLUQ93ZT)](https://codecov.io/gh/Devosud/carg/)

# Carg
This mobile app allow you to register with your own account and then save your games of French Belote (and French Coinched Belote) and Tarot !


# How to use it ?
For now, the app is only available on Android. YOu can go to the "Action" menu and download the artificats of the last 
green pipeline. You can also email me with a gmail address so I can add you to the broadcast list :)

# How to dev on it ?
You need a couple of things to be able to start the app in dev mode on your own computer
1) Download the [Flutter SDK](https://flutter.dev/docs/get-started/install) according to your OS
2) Create a virtual device
3) Clone the source code (of course)

### Firebase
1) Create on project on the [Firebase console](https://console.firebase.google.com/u/0/?hl=fr)
2) Add the *google.services.json* into the android/app folder
3) Upload the functions into your Firebase project (you'll need npm) :
```shell script
$ cd functions
$ npm install -g firebase-tools
$ firebase deploy --only functions
```
### Algolia
1) Create a project on [Algolia](https://www.algolia.com/users/sign_in) (it's an indexation service)
2) Create an index named *player_dev*
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



