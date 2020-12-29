import 'dart:isolate';
import 'dart:ui';

import 'package:RestaurantsDicoding/main.dart';
import 'package:RestaurantsDicoding/service/api_config.dart';
import 'package:RestaurantsDicoding/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService _instance;
  static String _isolateName = 'isolate';
  static SendPort _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    print('Alartm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await ApiConfig().getRestaurants();
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  Future<void> someTask() async {
    print('Execute some process');
  }
}
