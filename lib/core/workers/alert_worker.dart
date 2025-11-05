import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sat_sen_app/core/utils/scrapper_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Simulated alert model (adjust to your server response)
class AlertModel {
  final String descripcion;
  final String fecha;
  final List<String> departamentosAfectados;

  AlertModel({
    required this.descripcion,
    required this.fecha,
    required this.departamentosAfectados,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      departamentosAfectados: List<String>.from(
        json['departamentosAfectados'] ?? [],
      ),
    );
  }
}

class AlertWorker {
  static final _notifications = FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  static Future<void> initializeNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidInit);
    await _notifications.initialize(initializationSettings);
  }

  /// Show notification
  static Future<void> showNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'alert_channel_id',
      'Alertas Meteorológicas',
      channelDescription: 'Canal de notificaciones de alertas meteorológicas',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    await _notifications.show(
      1001,
      title,
      message,
      NotificationDetails(android: androidDetails),
    );
  }

  /// Core worker logic
  static Future<void> checkAlerts() async {
    print("AlertWorker: Checking alerts...");
    final prefs = await SharedPreferences.getInstance();
    final userDepartment = prefs.getString('dep_app')?.trim().toLowerCase();

    if (userDepartment == null || userDepartment.isEmpty) {
      print('AlertWorker: No se encontró un departamento configurado.');
      return;
    }

    // Simulate fetching data from a remote endpoint
    try {
      /*
      final response = await http.get(
        Uri.parse('https://satsen.com.py/alertas.json'),
      );

      if (response.statusCode != 200) {
        print('AlertWorker: Error al obtener alerta (${response.statusCode})');
        return;
      }

      final jsonResponse = json.decode(response.body);
      final alert = AlertModel.fromJson(jsonResponse);
    */
      final result =
          await WebScraperService.fetchAlert(); // Use WebScraperService.
      developer.log("LOG: result from fetching is");
      developer.log(result.toString());
      final alert = result;

      final isAffected = alert!.departamentosAfectados!.any(
        (dep) => dep.toLowerCase().contains(userDepartment),
      );

      if (isAffected) {
        String notificationType;
        switch (alert.fecha.toLowerCase()) {
          case 'hoy':
            notificationType = 'TORMENTA_HOY';
            break;
          case 'mañana':
          case 'manana':
            notificationType = 'TORMENTA_MANANA';
            break;
          case 'pasado mañana':
          case 'pasado manaña':
            notificationType = 'TORMENTA_PASADO';
            break;
          default:
            notificationType = 'OTROS';
        }

        await showNotification(
          title: 'Alerta Meteorológica',
          message: alert.descripcion ?? '--',
          type: notificationType,
        );

        print('AlertWorker: Notificación enviada: ${alert.descripcion}');
      } else {
        print('AlertWorker: No hay alertas para $userDepartment');
      }
    } catch (e) {
      print('AlertWorker: Error al procesar alertas -> $e');
    }
  }
}
