import 'package:RestaurantsDicoding/provider/preference_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformWidget extends StatelessWidget {
  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;

  PlatformWidget({@required this.androidBuilder, @required this.iosBuilder});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        if (provider.isAndroidActive) {
          return androidBuilder(context);
        } else {
          return iosBuilder(context);
        }

        // switch (defaultTargetPlatform) {
        //   case TargetPlatform.android:
        //     return androidBuilder(context);
        //   case TargetPlatform.iOS:
        //     return iosBuilder(context);
        //   default:
        //     return androidBuilder(context);
        // }
      },
    );
  }
}
