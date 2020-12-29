// To parse this JSON data, do
//
//     final restaurantHelper = restaurantHelperFromJson(jsonString);

import 'dart:convert';

import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';

RestaurantHelper restaurantHelperFromJson(String str) =>
    RestaurantHelper.fromJson(json.decode(str));

String restaurantHelperToJson(RestaurantHelper data) =>
    json.encode(data.toJson());

List<RestaurantHelper> listRestaurantHelperFromJson(String str) =>
    List<RestaurantHelper>.from(
        json.decode(str).map((x) => RestaurantHelper.fromJson(x)));

String listRestaurantHelperToJson(List<RestaurantHelper> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestaurantHelper {
  RestaurantHelper({
    this.id,
    this.restaurant,
  });

  String id;
  String restaurant;

  factory RestaurantHelper.fromJson(Map<String, dynamic> json) =>
      RestaurantHelper(
        id: json["id"] == null ? null : json["id"],
        restaurant: json["restaurant"] == null ? null : json["restaurant"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "restaurant": restaurant == null ? null : restaurant,
      };

  Restaurant get getRestaurant => restoFromJson(restaurant);
}
