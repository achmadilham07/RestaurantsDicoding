import 'dart:convert';

import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_helper.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createObject();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createObject();
    }

    return _databaseHelper;
  }

  static const String _tblFavorite = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/resto.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorite (
          id TEXT PRIMARY KEY,
          restaurant TEXT
        )''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final helper = _setRestaurantToHelperJson(restaurant);
    final db = await database;
    await db.insert(_tblFavorite, helper);
  }

  Future<List<RestaurantHelper>> getFavorite() async {
    final db = await database;

    List<Map<String, dynamic>> results =
        await db.rawQuery("SELECT * FROM $_tblFavorite");
    List<RestaurantHelper> list = [];

    var jsonData = json.encode(results);
    list = listRestaurantHelperFromJson(jsonData);
    return list;
  }

  Future<Map<String, dynamic>> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _setRestaurantToHelperJson(Restaurant restaurant) {
    var jsonString = json.encode(restaurant);
    var restaurantHelper = RestaurantHelper(
      id: restaurant.id,
      restaurant: jsonString,
    );
    var jsonData = restaurantHelper.toJson();
    return jsonData;
  }
}
