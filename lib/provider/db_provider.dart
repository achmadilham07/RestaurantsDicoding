import 'package:RestaurantsDicoding/data/db/db_helper.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_helper.dart';
import 'package:RestaurantsDicoding/utils/result_state.dart';
import 'package:flutter/material.dart';

class DbProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  //
  ResultState _state;
  List<RestaurantHelper> _list = [];
  String _message;
  bool _isFavoriteItem = false;
  Restaurant _restaurant;

  //
  Restaurant get restaurant => _restaurant;

  String get message => _message;

  bool get isFavoriteItem => _isFavoriteItem;

  ResultState get state => _state;

  List<RestaurantHelper> get list => _list;

  Future<bool> isFavorite(id) => _isFavorite(id);

  void getFavorite() => _getFavorite();

  void _getFavorite() async {
    _state = ResultState.Loading;
    _list = await _databaseHelper.getFavorite();
    if (_list.length > 0) {
      _state = ResultState.HasData;
      _message = "Favorite List has ${_list.length} item.";
      notifyListeners();
    } else {
      _state = ResultState.NoData;
      _message = "No Favorite Item.";
      notifyListeners();
    }
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await _databaseHelper.insertFavorite(restaurant);
      _isFavorite(restaurant.id);
      _message = "Restaurant data is saved.";
      notifyListeners();
    } catch (e) {
      _state = ResultState.Error;
      _message = "Restaurant data cannot be saved.";
      notifyListeners();
    }
  }

  Future<bool> _isFavorite(String id) async {
    final favoriteResto = await _databaseHelper.getFavoriteById(id);
    _isFavoriteItem = favoriteResto.isNotEmpty;
    notifyListeners();
    if (_isFavoriteItem) {
      _restaurant = restoFromJson(favoriteResto["restaurant"]);
      notifyListeners();
    }
    return _isFavoriteItem;
  }

  void removeFavorite(String id) async {
    try {
      await _databaseHelper.removeFavorite(id);
      _isFavorite(id);
      _message = "Restaurant data is removed.";
      notifyListeners();
    } catch (e) {
      _state = ResultState.Error;
      _message = "Restaurant data cannot be removed.";
      notifyListeners();
    }
  }
}
