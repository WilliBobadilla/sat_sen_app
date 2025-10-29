part of 'weather_alert_cubit.dart';

class WeatherAlertState extends Equatable {
  const WeatherAlertState();

  @override
  List<Object> get props => [];
}

class WeatherAlertInitial extends WeatherAlertState {}

class WeatherAlertLoading extends WeatherAlertState {}

class WeatherAlertLoaded extends WeatherAlertState {
  final alert;

  const WeatherAlertLoaded({required this.alert});

  @override
  List<Object> get props => [alert];
}

class WeatherAlertError extends WeatherAlertState {
  final Failure failure;

  const WeatherAlertError({required this.failure});

  @override
  List<Object> get props => [failure];
}
