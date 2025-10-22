# sat_sen_app

A new Flutter project.


## Technologies :computer:

1. Dart
2. Flutter
3. Firebase(for crashlytics)
4. GraphQL

# Setup 

1. create a .env file

## Compile versions :iphone:

See that the file depends on what enviroment you want your version, it can be: main_tst.dart, main_stg.dart, main_prd.dart, also there is other flag to pass if you want to compile for automated testing, that is an extra param in the command:

for automated testing(add this to the build command):

```shell
--dart-define= "TEST=true"
```

for ios:

```shell
flutter build ios --release -t lib/main_tst.dart
```

for android:

```shell
flutter build apk --release -t lib/main_tst.dart
```

android(store):

```shell
flutter build appbundle --release -t lib/main_prd.dart
```

```
. For production builds, run flutter build apk --obfuscate --split-debug-info=build/debug-info (or ios/macos) then flutter pub run sentry_dart_plugin to upload debug symbols
```

So for example if you want to make a version for automated testing, you can run this command:

```shell
flutter build apk --debug -t lib/main_dev.dart --dart-define="TEST=true"
```

## Some useful commands :shell:

### generate .g files to have fromJson and toJson methods in classes

```
dart run build_runner build --delete-conflicting-outputs
```


### Generate modules with mason 
####  Activate from https://pub.dev
```
dart pub global activate mason_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

####  Initialize mason
```
mason init
```

#### Add your mason.yaml file 
```
bricks:
  clean_architecture_feature2: 0.1.0
  
```

#### Get the brick
```
mason get
```

#### Use the brick
```
mason make yourbrickname
```