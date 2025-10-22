import '../datasource/boletin_remote_source.dart';
import '../../domain/repositories/boletin_repository.dart';

class BoletinRepositoryImpl implements BoletinRepository{

final BoletinRemoteSource remoteSource;

BoletinRepositoryImpl({required this.remoteSource});


}