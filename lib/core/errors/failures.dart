import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final int? code;
  final String? message;
  final Map<String, dynamic>? parameters;

  const Failure({this.code, this.parameters, this.message});

  @override
  List<Object?> get props => [code, parameters, message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.code, super.parameters, super.message});
}

class LocalFailure extends Failure {
  const LocalFailure({super.code, super.message});
}

class CameraFailure extends Failure {
  const CameraFailure({super.message});
}

class PaymentFrequentFailure extends Failure {
  final String subMessage;
  const PaymentFrequentFailure({
    super.message,
    required this.subMessage,
    int? errorCode,
  }) : super(code: errorCode);
}
