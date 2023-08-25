# bankimoon

Bankimoon is an app for storing Account Numbers you use frequently locally on your phone.
It uses your device's Local Storage for storing accounts, and (currently) does not push information to any online service.

It is tailored to Malawians who want to keep accounts so that they stop saving things like Bank Accounts as contacts and to make sharing of account numbers for online transactions easier. 

Bankimoon is built with:

- Flutter
- SQLite

## Design

The use case for the App is simple enough as just storing the Account numbers, with a few other functions.
Please refer to the diagram below for the initial use cases:

![[]](./docs/use-cases.png)


### UI / UX Design

The UI/UX of the App is a work in progress - there is an initial for the app in the docs directory, [UI Design PDF](./docs/Bankimoon-UI-Design_v0.1.pdf)


## Getting the App

The Bankimoon mobile app written in flutter uses sqlite to store institution account numbers, the sources are in the `app` directory.  We will publish APKs on GitHub Releases or the Play Store in due time, but for now you may have to build it yourself.

### Requirements

1. [Flutter](https://flutter.dev/)

### Project setup

```
git clone https://github.com/geekquest/bankimoon
```

```
cd app
```

```
flutter pub get
```

```
flutter run
```

| :warning: WARNING                                                                                         |
| :-------------------------------------------------------------------------------------------------------- |
| some Lower versions of flutter might cause problems with packages used, it is advised to user flutter 3.7 |


## Contributing

Contributions are very welcome, please check out the Issues and Open Pull-Requests.