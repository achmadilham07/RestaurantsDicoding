import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/ui/detail_restaurant_screen.dart';
import 'package:RestaurantsDicoding/ui/main_page.dart';
import 'package:RestaurantsDicoding/ui/new_comment.dart';
import 'package:RestaurantsDicoding/ui/search_page_cupertino.dart';
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
    case MainPage.routeName:
      return MaterialPageRoute(
        builder: (context) => MainPage(),
      );
    case SearchTab.routeName:
      if (args is List<Restaurant>) {
        return MaterialPageRoute(
          builder: (context) => SearchTab(restaurantList: args),
        );
      }
      return MaterialPageRoute(builder: (context) => UnknownScreen());
    case DetailRestaurant.routeName:
      if (args is Restaurant) {
        return MaterialPageRoute(
          builder: (context) => DetailRestaurant(itemId: args),
        );
      }
      return MaterialPageRoute(builder: (context) => UnknownScreen());
    case NewReview.routeName:
      if (args is String) {
        return MaterialPageRoute(
          builder: (context) => NewReview(restaurantId: args),
        );
      }
      return MaterialPageRoute(builder: (context) => UnknownScreen());
    default:
      return MaterialPageRoute(builder: (context) => UnknownScreen());
  }
}
