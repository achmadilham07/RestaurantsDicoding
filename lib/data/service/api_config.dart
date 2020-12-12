import 'package:RestaurantsDicoding/data/model/restaurant.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  //
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<Restaurants> getRestaurants() async {
    final response = await http.get(_baseUrl + "list");
    if (response.statusCode == 200) {
      return restaurantFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<Restaurants> searchRestaurant(String id) async {
    final response = await http.get(_baseUrl + "search?q=$id");
    if (response.statusCode == 200) {
      return restaurantFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<RestaurantDetail> getDetailRestaurant(String id) async {
    final response = await http.get(_baseUrl + "detail/$id");
    if (response.statusCode == 200) {
      return restaurantDetailFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }
}
