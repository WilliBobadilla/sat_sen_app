import 'package:json_annotation/json_annotation.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/entities/alert_entity.dart';

part 'alert_model.g.dart';

@JsonSerializable()
class AlertModel extends AlertEntity {
  /* final String fecha;
  final String horaDeEmision;
  final String? descripcion;
  final String? descripcionAdicional;
  final String? zonaCobertura;
  final List<String>? departamentosAfectados;*/

  AlertModel({
    required super.fecha,
    required super.horaDeEmision,
    super.descripcion,
    super.descripcionAdicional,
    super.zonaCobertura,
    super.departamentosAfectados,
  });

  @override
  String toString() {
    return 'Alert(fecha: $fecha, hora: $horaDeEmision, desc: $descripcion)';
  }
}
