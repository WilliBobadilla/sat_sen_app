import 'package:dartz/dartz.dart';

import 'package:sat_sen_app/core/errors/failures.dart';

import 'package:sat_sen_app/features/wheater_warnings/domain/entities/alert_entity.dart';

import '../datasource/wheater_remote_source.dart';
import '../../domain/repositories/wheater_repository.dart';

class WheaterRepositoryImpl implements WheaterRepository {
  final WheaterRemoteSource remoteSource;

  WheaterRepositoryImpl({required this.remoteSource});

  @override
  Future<Either<Failure, AlertEntity>> fetchWheaterAlert() async {
    try {
      final alertModel = await remoteSource.fetchWheaterAlert();
      return Right(alertModel);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
