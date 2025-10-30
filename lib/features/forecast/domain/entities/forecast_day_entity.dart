class ForecastDayEntity {
  final String day;
  final String description;
  final String? minTemp;
  final String? maxTemp;

  ForecastDayEntity({
    required this.day,
    required this.description,
    this.minTemp,
    this.maxTemp,
  });
}
