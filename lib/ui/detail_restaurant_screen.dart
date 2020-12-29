import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/provider/db_provider.dart';
import 'package:RestaurantsDicoding/provider/preference_provider.dart';
import 'package:RestaurantsDicoding/provider/restaurant_provider.dart';
import 'package:RestaurantsDicoding/ui/new_comment.dart';
import 'package:RestaurantsDicoding/utils/result_state.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DetailRestaurant extends StatefulWidget {
  static const routeName = '/detail_restaurant';
  final Restaurant itemId;

  DetailRestaurant({Key key, this.itemId}) : super(key: key);

  @override
  _DetailRestaurantState createState() => _DetailRestaurantState();
}

class _DetailRestaurantState extends State<DetailRestaurant> {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  CupertinoPageScaffold _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(child: _fetchData()),
    );
  }

  Scaffold _buildAndroid(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _fetchData()),
    );
  }

  Widget _body() {
    //_fetchData();
    return Consumer<RestaurantProvider>(
      builder: (context, provider, widget) {
        switch (provider.state) {
          case ResultState.Loading:
            return Center(child: CircularProgressIndicator());
          case ResultState.HasData:
            return _buildFullBody(context);
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

  _addFavorite(context) async {
    var _restaurantData =
        Provider.of<RestaurantProvider>(context, listen: false).restaurant;
    var providerDb = Provider.of<DbProvider>(context, listen: false);

    if (!providerDb.isFavoriteItem) {
      providerDb.addFavorite(_restaurantData);
    } else {
      providerDb.removeFavorite(widget.itemId.id);
    }
  }

  Widget _buildFullBody(BuildContext context) {
    var providerDb = Provider.of<DbProvider>(context, listen: false);
    Restaurant _restaurantData;
    if (providerDb.isFavoriteItem) {
      _restaurantData = providerDb.restaurant;
      Provider.of<RestaurantProvider>(context).setRestaurant(_restaurantData);
      print("from database");
    } else {
      _restaurantData = Provider.of<RestaurantProvider>(context).restaurant;
      print("from internet");
    }

    return _isAndroidPlatform()
        ? CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImage(context),
                ),
                actions: [
                  Consumer<DbProvider>(
                    builder: (context, provider, child) {
                      return IconButton(
                        tooltip: "Favorite",
                        icon: Icon(provider.isFavoriteItem
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: () {
                          _addFavorite(context);
                        },
                      );
                    },
                  ),
                ],
              ),
        _restaurantData == null
            ? SliverFillRemaining(
          hasScrollBody: false,
          child: _mainBody(context),
        )
            : SliverList(
          delegate: SliverChildListDelegate([_mainBody(context)]),
        ),
        _setTitleItemSliver(context),
        _listReviewSliver(context),
      ],
    )
        : CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text('Restaurant'),
          trailing: Consumer<DbProvider>(
            builder: (context, provider, child) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  _addFavorite(context);
                },
                child: Icon(provider.isFavoriteItem
                    ? CupertinoIcons.square_favorites_alt_fill
                    : CupertinoIcons.square_favorites_alt),
              );
            },
          ),
        ),
        _restaurantData == null
            ? SliverFillRemaining(
          hasScrollBody: false,
          child: _mainBody(context),
        )
            : SliverList(
          delegate: SliverChildListDelegate([_mainBody(context)]),
        ),
        _setTitleItemSliver(context),
        _listReviewSliver(context),
      ],
    );
  }

  bool _isAndroidPlatform() {
    return Provider
        .of<PreferencesProvider>(context, listen: false)
        .isAndroidActive;
  }

  Hero _buildImage(BuildContext context) {
    var _restaurantData = Provider
        .of<RestaurantProvider>(context)
        .restaurant;
    return Hero(
      tag: widget.itemId.id,
      child: _restaurantData?.pictureId == null
          ? Image.asset("images/food-store.png", fit: BoxFit.cover)
          : ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
        child: FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          image: _restaurantData.getPictureLink(),
          placeholder: "images/food-store.png",
        ),
      ),
    );
  }

  Widget _buildBodyText(BuildContext context) {
    var _restaurantData = Provider.of<RestaurantProvider>(context).restaurant;
    return Column(
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
                  Flexible(
                    child: Text(
                      _restaurantData.name,
                      style: Theme.of(context).textTheme.headline5.apply(
                          fontWeightDelta: 2,
                          color: _isAndroidPlatform()
                              ? Colors.black54
                              : Colors.black26),
                      softWrap: true,
                    ),
                    fit: FlexFit.loose,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/baseline_grade_black_48dp.png",
                        color: _isAndroidPlatform()
                            ? Colors.yellow[600]
                            : Colors.yellow,
                        width: 28,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _restaurantData.rating.toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6
                            .apply(
                            color: _isAndroidPlatform()
                                ? Colors.black54
                                : Colors.black26),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                _restaurantData.city,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6
                    .apply(color: colorPrimary),
              ),
              SizedBox(height: 20),
              _setTitleItem(context, "Description"),
              SizedBox(height: 6),
              Text(
                _restaurantData.description,
                style: Theme
                    .of(context)
                    .textTheme
                    .caption
                    .apply(fontSizeDelta: 3, color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        if (_restaurantData.menus.foods.length > 0)
          _setMenu(context, _restaurantData.menus.foods, "Food Menus")
        else
          _setTitleItem(context, "No Food Menus"),
        SizedBox(height: 20),
        if (_restaurantData.menus.drinks.length > 0)
          _setMenu(context, _restaurantData.menus.drinks, "Drink Menus")
        else
          _setTitleItem(context, "No Drink Menus"),
        SizedBox(height: 20),
      ],
    );
  }

  Text _setTitleItem(BuildContext context, String title) {
    return Text(
      title,
      style: Theme
          .of(context)
          .textTheme
          .button
          .apply(fontSizeDelta: 5, color: Colors.grey[400]),
    );
  }

  Widget _setMenu(BuildContext context, List<TypeMenu> listItemMenu,
      String title) {
    final sizePadding = 14.0;
    final sizeFont = 14.0;
    final sizePrefix = 11.0;
    final sizeContainer = (sizePadding * 2) + sizeFont + sizePrefix;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: _setTitleItem(context, title),
        ),
        SizedBox(height: 6),
        Container(
          height: sizeContainer.toDouble(),
          child: ListView(
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

  Widget _mainBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (!_isAndroidPlatform()) _buildImage(context),
        _buildBodyText(context),
      ],
    );
  }

  Widget _listReviewSliver(BuildContext context) {
    var _restaurantData = Provider
        .of<RestaurantProvider>(context)
        .restaurant;
    return _restaurantData?.customerReviews == null
        ? SliverFillRemaining()
        : SliverPadding(
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
                (context, index) =>
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin:
                  EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Oleh ',
                              style:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText2,
                              children: <TextSpan>[
                                TextSpan(
                                    text: _restaurantData
                                        .customerReviews[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            _restaurantData.customerReviews[index].date,
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                          ),
                          SizedBox(height: 6),
                          Text(
                            _restaurantData.customerReviews[index].review,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            childCount: _restaurantData.customerReviews.length),
      ),
      padding: EdgeInsets.only(bottom: 20),
    );
  }

  Widget _setTitleItemSliver(BuildContext context) {
    var _restaurantData = Provider
        .of<RestaurantProvider>(context)
        .restaurant;
    return _restaurantData?.customerReviews == null
        ? SliverFillRemaining()
        : SliverPadding(
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            _setTitleItem(context, "Customer Review"),
            FlatButton.icon(
              textColor: colorPrimary,
              onPressed: () {
                Navigator.of(context).pushNamed(NewReview.routeName,
                    arguments: widget.itemId.id);
              },
              icon: Icon(
                _isAndroidPlatform() ? Icons.create : CupertinoIcons.add,
              ),
              label: Text("New Comment"),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _fetchData() {
    var provider = Provider.of<DbProvider>(context, listen: false);
    return FutureBuilder<bool>(
      future: provider.isFavorite(widget.itemId.id),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        } else if (snapshot.hasData) {
          bool isFav = snapshot.data;
          if (isFav) {
            print("get from database");
          } else {
            var provider =
            Provider.of<RestaurantProvider>(context, listen: false);
            provider.fetchRestaurant(widget.itemId.id);
            print("get from internet");
          }
          return _body();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
