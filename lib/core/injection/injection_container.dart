import 'package:get_it/get_it.dart';
import 'package:sat_sen_app/features/wheater_warnings/injection_container.dart'
    as weather;

import 'package:sat_sen_app/core/common_blocs/injection_container.dart'
    as firebase_messaging;

final sl = GetIt.instance;

Future<void> init() async {
  weather.init();
  firebase_messaging.init();
}
