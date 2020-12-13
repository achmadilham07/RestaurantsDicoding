import 'package:RestaurantsDicoding/data/model/restaurant.dart';
import 'package:RestaurantsDicoding/data/service/api_config.dart';
import 'package:RestaurantsDicoding/ui/search_page_cupertino.dart';
import 'package:RestaurantsDicoding/ui/search_page_material.dart';
import 'package:RestaurantsDicoding/widget/card_restaurant.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
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
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Restaurant List App'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pushNamed(context, SearchTab.routeName,
                arguments: _restaurantData.restaurants);
          },
          child: Icon(CupertinoIcons.search),
        ),
      ),
      child: _buildFutureBuilder(),
    );
  }

  Scaffold _buildAndroid(BuildContext context) {
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
