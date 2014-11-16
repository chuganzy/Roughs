# Roughs

I made a Flinto App for iOS.

## Requirement

### Server

Use Heroku, and enable MongoLab plugin.  
reference: http://qiita.com/runtBlue/items/0731f6f9d4bd27cd2dbd


### iOS

iOS7 and later

## Setup

### Server

1. Install node modules.
```
$ cd Web
$ npm install
```

- Edit `info.json`.
```
mongo_db_uri: MongoDB URI (required)
basic_auth: BASIC Auth username and password (optional)
```

- Run.
```
$ npm start
```

### iOS

1. Install Xcode and CocoaPods.
```
$ sudo gem install cocoapods
```

- Install CocoaPods Libraries.
```
$ cd iOS
$ pod install
```

- Open `Roughs.xcworkspace`.

- Edit `Info.plist`.
```
Roughs:
> BaseURL: Server Host (ex: http://hoge.com/) (required)
> BasicAuth: BASIC Auth username and password (optional)
```

- Run.

## Usage

### Server

Register your Flinto projects by its URL.

### iOS

You can go back to the project list by swiping the edge or shaking your iPhone.

## Others

- It may not work suddenly if Flinto changes the specifications.
- Pull Requests welcome
