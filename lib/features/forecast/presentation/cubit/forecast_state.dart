part of 'forecast_cubit.dart';

class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object?> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastError extends ForecastState {
  final Failure failure;

  const ForecastError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ForecastLoaded extends ForecastState {
  final ForecastEntity forecastData;

  const ForecastLoaded({required this.forecastData});

  @override
  List<Object?> get props => [forecastData];
}
