import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sat_sen_app/main_view.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sat_sen_app/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sat_sen_app/core/workers/call_dispatcher.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sat_sen_app/core/utils/local_notification_utils.dart';
import 'core/injection/injection_container.dart' as dependency_injection;
import 'package:sat_sen_app/core/common_blocs/notification_bloc/notification_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  await Workmanager().registerPeriodicTask(
    'check_alerts_task',
    'check_alerts_task',
    frequency: const Duration(minutes: 15), // minimun is 15 min
    initialDelay: const Duration(minutes: 1),
  );

  dependency_injection.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationBloc.initializeFCM();
  await LocalNotifications.initializeLocalNotifications();

  // await Workmanager().

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sent Sat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Sent Sat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationBloc(
            firebaseMessaging: dependency_injection.sl<FirebaseMessaging>(),
            requestLocalNotificationPermissions:
                LocalNotifications.requestPermissionLocalNotifications,
          )..add(NotificationRequestedPermission()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state.tokenFCM != null) {}
            },
          ),
        ],
        child: MainActivityPage(),
      ),
    );
  }
}
