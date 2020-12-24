import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/provider/restaurant_provider.dart';
import 'package:RestaurantsDicoding/ui/search_page_cupertino.dart';
import 'package:RestaurantsDicoding/ui/search_page_material.dart';
import 'package:RestaurantsDicoding/widget/card_restaurant.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context, listen: false);
    provider.fetchAllRestaurant();
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
            var list = _getRestaurantList(context);
            Navigator.pushNamed(context, SearchTab.routeName, arguments: list);
          },
          child: Icon(CupertinoIcons.search),
        ),
      ),
      child: _buildFutureBuilder(context),
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
                var list = _getRestaurantList(context);
                showSearch(
                    context: context,
                    delegate: SearchViewRestaurantList(restaurantList: list));
              })
        ],
      ),
      body: _buildFutureBuilder(context),
    );
  }

  List<Restaurant> _getRestaurantList(BuildContext context) {
    return Provider.of<RestaurantProvider>(context, listen: false)
        .restaurants
        .restaurants;
  }

  Widget _buildFutureBuilder(BuildContext context) {
    var provider = Provider.of<RestaurantProvider>(context);
    switch (provider.state) {
      case ResultState.Loading:
        return Center(child: CircularProgressIndicator());
      case ResultState.HasData:
        return ListView.builder(
          itemCount: provider.restaurants.restaurants.length,
          itemBuilder: (context, index) {
            return Material(
                child: RestaurantCard(
                    item: provider.restaurants.restaurants[index]));
          },
        );
      case ResultState.NoData:
        return Center(child: Text(provider.message));
      case ResultState.Error:
        return Center(child: Text(provider.message));
      default:
        return Center(child: Text(''));
    }
  }
}
