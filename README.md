# sat_sen_app

Sat sen app, this is a migration of the original version in android/kotlin.


## Technologies :computer:

1. Dart
2. Flutter
3. Firebase(for crashlytics)
4. GraphQL



# Setup 

1. create a empty .env file

## Compile versions :iphone:

for ios:

```shell
flutter build ios --release -t lib/main_tst.dart
```

for android:

```shell
flutter build apk --release -t lib/main.dart
```

android(store):

```shell
flutter build appbundle --release -t lib/main.dart
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

### Usefull links
https://pub.dev/packages/workmanager

### Developer quick note 

There are still a lot of things  to improve and to re-order, for example,
1. there are some scrappers part that is needed to put in the datasource layer and put as clean architecture indicate.
2. Use a state manager like bloc or riverpod, to contorl pages/views state.
3. Use your own theme data.

If you want to scale it and to grow, I recommend you to do all of this recomendations in this paragraph.  