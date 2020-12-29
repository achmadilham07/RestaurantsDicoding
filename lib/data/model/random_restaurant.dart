import 'dart:math';

import 'package:RestaurantsDicoding/data/model/restaurant.dart';
import 'package:RestaurantsDicoding/service/api_config.dart';
import 'package:flutter/foundation.dart';

class RandomRestaurant {
  ApiConfig service;
  Restaurants restaurants;

  RandomRestaurant({@required this.service, @required this.restaurants});

  int _index = 0;

  int number() {
    return _index += Random().nextInt(restaurants.restaurants.length);
  }
}
