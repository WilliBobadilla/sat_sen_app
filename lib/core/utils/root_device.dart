import 'package:flutter/services.dart';

@deprecated
class RootDevice {
  @deprecated
  static Future<bool?> checkInitialDevice() async {
    try {
      final channel = MethodChannel('py.com.bancobasa/consumo');
      return channel.invokeMethod('checkDeviceRoot');
    } catch (e) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
    return true;
  }

  // static Future<void> finishActivities() async {
  //   try {
  //     final channel = MethodChannel('py.com.bancobasa/consumo');
  //     return channel.invokeMethod('finishActivities');
  //   } catch (e) {
  //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //   }
  // }
  //
  // static Future<void> checkAndFinish() async {
  //   try {
  //
  //     final result = await checkInitialDevice();
  //
  //     if (result) {
  //       final channel = MethodChannel('py.com.bancobasa/consumo');
  //       return channel.invokeMethod('finishActivities');
  //     }
  //   } catch (e) {
  //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //   }
  // }
}
