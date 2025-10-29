// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertModel _$AlertModelFromJson(Map<String, dynamic> json) => AlertModel(
  fecha: json['fecha'] as String,
  horaDeEmision: json['horaDeEmision'] as String,
  descripcion: json['descripcion'] as String?,
  descripcionAdicional: json['descripcionAdicional'] as String?,
  zonaCobertura: json['zonaCobertura'] as String?,
  departamentosAfectados: (json['departamentosAfectados'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AlertModelToJson(AlertModel instance) =>
    <String, dynamic>{
      'fecha': instance.fecha,
      'horaDeEmision': instance.horaDeEmision,
      'descripcion': instance.descripcion,
      'descripcionAdicional': instance.descripcionAdicional,
      'zonaCobertura': instance.zonaCobertura,
      'departamentosAfectados': instance.departamentosAfectados,
    };
