import '../datasource/wheater_remote_source.dart';
import '../../domain/repositories/wheater_repository.dart';

class WheaterRepositoryImpl implements WheaterRepository{

final WheaterRemoteSource remoteSource;

WheaterRepositoryImpl({required this.remoteSource});


}