import 'package:RestaurantsDicoding/utils/background_service.dart';
import 'package:RestaurantsDicoding/utils/date_time_helper.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/foundation.dart';

class ScheduleProvider extends ChangeNotifier {
  static const int SCHEDULE_RESTAURANT_ID = 1;
  bool _isSchedule = false;

  bool get isSchedule => _isSchedule;

  Future<bool> scheduleRestaurant(bool value) async {
    _isSchedule = value;
    if (_isSchedule) {
      print("Schedule Activated");
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        SCHEDULE_RESTAURANT_ID,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print("Schedule Canceled");
      notifyListeners();
      return await AndroidAlarmManager.cancel(
        SCHEDULE_RESTAURANT_ID,
      );
    }
  }
}
