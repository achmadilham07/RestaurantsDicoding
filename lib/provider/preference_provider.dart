import 'package:RestaurantsDicoding/preference/preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPref: SharedPreferences.getInstance());

  PreferencesProvider() {
    _getDailyMessage();
  }

  bool _isDailyMessageActive = false;
  bool _isAndroidActive =
      defaultTargetPlatform == TargetPlatform.android ? true : false;

  bool get isDailyMessageActive => _isDailyMessageActive;

  bool get isAndroidActive => _isAndroidActive;

  void _getDailyMessage() async {
    _isDailyMessageActive = await preferencesHelper.isDailyMassage;
    notifyListeners();
  }

  void enableDailyMessage(bool value) {
    preferencesHelper.setDailyMessage(value);
    _getDailyMessage();
  }

  void _getAndroidType() async {
    _isAndroidActive = await preferencesHelper.isAndroid;
    notifyListeners();
  }

  void enableAndroidType(bool value) {
    preferencesHelper.setAndroid(value);
    _getAndroidType();
  }
}
