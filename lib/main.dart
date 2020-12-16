import 'dart:io';

import 'package:RestaurantsDicoding/provider/restaurant_provider.dart';
import 'package:RestaurantsDicoding/ui/splash_screen.dart';
import 'package:RestaurantsDicoding/utils/http_override.dart';
import 'package:RestaurantsDicoding/utils/router.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final firstPage = SplashScreen.routeName;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => RestaurantProvider()),
      ],
      child: PlatformWidget(
        androidBuilder: _buildAndroid,
        iosBuilder: _buildIos,
      ),
    );
  }

  MaterialApp _buildAndroid(BuildContext context) {
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

  CupertinoApp _buildIos(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      initialRoute: firstPage,
      theme: CupertinoThemeData(primaryColor: Colors.blue),
    );
  }
}
