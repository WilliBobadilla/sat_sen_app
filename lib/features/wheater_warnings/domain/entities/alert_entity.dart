class AlertEntity {
  final String fecha;
  final String horaDeEmision;
  final String? descripcion;
  final String? descripcionAdicional;
  final String? zonaCobertura;
  final List<String>? departamentosAfectados;

  AlertEntity({
    required this.fecha,
    required this.horaDeEmision,
    this.descripcion,
    this.descripcionAdicional,
    this.zonaCobertura,
    this.departamentosAfectados,
  });

  @override
  String toString() {
    return 'Alert(fecha: $fecha, hora: $horaDeEmision, desc: $descripcion)';
  }
}
