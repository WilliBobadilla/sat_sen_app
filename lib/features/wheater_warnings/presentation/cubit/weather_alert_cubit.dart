import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sat_sen_app/core/errors/failures.dart';
import 'package:sat_sen_app/core/usecases/usecase.dart';
import 'package:sat_sen_app/core/extensions/cubit_ext.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/entities/alert_entity.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/usecase/get_weather_forecast_use_case.dart';

part 'weather_alert_state.dart';

class WeatherAlertCubit extends Cubit<WeatherAlertState> {
  final GetWeatherForecastUseCase getWeatherForecastUseCase;

  WeatherAlertCubit({required this.getWeatherForecastUseCase})
    : super(WeatherAlertInitial());

  void onGetWeatherAlert() async {
    safeEmit(WeatherAlertLoading());
    final result = await getWeatherForecastUseCase(NoParams());
    result.fold(
      (failure) => safeEmit(WeatherAlertError(failure: failure)),
      (alert) => safeEmit(WeatherAlertLoaded(alert: alert)),
    );
  }
}
