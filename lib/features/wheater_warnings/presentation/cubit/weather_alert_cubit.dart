import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sat_sen_app/core/errors/failures.dart';
import 'package:sat_sen_app/core/usecases/usecase.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/usecase/get_weather_forecast_use_case.dart';

part 'weather_alert_state.dart';

class WeatherAlertCubit extends Cubit<WeatherAlertState> {
  final GetWeatherForecastUseCase getWeatherForecastUseCase;

  WeatherAlertCubit({required this.getWeatherForecastUseCase})
    : super(WeatherAlertInitial());

  void onGetWeatherAlert() async {
    emit(WeatherAlertLoading());
    final result = await getWeatherForecastUseCase(NoParams());
    result.fold(
      (failure) => emit(WeatherAlertError(failure: failure)),
      (alert) => emit(WeatherAlertLoaded(alert: alert)),
    );
  }
}
