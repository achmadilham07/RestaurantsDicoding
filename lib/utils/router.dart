import 'package:RestaurantsDicoding/data/restaurant.dart';
import 'package:RestaurantsDicoding/ui/detail_restaurant_screen.dart';
import 'package:RestaurantsDicoding/ui/home_page.dart';
import 'package:RestaurantsDicoding/ui/splash_screen.dart';
import 'package:RestaurantsDicoding/ui/unknown_screen.dart';
import 'package:flutter/material.dart';

Route generateRoute(settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => SplashScreen(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    case DetailRestaurant.routeName:
      if (args is RestaurantElement) {
        return MaterialPageRoute(
          builder: (context) => DetailRestaurant(item: args),
        );
      }
      return MaterialPageRoute(builder: (context) => UnknownScreen());
    default:
      return MaterialPageRoute(builder: (context) => UnknownScreen());
  }
}
