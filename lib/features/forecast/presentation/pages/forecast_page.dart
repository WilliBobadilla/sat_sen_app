import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat_sen_app/core/constants/constans.dart';
import 'package:sat_sen_app/features/forecast/presentation/cubit/forecast_cubit.dart';
import 'package:sat_sen_app/features/forecast/presentation/cubit/forecast_form_cubit.dart';
import 'package:sat_sen_app/features/forecast/presentation/views/forecast_view.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ForecastCubit()..fetchForecast(cityName: kDefaultCity),
        ),
        BlocProvider(create: (context) => ForecastFormCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ForecastCubit, ForecastState>(
            listener: (context, state) {
              if (state is ForecastError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.failure.message}')),
                );
              }
              if (state is ForecastLoaded) {
                context.read<ForecastFormCubit>().onForecastLoaded(
                  forecast: state.forecastData,
                );
              }
            },
          ),
          BlocListener<ForecastFormCubit, ForecastFormState>(
            listenWhen: (previous, current) =>
                previous.cityName != current.cityName,
            listener: (context, state) {
              if (state.cityName != null) {
                context.read<ForecastCubit>().fetchForecast(
                  cityName: state.cityName!,
                );
              }
            },
          ),
        ],
        child: ForecastView(),
      ),
    );
  }
}
