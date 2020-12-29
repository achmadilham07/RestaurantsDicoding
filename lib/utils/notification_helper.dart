import 'dart:convert';

import 'package:RestaurantsDicoding/data/model/random_restaurant.dart';
import 'package:RestaurantsDicoding/data/model/restaurant.dart';
import 'package:RestaurantsDicoding/service/api_config.dart';
import 'package:RestaurantsDicoding/ui/detail_restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurants listRestaurants) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "dicoding restaurant";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true, true),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    var titleNotification = "<b>Trending Restaurant</b>";
    var data =
        RandomRestaurant(service: ApiConfig(), restaurants: listRestaurants);
    var titleResto = listRestaurants.restaurants[data.number()].name;

    await flutterLocalNotificationsPlugin.show(
      data.number(),
      titleNotification,
      titleResto,
      platformChannelSpecifics,
      payload: jsonEncode(listRestaurants.toJson()),
    );
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = Restaurants.fromJson(jsonDecode(payload));
      var data2 = RandomRestaurant(service: ApiConfig(), restaurants: data);
      var resto = data.restaurants[data2.number()];
      Navigator.pushNamed(context, DetailRestaurant.routeName,
          arguments: resto);
    });
  }
}
