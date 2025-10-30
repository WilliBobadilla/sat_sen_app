part of 'forecast_form_cubit.dart';

class ForecastFormState extends Equatable {
  final String? cityName;
  final Failure? failure;
  final ForecastEntity? forecastData;
  final String? recommendation;

  const ForecastFormState({
    this.cityName,
    this.failure,
    this.forecastData,
    this.recommendation,
  });

  ForecastFormState copyWith({
    String? cityName,
    Failure? failure,
    ForecastEntity? forecastData,
    String? recommendation,
  }) {
    return ForecastFormState(
      cityName: cityName ?? this.cityName,
      failure: failure ?? this.failure,
      forecastData: forecastData ?? this.forecastData,
      recommendation: recommendation ?? this.recommendation,
    );
  }

  @override
  List<Object?> get props => [cityName, failure, forecastData, recommendation];
}

class ForecastFormInitial extends ForecastFormState {}
