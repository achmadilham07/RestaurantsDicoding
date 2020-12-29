import 'package:RestaurantsDicoding/data/model/failure_network.dart';
import 'package:RestaurantsDicoding/data/model/restaurant.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/data/model/review_response.dart';
import 'package:RestaurantsDicoding/service/api_config.dart';
import 'package:RestaurantsDicoding/utils/result_state.dart';
import 'package:flutter/cupertino.dart';

class RestaurantProvider extends ChangeNotifier {
  //
  final ApiConfig _apiConfig = ApiConfig();

  RestaurantProvider();

  //
  Restaurants _restaurants;
  Restaurant _restaurant;
  ReviewResponse _reviewResponse;
  String _message = "";
  List<Restaurant> _listRestaurant;
  ResultState _state = ResultState.Loading;
  FailureNetwork _failureNetwork;

  //
  String get message => _message;

  Restaurants get restaurants => _restaurants;

  Restaurant get restaurant => _restaurant;

  ReviewResponse get reviewResponse => _reviewResponse;

  void setRestaurant(Restaurant list) => _restaurant = list;

  ResultState get state => _state;

  void setState(ResultState resultState) => _state = resultState;

  List<Restaurant> get listRestaurant => _listRestaurant;

  void fetchAllRestaurant() => _fetchAllRestaurant();

  void fetchRestaurant(String id) => _fetchDetailRestaurant(id);

  void fetchSearchRestaurant(String query) => _fetchSearchRestaurant(query);

  void fetchNewReview(String id, String name, String review) =>
      _fetchNewReview(id, name, review);

  //
  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _setResultStateLoading();

      final restaurants = await _apiConfig.getRestaurants();
      if (restaurants.restaurants.isEmpty || restaurants.error) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = "Empty Data";
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurants = restaurants;
      }
    } on FailureNetwork catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      _failureNetwork = e;
      return _message = _failureNetwork.toString();
    }
  }

  Future<dynamic> _fetchDetailRestaurant(String id) async {
    try {
      _setResultStateLoading();

      final restaurant = await _apiConfig.getDetailRestaurant(id);
      if (restaurant.restaurant == null || restaurant.error) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = "Empty Data";
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurant = restaurant.restaurant;
      }
    } on FailureNetwork catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      _failureNetwork = e;
      return _message = _failureNetwork.toString();
    }
  }

  Future<dynamic> _fetchSearchRestaurant(String query) async {
    try {
      _setResultStateLoading();

      final restaurant = await _apiConfig.searchRestaurant(query);
      if (restaurant.restaurants.isEmpty || restaurant.error) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = "Empty Data";
      } else {
        _state = ResultState.HasData;
        notifyListeners();

        return _listRestaurant = restaurant.restaurants;
      }
    } on FailureNetwork catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      _failureNetwork = e;
      return _message = _failureNetwork.toString();
    }
  }

  Future<dynamic> _fetchNewReview(
      String idRestaurant, String name, String review) async {
    try {
      _setResultStateLoading();
      notifyListeners();
      print("$idRestaurant, $name, $review");
      final restaurant =
          await _apiConfig.addReviewRestaurant(idRestaurant, name, review);
      if (restaurant.customerReviews.isEmpty || restaurant.error) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = "Empty Data";
      } else {
        _state = ResultState.HasData;
        notifyListeners();

        return _reviewResponse = restaurant;
      }
    } on FailureNetwork catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      _failureNetwork = e;
      return _message = _failureNetwork.toString();
    }
  }

  void _setResultStateLoading() {
    _state = ResultState.Loading;
  }
}
