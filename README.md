# Roughs

An iOS app and server system to manage Flinto projects.

## Requirement

### Server

- Node.js
- MongoDB

You can easily construct the server environment with [Heroku](https://www.heroku.com).

Reference: [http://qiita.com/runtBlue/items/0731f6f9d4bd27cd2dbd](http://qiita.com/runtBlue/items/0731f6f9d4bd27cd2dbd) (Japanse)

### iOS

- iOS7 or later
- iOS Developer Program membership

## Setup

First, download or clone this repository.

### Server

1. Install modules.

```
$ cd {REPOSITORY_ROOT}/Web
$ npm install
```

2. Edit `info.json`.

```
mongo_db_uri: {YOUR_MONGODB_URI} (required)
basic_auth: {BASIC Auth username and password} (optional)
```

3. Run.

```
$ npm start
```

### iOS

1. Install Xcode.

2. Install CocoaPods.

```
$ sudo gem install cocoapods
```

3. Install Libraries.

```
$ cd {REPOSITORY_ROOT}/iOS
$ pod install
```

4. Open **Roughs.xcworkspace** with Xcode.

```
$ open Roughs.xcworkspace -a Xcode
```

5. Edit `Info.plist`.

```
BaseURL: {SERVER_HOST} (ex: http://hoge.com/) (required)
BasicAuth: {BASIC Auth username and password} (optional)
```

6. Run.

## Usage

### Register a Flinto project

1. Access to your server with Chrome or Safari.

2. Click + button.

3. Enter the Flinto project URL.

4. Click Register button.

### View a Flinto project

1. Just open your app.

2. Select the project.

3. You can go back to the project list by swiping right from the app screen's left edge: iOS standard back action.

## Creator

### Takeru Chuganji

* [GitHub](https://github.com/hoppenichu)
* [Twitter](https://twitter.com/hoppenichu)
* [E-mail](mailto:takeru@hoppenichu.com)

## etc

* It may not work suddenly if Flinto changes its specifications.
* Pull Requests are welcome.
* If you do, please let me know you're using this project.


