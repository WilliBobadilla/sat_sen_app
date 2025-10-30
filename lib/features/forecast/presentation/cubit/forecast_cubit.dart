import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sat_sen_app/core/errors/failures.dart';
import 'package:sat_sen_app/core/extensions/cubit_ext.dart';
import 'package:sat_sen_app/core/utils/scrapper_utils.dart';
import 'package:sat_sen_app/features/forecast/domain/entities/forecast_entity.dart';

part 'forecast_state.dart';

class ForecastCubit extends Cubit<ForecastState> {
  ForecastCubit() : super(ForecastInitial());

  void fetchForecast({required String cityName}) async {
    safeEmit(ForecastLoading());
    try {
      print("Fetching forecast for city: $cityName");
      // This should be done in the datasource layer
      final result = await WebScraperService.fetchForecast(cityName);
      print("---------------");
      print("result forecast is: $result");
      safeEmit(
        ForecastLoaded(forecastData: ForecastEntity(forecastData: result)),
      );
    } catch (e) {
      safeEmit(ForecastError(failure: ServerFailure(message: e.toString())));
    }
  }
}
