//import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sat_sen_app/core/utils/string_utils.dart';
import 'package:timezone/timezone.dart' as tz1;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static Future<void> requestPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.canScheduleExactNotifications();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: iosShowNotification,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    print("FLUTTER NOTIFICATIONS INITIALIZED");
  }

  static void iosShowNotification(
    int id,
    String? title,
    String? body,
    String? data,
  ) {
    showLocalNotification(id: id, title: title, body: body, data: data);
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentSound: true),
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: data,
    );
  }

  /// Maneja la interacción del usuario con una notificación cuando la app está en primer plano
  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.notificationResponseType ==
            NotificationResponseType.selectedNotification &&
        response.payload != null) {
      final payloadString = StringUtils.convertPayloadToJson(response.payload!);
      //final payloadMap = jsonDecode(payloadString);
      // final path = ''; //payloadMap[TemporalConstants.pathKey];
      // if (path != null) {
      // navigateToPage(path, payloadMap);
      //  }
    }
  }

  static void requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  static void createScheduledNotification() async {
    // id, title, description, date, notificationDetails
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz1.setLocalLocation(tz1.getLocation(timeZoneName));
    if (await Permission.notification.isDenied) {
      print("permission denied, requesting it");
      await Permission.notification.request();
    }
    final now = tz1.TZDateTime.now(tz1.local);
    final dateToNotify = tz1.TZDateTime(
      tz1.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 2, // Example: schedule for 1 minute later
    );
    final inTwoSeconds = tz1.TZDateTime.now(
      tz1.local,
    ).add(Duration(seconds: 1));
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotification = AndroidNotificationDetails(
      'channelId1',
      'channelName1',
      //tag: 'Categoria',
    );

    var iosNotification = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notificationDetails = NotificationDetails(
      android: androidNotification,
      iOS: iosNotification,
    );
    print("notification scheduled, with time to notify: $dateToNotify");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      "todo.title",
      "todo.description",
      dateToNotify,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    /* await flutterLocalNotificationsPlugin.show(
      0, // id
      "Immediate Notification",
      "This is a test notification",
      notificationDetails,
    );
    */
    print("Notification scheduled ✅");
  }

  static void cancelScheduledNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Función para navegar a una página específica de la app desde una notificación
  /// Requiere el path de la página y un payload con información adicional
  /*static void navigateToPage(String path, Map<String, dynamic> payload) {
    final GoRouter appRouter = sl<GoRouter>();

    // Se agrega un query parameter para indicar que la navegación proviene de una notificación
    // Ej: '$path?fromNotification=true'
    final uriPathFromNotification = Uri(path: path, queryParameters: {
      TemporalConstants.fromNotificationKey: TemporalConstants.trueValue
    });

    // Si se desea agregar más paths, se debe agregar un case para cada uno,
    // con la instancia del extra correspondiente para el page
    switch (path) {
      case PreApprovedOfferSelectionPage.path:
        appRouter.push(
          uriPathFromNotification.toString(),
          extra: PreApprovedOfferSelectionExtra(currency: payload['currency']),
        );
        break;
      default:
        print('No match for path: $path');
        break;
    }
  }*/
}
