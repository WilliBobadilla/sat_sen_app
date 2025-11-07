import 'package:get_it/get_it.dart';
import 'package:sat_sen_app/core/scrappers/scrapper_utils.dart';
import 'package:sat_sen_app/features/wheater_warnings/data/datasource/wheater_remote_source.dart';
import 'package:sat_sen_app/features/wheater_warnings/data/repositories/wheater_repository_impl.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/repositories/wheater_repository.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/usecase/get_weather_forecast_use_case.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<WebScraperService>(() => WebScraperService());
  //Datasources
  sl.registerLazySingleton<WheaterRemoteSource>(
    () => WheaterRemoteSourceImpl(webScraperService: sl()),
  );

  //Repository
  sl.registerLazySingleton<WheaterRepository>(
    () => WheaterRepositoryImpl(remoteSource: sl()),
  );

  //Usecases
  sl.registerLazySingleton(
    () => GetWeatherForecastUseCase(serviceRepository: sl()),
  );

  // utils
}
