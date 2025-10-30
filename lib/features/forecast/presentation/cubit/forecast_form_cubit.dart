import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sat_sen_app/core/constants/constans.dart';
import 'package:sat_sen_app/core/errors/failures.dart';
import 'package:sat_sen_app/core/extensions/cubit_ext.dart';
import 'package:sat_sen_app/core/utils/temperature_recomendation_util.dart';
import 'package:sat_sen_app/features/forecast/domain/entities/forecast_day_entity.dart';
import 'package:sat_sen_app/features/forecast/domain/entities/forecast_entity.dart';

part 'forecast_form_state.dart';

class ForecastFormCubit extends Cubit<ForecastFormState> {
  ForecastFormCubit() : super(ForecastFormInitial());

  void changeCityName(String cityName) {
    emit(state.copyWith(cityName: cityName));
  }

  void onForecastLoaded({required ForecastEntity forecast}) {
    // Additional logic can be added here if needed
    //get recomendations here!
    List<ForecastDayEntity> forecastDayEntityList = forecast.forecastData
        .map(
          (e) => ForecastDayEntity(
            day: e['day'] ?? '',
            description: e['description'] ?? '',
            minTemp: e['min'],
            maxTemp: e['max'],
          ),
        )
        .toList();

    final resultRecomendations =
        TemperatureRecommendationUtil.generateRecommendations(
          forecastDayEntityList,
          state.cityName ?? kDefaultCity,
        );
    print(" result recomendations: $resultRecomendations");

    safeEmit(
      state.copyWith(
        forecastData: forecast,
        recommendation: resultRecomendations,
      ),
    );
  }
}
