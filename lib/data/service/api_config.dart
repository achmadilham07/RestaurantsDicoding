import 'dart:io';

import 'package:RestaurantsDicoding/data/model/failure_network.dart';
import 'package:RestaurantsDicoding/data/model/restaurant.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_new_review.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  //
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<Restaurants> getRestaurants() async {
    try {
      final response = await http.get(_baseUrl + "list");
      if (response.statusCode == 200) {
        return restaurantFromJson(response.body);
      } else {
        throw FailureNetwork('Failed to load');
      }
    } on SocketException {
      throw FailureNetwork('No Internet Connection');
    } on HttpException {
      throw FailureNetwork("Couldn't find the post");
    } on FormatException {
      throw FailureNetwork("Bad response format");
    }
  }

  Future<Restaurants> searchRestaurant(String query) async {
    try {
      final response = await http.get(_baseUrl + "search?q=$query");
      if (response.statusCode == 200) {
        return restaurantFromJson(response.body);
      } else {
        throw FailureNetwork('Failed to load');
      }
    } on SocketException {
      throw FailureNetwork('No Internet Connection');
    } on HttpException {
      throw FailureNetwork("Couldn't find the post");
    } on FormatException {
      throw FailureNetwork("Bad response format");
    }
  }

  Future<RestaurantDetail> getDetailRestaurant(String id) async {
    try {
      final response = await http.get(_baseUrl + "detail/$id");
      if (response.statusCode == 200) {
        return restaurantDetailFromJson(response.body);
      } else {
        throw FailureNetwork('Failed to load');
      }
    } on SocketException {
      throw FailureNetwork('No Internet Connection');
    } on HttpException {
      throw FailureNetwork("Couldn't find the post");
    } on FormatException {
      throw FailureNetwork("Bad response format");
    }
  }

  Future<RestaurantDetail> addReviewRestaurant(
      String idRestaurant, String nameReviewer, String newReview) async {
    final newHeaders = {
      'Content-Type': 'application/json',
      'X-Auth-Token': '12345'
    };
    //
    final review = NewCustomerReview(
        id: idRestaurant, name: nameReviewer, review: newReview);
    final jsonReview = newCustomerReviewToJson(review);

    //
    final response = await http.post(_baseUrl + "review",
        body: jsonReview, headers: newHeaders);
    if (response.statusCode == 200) {
      return restaurantDetailFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }
}
