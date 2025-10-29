import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wheater_alert_form_state.dart';

class WheaterAlertFormCubit extends Cubit<WheaterAlertFormState> {
  WheaterAlertFormCubit() : super(WheaterAlertFormInitial());
}
