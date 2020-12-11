// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

Restaurant restaurantFromJson(String str) =>
    Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  Restaurant({
    this.restaurants,
  });

  List<RestaurantElement> restaurants;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        restaurants: json["restaurants"] == null
            ? null
            : List<RestaurantElement>.from(
                json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurants": restaurants == null
            ? null
            : List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class RestaurantElement {
  RestaurantElement({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
    this.menus,
  });

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  Menus menus;

  factory RestaurantElement.fromJson(Map<String, dynamic> json) =>
      RestaurantElement(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        pictureId: json["pictureId"] == null ? null : json["pictureId"],
        city: json["city"] == null ? null : json["city"],
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        menus: json["menus"] == null ? null : Menus.fromJson(json["menus"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "pictureId": pictureId == null ? null : pictureId,
        "city": city == null ? null : city,
        "rating": rating == null ? null : rating,
        "menus": menus == null ? null : menus.toJson(),
      };
}

class Menus {
  Menus({
    this.foods,
    this.drinks,
  });

  List<TypeMenu> foods;
  List<TypeMenu> drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: json["foods"] == null
            ? null
            : List<TypeMenu>.from(
                json["foods"].map((x) => TypeMenu.fromJson(x))),
        drinks: json["drinks"] == null
            ? null
            : List<TypeMenu>.from(
                json["drinks"].map((x) => TypeMenu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": foods == null
            ? null
            : List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": drinks == null
            ? null
            : List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

class TypeMenu {
  TypeMenu({
    this.name,
  });

  String name;

  factory TypeMenu.fromJson(Map<String, dynamic> json) => TypeMenu(
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
      };
}
