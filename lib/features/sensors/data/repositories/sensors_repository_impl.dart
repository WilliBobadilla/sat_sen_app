import '../datasource/sensors_remote_source.dart';
import '../../domain/repositories/sensors_repository.dart';

class SensorsRepositoryImpl implements SensorsRepository{

final SensorsRemoteSource remoteSource;

SensorsRepositoryImpl({required this.remoteSource});


}