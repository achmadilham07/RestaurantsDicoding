import 'package:RestaurantsDicoding/data/model/restaurant.dart';
import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/data/service/api_config.dart';
import 'package:RestaurantsDicoding/ui/detail_restaurant_screen.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:RestaurantsDicoding/widget/card_restaurant.dart';
import 'package:flutter/material.dart';

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
    var recentList = randomRestaurant(_restaurantList);
    final suggessionList = query.isEmpty
        ? recentList
        : _restaurantList
            .where((element) =>
                element.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggessionList.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.restaurant),
        title: Text(suggessionList.elementAt(index).name),
        onTap: () {
          Navigator.pushNamed(context, DetailRestaurant.routeName,
              arguments: suggessionList.elementAt(index));
        },
      ),
    );
  }
}
