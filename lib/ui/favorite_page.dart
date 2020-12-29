import 'package:RestaurantsDicoding/provider/db_provider.dart';
import 'package:RestaurantsDicoding/utils/result_state.dart';
import 'package:RestaurantsDicoding/widget/card_restaurant.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = '/favorite';

  @override
  Widget build(BuildContext context) {
    _reload(context);
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  _reload(context) {
    var provider = Provider.of<DbProvider>(context, listen: false);
    provider.getFavorite();
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Favorite List'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            _reload(context);
          },
          child: Icon(CupertinoIcons.refresh_circled),
        ),
      ),
      child: _buildFutureBuilder(context),
    );
  }

  Scaffold _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite List"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _reload(context);
            },
          )
        ],
      ),
      body: _buildFutureBuilder(context),
    );
  }

  Widget _buildFutureBuilder(BuildContext context) {
    return Consumer<DbProvider>(
      builder: (context, provider, child) {
        switch (provider.state) {
          case ResultState.Loading:
            return Center(child: CircularProgressIndicator());
          case ResultState.HasData:
            return ListView.builder(
              itemCount: provider.list.length,
              itemBuilder: (context, index) {
                var restaurant = (provider.list[index].getRestaurant);
                return Material(
                  child: RestaurantCard(item: restaurant),
                );
              },
            );
          case ResultState.NoData:
            return Center(child: Text(provider.message));
          case ResultState.Error:
            return Center(child: Text(provider.message));
          default:
            return Center(child: Text(''));
        }
      },
    );
  }
}
