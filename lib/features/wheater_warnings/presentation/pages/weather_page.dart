import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat_sen_app/core/constants/constans.dart';
import 'package:sat_sen_app/core/injection/injection_container.dart';
import 'package:sat_sen_app/features/wheater_warnings/presentation/cubit/weather_alert_cubit.dart';
import 'package:sat_sen_app/features/wheater_warnings/presentation/cubit/wheater_alert_form_cubit.dart';
import 'package:sat_sen_app/features/wheater_warnings/presentation/views/weather_view.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              WeatherAlertCubit(getWeatherForecastUseCase: sl())
                ..onGetWeatherAlert(),
        ),
        BlocProvider(create: (context) => WheaterAlertFormCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<WeatherAlertCubit, WeatherAlertState>(
            listener: (context, state) {
              if (state is WeatherAlertError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.failure.message ?? kUnknownErrorMessage,
                    ),
                  ),
                );
              }
              if (state is WeatherAlertLoaded) {
                print("Weather Alert Loaded: ${state.alert}");
              }
            },
          ),
          BlocListener<WheaterAlertFormCubit, WheaterAlertFormState>(
            listener: (context, state) {
              if (state.departmentName != null) {
                BlocProvider.of<WeatherAlertCubit>(context).onGetWeatherAlert();
              }
            },
          ),
        ],
        child: WeatherView(),
      ),
    );
  }
}
