import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/provider/restaurant_provider.dart';
import 'package:RestaurantsDicoding/utils/result_state.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:RestaurantsDicoding/widget/search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchViewRestaurantList extends SearchDelegate<String> {
  //
  final List<Restaurant> restaurantList;

  SearchViewRestaurantList({@required this.restaurantList});

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
    return _resultList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _resultList(context);
  }

  Widget _resultList(BuildContext context) {
    Provider.of<RestaurantProvider>(context, listen: false)
        .fetchSearchRestaurant(query);
    return Consumer<RestaurantProvider>(
      builder: (context, state, widget) {
        switch (state.state) {
          case ResultState.Loading:
            return Center(child: CircularProgressIndicator());
          case ResultState.HasData:
            List<Restaurant> listRestaurant = query.isEmpty
                ? randomRestaurant(restaurantList)
                : state.listRestaurant;
            return SearchResultListView(suggessionList: listRestaurant);
          case ResultState.NoData:
            return Center(child: Text(state.message));
          case ResultState.Error:
            return Center(child: Text(state.message));
          default:
            return Center(child: Text(''));
        }
      },
    );
  }
}
