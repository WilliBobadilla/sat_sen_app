part of 'wheater_alert_form_cubit.dart';

class WheaterAlertFormState extends Equatable {
  final String? departmentName;
  final Failure? failure;

  const WheaterAlertFormState({this.departmentName, this.failure});

  WheaterAlertFormState copyWith({String? departmentName, Failure? failure}) {
    return WheaterAlertFormState(
      departmentName: departmentName ?? this.departmentName,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [departmentName, failure];
}

class WheaterAlertFormInitial extends WheaterAlertFormState {}
