import 'package:dartz/dartz.dart';
import 'package:sat_sen_app/core/errors/failures.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/entities/alert_entity.dart';

abstract class WheaterRepository {
  Future<Either<Failure, AlertEntity>> fetchWheaterAlert();
}
