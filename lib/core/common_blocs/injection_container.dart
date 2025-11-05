import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
}
