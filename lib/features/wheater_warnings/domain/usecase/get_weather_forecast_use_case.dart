import 'package:dartz/dartz.dart';
import 'package:sat_sen_app/core/errors/failures.dart';
import 'package:sat_sen_app/core/usecases/usecase.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/entities/alert_entity.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/repositories/wheater_repository.dart';

class GetWeatherForecastUseCase extends UseCase<AlertEntity, NoParams> {
  final WheaterRepository wheaterRepository;

  GetWeatherForecastUseCase({required WheaterRepository serviceRepository})
    : wheaterRepository = serviceRepository;

  @override
  Future<Either<Failure, AlertEntity>> call(NoParams params) async {
    return await wheaterRepository.fetchWheaterAlert();
  }
}
