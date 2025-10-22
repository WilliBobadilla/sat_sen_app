import '../datasource/forecast_remote_source.dart';
import '../../domain/repositories/forecast_repository.dart';

class ForecastRepositoryImpl implements ForecastRepository{

final ForecastRemoteSource remoteSource;

ForecastRepositoryImpl({required this.remoteSource});


}