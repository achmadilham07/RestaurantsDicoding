import 'dart:math';

import 'package:RestaurantsDicoding/data/model/restaurant.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/data/service/api_config.dart';
import 'package:RestaurantsDicoding/ui/detail_restaurant_screen.dart';
import 'package:RestaurantsDicoding/widget/card_restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  Future<Restaurants> _restaurantList;
  Restaurants _restaurantData;

  @override
  void initState() {
    _restaurantList = ApiConfig().getRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _buildIos();
      case TargetPlatform.iOS:
        return _buildIos();
      default:
        return _buildAndroid();
    }
  }

  Widget _buildIos() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Restaurant List App'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showSearch(
                context: context,
                delegate:
                    SearchViewRestaurantList(_restaurantData.restaurants));
          },
          child: Icon(CupertinoIcons.search),
        ),
      ),
      child: _buildFutureBuilder(),
    );
  }

  Scaffold _buildAndroid() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant List App"),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                showSearch(
                    context: context,
                    delegate:
                    SearchViewRestaurantList(_restaurantData.restaurants));
              })
        ],
      ),
      body: _buildFutureBuilder(),
    );
  }

  Widget _buildFutureBuilder() {
    return FutureBuilder(
      future: _restaurantList,
      builder: (context, AsyncSnapshot<Restaurants> snapshot) {
        if (snapshot.hasData) {
          _restaurantData = snapshot.data;
          if (!_restaurantData.error) {
            final restaurantList = _restaurantData.restaurants;
            return ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                return Material(
                    child: RestaurantCard(item: restaurantList[index]));
              },
            );
          } else {
            Center(child: Text("No Restaurant that you want"));
          }
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SearchViewRestaurantList extends SearchDelegate<String> {
  //
  final List<Restaurant> _restaurantList;

  SearchViewRestaurantList(this._restaurantList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
            showSuggestions(context);
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        progress: transitionAnimation,
        icon: AnimatedIcons.menu_arrow,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: ApiConfig().searchRestaurant(query),
      builder: (context, AsyncSnapshot<Restaurants> snapshot) {
        if (snapshot.hasData) {
          var _restaurantData = snapshot.data;
          if (!_restaurantData.error) {
            final restaurantList = _restaurantData.restaurants;
            return restaurantList.isEmpty
                ? Center(
              child: Text("No Restaurant that you want"),
            )
                : ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                return Material(
                    child: RestaurantCard(item: restaurantList[index]));
              },
            );
          } else {
            Center(child: Text("No Restaurant that you want"));
          }
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var recentList = randomRestaurant();
    final suggessionList = query.isEmpty
        ? recentList
        : _restaurantList
        .where((element) =>
        element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggessionList.length,
      itemBuilder: (context, index) =>
          ListTile(
            leading: Icon(Icons.restaurant),
            title: Text(suggessionList
                .elementAt(index)
                .name),
            onTap: () {
              Navigator.pushNamed(context, DetailRestaurant.routeName,
                  arguments: suggessionList.elementAt(index));
            },
          ),
    );
  }

  List<Restaurant> randomRestaurant() {
    List<Restaurant> temp = [];
    var rng = new Random();
    List<int> indexList = [rng.nextInt(_restaurantList.length)];
    while (indexList.length < 6) {
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
}
