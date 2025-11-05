import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sat_sen_app/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sat_sen_app/core/utils/local_notification_utils.dart';

part 'notification_event.dart';

part 'notification_state.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirebaseMessaging _firebaseMessaging;
  final Future<void> Function()? requestLocalNotificationPermissions;
  //final UpdateFcmUseCase _updateFcmUseCase;

  NotificationBloc({
    required this.requestLocalNotificationPermissions,
    required FirebaseMessaging firebaseMessaging,
    //required UpdateFcmUseCase updateFcmUseCase,
  }) : _firebaseMessaging = firebaseMessaging,
       //     _updateFcmUseCase = updateFcmUseCase,
       super(const NotificationState()) {
    on<NotificationRequestedPermission>((event, emit) async {
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            badge: true,
            provisional: true,
            sound: true,
            announcement: true,
            carPlay: true,
            criticalAlert: true,
          );
      print("LOG: asking for permissions");
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Notification permission granted');

        // Initialize local notifications
        LocalNotifications.requestPermissionLocalNotifications();

        // Get FCM token and register device
        await _registerDevice();

        // Set up message handlers
        _setupMessageHandlers();

        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);
      } else {
        print('⚠️ Notification permission denied');
      }
      emit(state.copyWith(firebaseInitialized: true));
    });
  }

  /// Maneja la interacción del usuario con una notificación
  /// Se navegará a la página indicada en la data
  void _handleNotificationClick(RemoteMessage message) {
    //final path = message.data[TemporalConstants.pathKey];
    //if (path != null) {
    //  LocalNotifications.navigateToPage(path, message.data);
    //}
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //methods here!
  Future<void> _onTokenRefresh(String newToken) async {
    print('🔄 FCM Token refreshed');
    await _registerDevice(); // Re-register with new token
  }

  void _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotifications.showLocalNotification(
        id: message.hashCode,
        title: message.notification?.title,
        body: message.notification?.body,
        data: message.data.toString(),
      );
    });

    /// Escuchar notificaciones cuando la app está en segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });

    /// Revisar si la app fue abierta a través de una notificación cuando estaba terminada
    RemoteMessage? message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      _handleNotificationClick(message);
    }
  }

  Future<void> _registerDevice() async {
    String? token;
  }
}
