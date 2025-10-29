import 'package:get_it/get_it.dart';

import 'package:sat_sen_app/features/wheater_warnings/injection_container.dart'
    as weather;

final sl = GetIt.instance;

Future<void> init() async {
  weather.init();
}
