import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sat_sen_app/core/errors/failures.dart';

part 'wheater_alert_form_state.dart';

class WheaterAlertFormCubit extends Cubit<WheaterAlertFormState> {
  WheaterAlertFormCubit() : super(WheaterAlertFormInitial());

  void setDepartmentName(String departmentName) {
    print('Selected department: $departmentName');
    emit(state.copyWith(departmentName: departmentName));
  }
}
