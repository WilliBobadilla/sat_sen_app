import 'package:flutter/material.dart';
import 'package:sat_sen_app/features/wheater/presentation/views/weather_view.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ForecastView();
  }
}
