import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/ui/detail_restaurant_screen.dart';
import 'package:flutter/material.dart';

class SearchResultListView extends StatelessWidget {
  const SearchResultListView({
    Key key,
    @required this.suggessionList,
  }) : super(key: key);

  final List<Restaurant> suggessionList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggessionList.length,
      itemBuilder: (context, index) => Material(
        child: ListTile(
          leading: Icon(Icons.restaurant),
          title: Text(suggessionList.elementAt(index).name),
          subtitle: Text(suggessionList.elementAt(index).city),
          onTap: () {
            Navigator.pushNamed(context, DetailRestaurant.routeName,
                arguments: suggessionList.elementAt(index));
          },
        ),
      ),
    );
  }
}
