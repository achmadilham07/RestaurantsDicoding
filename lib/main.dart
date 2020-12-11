import 'package:RestaurantsDicoding/ui/splash_screen.dart';
import 'package:RestaurantsDicoding/utils/router.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final firstPage = SplashScreen.routeName;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _buildAndroid();
      case TargetPlatform.iOS:
        return _buildIos();
      default:
        return _buildAndroid();
    }
  }

  MaterialApp _buildAndroid() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      initialRoute: firstPage,
      theme: ThemeData(
        primaryColor: colorPrimary,
        accentColor: colorAccent,
        primaryColorDark: colorPrimaryDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }

  CupertinoApp _buildIos() {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      initialRoute: firstPage,
      theme: CupertinoThemeData(primaryColor: Colors.blue),
    );
  }
}
