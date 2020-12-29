import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPref;

  PreferencesHelper({@required this.sharedPref});

  static const DAILY_MESSAGE = "DAILY_MESSAGE";
  static const ANDROID_TYPE = "ANDROID_TYPE";

  Future<bool> get isDailyMassage async {
    final prefs = await sharedPref;
    return prefs.getBool(DAILY_MESSAGE) ?? false;
  }

  void setDailyMessage(bool value) async {
    final prefs = await sharedPref;
    prefs.setBool(DAILY_MESSAGE, value);
  }

  Future<bool> get isAndroid async {
    final prefs = await sharedPref;
    return prefs.getBool(ANDROID_TYPE) ?? false;
  }

  void setAndroid(bool value) async {
    final prefs = await sharedPref;
    prefs.setBool(ANDROID_TYPE, value);
  }
}
