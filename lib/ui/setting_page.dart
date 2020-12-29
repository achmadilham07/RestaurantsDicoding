import 'package:RestaurantsDicoding/provider/preference_provider.dart';
import 'package:RestaurantsDicoding/provider/schedule_provider.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: _body(context),
    );
  }

  bool _isAndroidPlatform(context) {
    return Provider.of<PreferencesProvider>(context, listen: false)
        .isAndroidActive;
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Setting'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _body(context)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context1, pref, child) {
        return Material(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<ScheduleProvider>(
                builder: (context2, schedule, _) {
                  return SwitchListTile(
                    title: Text('Restaurant Notification'),
                    subtitle: Text("Enable Notification"),
                    value: pref.isDailyMessageActive,
                    onChanged: (bool value) async {
                      schedule.scheduleRestaurant(value);
                      pref.enableDailyMessage(value);
                    },
                    secondary: _isAndroidPlatform(context)
                        ? Icon(Icons.notifications_none)
                        : Icon(CupertinoIcons.alarm),
                  );
                },
              ),
              SwitchListTile(
                title: Text('Android Platform'),
                subtitle: Text(_isAndroidPlatform(context)
                    ? "Disable Android Type into IOS Type"
                    : "Enable Android Type"),
                value: _isAndroidPlatform(context),
                onChanged: (bool value) async {
                  pref.enableAndroidType(value);
                },
                secondary: _isAndroidPlatform(context)
                    ? Icon(Icons.android)
                    : Icon(CupertinoIcons.smiley),
              ),
            ],
          ),
        );
      },
    );
  }
}
