import 'package:RestaurantsDicoding/data/restaurant.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailRestaurant extends StatelessWidget {
  static const routeName = '/detail_restaurant';
  final RestaurantElement item;

  DetailRestaurant({Key key, this.item}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  CupertinoPageScaffold _buildIos() {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text('Restaurant'),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              // fillOverscroll: true,
              child: Column(
                children: [
                  _buildImage(),
                  _body(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Scaffold _buildAndroid() {
    return Scaffold(
      key: this._scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildImage(),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              // fillOverscroll: true,
              child: _body(),
            )
          ],
        ),
      ),
    );
  }

  Hero _buildImage() {
    return Hero(
        tag: item.id,
        child: ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            child: Image.network(
              item.pictureId,
              fit: BoxFit.cover,
            )));
  }

  Widget _body() {
    return Container(
      color: Colors.grey[50],
      clipBehavior: Clip.none,
      // padding: EdgeInsets.only(bottom: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "images/baseline_grade_black_48dp.png",
                          color: Colors.yellow,
                          width: 28,
                        ),
                        SizedBox(width: 4),
                        Text(
                          item.rating.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  item.city,
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                _setTitleItem("Description"),
                SizedBox(height: 6),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          if (item.menus.foods.length > 0)
            _setMenu(item.menus.foods, "Food Menus")
          else
            _setTitleItem("No Food Menus"),
          SizedBox(height: 20),
          if (item.menus.drinks.length > 0)
            _setMenu(item.menus.drinks, "Drink Menus")
          else
            _setTitleItem("No Drink Menus"),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Text _setTitleItem(String title) {
    return Text(
      title,
      style: TextStyle(
          color: colorAccentLight, fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  Widget _setMenu(List<TypeMenu> listItemMenu, String title) {
    final sizePadding = 16.0;
    final sizeFont = 16.0;
    final sizePrefix = 11.0;
    final sizeContainer = (sizePadding * 2) + sizeFont + sizePrefix;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: _setTitleItem(title),
        ),
        SizedBox(height: 6),
        Container(
          height: sizeContainer.toDouble(),
          child: ListView(
            // clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            scrollDirection: Axis.horizontal,
            children: listItemMenu.map((element) {
              return Card(
                color: colorPrimaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(sizePadding),
                    child: Column(
                      children: [
                        Text(
                          element.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: sizeFont.toDouble(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
