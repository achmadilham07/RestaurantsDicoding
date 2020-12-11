import 'package:RestaurantsDicoding/data/restaurant.dart';
import 'file:///D:/Project/Flutter/RestaurantsDicoding/lib/widget/card_restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _buildAndroid();
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
      ),
      child: _buildFutureBuilder(),
    );
  }

  Scaffold _buildAndroid() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant List App"),
      ),
      body: _buildFutureBuilder(),
    );
  }

  FutureBuilder<String> _buildFutureBuilder() {
    return FutureBuilder<String>(
      future: _loadRestaurant(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final restaurant = restaurantFromJson(snapshot.data);
          final restaurantList = restaurant.restaurants;
          return ListView.builder(
            itemCount: restaurantList.length,
            itemBuilder: (context, index) {
              return Material(
                  child: RestaurantCard(item: restaurantList[index]));
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<String> _loadRestaurant() async {
    return await DefaultAssetBundle.of(context)
        .loadString('lib/utils/restaurants.json');
  }
}
