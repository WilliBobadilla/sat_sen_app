import 'dart:developer' as developer;
import 'package:workmanager/workmanager.dart';
import 'alert_worker.dart'; // or your worker logic file

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('✅ Background task executed: $task');
    //return Future.value(true);
    developer.log('✅Executing task: $task');
    // await AlertWorker.initializeNotifications();
    await AlertWorker.checkAlerts();
    return Future.value(true);
  });
}
