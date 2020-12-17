import 'dart:math';
import 'dart:ui';

import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';

const colorPrimary = Color(0xff34626c);
const colorPrimaryDark = Color(0xFF839b97);
const colorAccent = Color(0xFFc6b497);
const colorAccentLight = Color(0xFFcfd3ce);

List<Restaurant> randomRestaurant(List<Restaurant> _restaurantList,
    [int number = 5]) {
  List<Restaurant> temp = [];
  var rng = new Random();
  List<int> indexList = [rng.nextInt(_restaurantList.length)];
  while (indexList.length < number) {
    int index = rng.nextInt(_restaurantList.length - 1);
    if (!indexList.contains(index)) {
      indexList.add(index);
    }
  }

  indexList.forEach((i) {
    temp.add(_restaurantList.elementAt(i));
  });

  return temp;
}
