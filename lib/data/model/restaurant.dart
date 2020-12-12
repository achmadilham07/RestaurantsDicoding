// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';

Restaurants restaurantFromJson(String str) =>
    Restaurants.fromJson(json.decode(str));

String restaurantToJson(Restaurants data) => json.encode(data.toJson());

class Restaurants {
  Restaurants({
    this.error,
    this.restaurants,
  });

  bool error;
  List<Restaurant> restaurants;

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        error: json["error"] == null ? null : json["error"],
        restaurants: json["restaurants"] == null
            ? null
            : List<Restaurant>.from(
                json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "restaurants": restaurants == null
            ? null
            : List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
