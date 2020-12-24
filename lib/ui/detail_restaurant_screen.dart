import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/provider/restaurant_provider.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DetailRestaurant extends StatelessWidget {
  static const routeName = '/detail_restaurant';
  final Restaurant itemId;

  DetailRestaurant({Key key, this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RestaurantProvider>(context, listen: false);
    provider.fetchRestaurant(itemId.id);
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

  Widget _fetchData() {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, widget) {
        switch (provider.state) {
          case ResultState.Loading:
            return Center(child: CircularProgressIndicator());
          case ResultState.HasData:
            //_restaurantData = provider.restaurant;
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

  Widget _buildFullBody(BuildContext context) {
    var _restaurantData = Provider.of<RestaurantProvider>(context).restaurant;
    return isAndroidPlatform()
        ? CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImage(context),
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
          )
        : CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text('Restaurant'),
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

  bool isAndroidPlatform() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  Hero _buildImage(BuildContext context) {
    var _restaurantData = Provider.of<RestaurantProvider>(context).restaurant;
    return Hero(
      tag: itemId.id,
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
                          color: isAndroidPlatform()
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
                        color: isAndroidPlatform()
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
                            color: isAndroidPlatform()
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
        if (!isAndroidPlatform()) _buildImage(context),
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
                //print(_restaurantData.id);
                // Navigator.pushNamed(context, );
                _showDialog(context);
              },
              icon: Icon(
                isAndroidPlatform() ? Icons.create : CupertinoIcons.add,
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

  Future<void> _showDialog(BuildContext context) {
    var _action = [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Ok"),
      ),
    ];
    var _title = Text('Coming Soon');
    var _content = SingleChildScrollView(
      child: ListBody(
        children: [
          Text('This feature will coming up soon'),
          Text('So stay tune..'),
        ],
      ),
    );
    return isAndroidPlatform()
        ? showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: _title,
          content: _content,
          actions: _action,
        );
      },
    )
        : showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: _title,
          content: _content,
          actions: _action,
        );
      },
    );
  }
}
