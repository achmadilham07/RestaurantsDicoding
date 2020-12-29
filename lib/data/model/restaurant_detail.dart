// To parse this JSON data, do
//
//     final restaurantDetail = restaurantDetailFromJson(jsonString);

import 'dart:convert';

RestaurantDetail restaurantDetailFromJson(String str) =>
    RestaurantDetail.fromJson(json.decode(str));

String restaurantDetailToJson(RestaurantDetail data) =>
    json.encode(data.toJson());

Restaurant restoFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restoToJson(Restaurant data) {
  var string = json.encode(data.toJson());
  return string;
}

class RestaurantDetail {
  RestaurantDetail({
    this.error,
    this.message,
    this.restaurant,
  });

  bool error;
  String message;
  Restaurant restaurant;

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        error: json["error"] == null ? null : json["error"],
        message: json["message"] == null ? null : json["message"],
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "message": message == null ? null : message,
        "restaurant": restaurant == null ? null : restaurant.toJson(),
      };
}

class Restaurant {
  Restaurant({
    this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });

  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<TypeMenu> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReviews;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        city: json["city"] == null ? null : json["city"],
        address: json["address"] == null ? null : json["address"],
        pictureId: json["pictureId"] == null ? null : json["pictureId"],
        categories: json["categories"] == null
            ? null
            : List<TypeMenu>.from(
                json["categories"].map((x) => TypeMenu.fromJson(x))),
        menus: json["menus"] == null ? null : Menus.fromJson(json["menus"]),
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        customerReviews: json["customerReviews"] == null
            ? null
            : List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "city": city == null ? null : city,
        "address": address == null ? null : address,
        "pictureId": pictureId == null ? null : pictureId,
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories.map((x) => x.toJson())),
        "menus": menus == null ? null : menus.toJson(),
        "rating": rating == null ? null : rating,
        "customerReviews": customerReviews == null
            ? null
            : List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };

  String getPictureLink() {
    return "https://restaurant-api.dicoding.dev/images/medium/" + pictureId;
  }
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

class CustomerReview {
  CustomerReview({
    this.name,
    this.review,
    this.date,
  });

  String name;
  String review;
  String date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"] == null ? null : json["name"],
        review: json["review"] == null ? null : json["review"],
        date: json["date"] == null ? null : json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "review": review == null ? null : review,
        "date": date == null ? null : date,
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
