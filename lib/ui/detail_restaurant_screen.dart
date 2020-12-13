import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/data/service/api_config.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailRestaurant extends StatefulWidget {
  static const routeName = '/detail_restaurant';
  final Restaurant itemId;

  DetailRestaurant({Key key, this.itemId}) : super(key: key);

  @override
  _DetailRestaurantState createState() => _DetailRestaurantState();
}

class _DetailRestaurantState extends State<DetailRestaurant> {
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<RestaurantDetail> _restaurantDetail;
  Restaurant _restaurantData;

  @override
  void initState() {
    _restaurantDetail = ApiConfig().getDetailRestaurant(widget.itemId.id);
    _restaurantDetail.then((data) {
      setState(() {
        _restaurantData = data.restaurant;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _futureBuilder() {
    return FutureBuilder(
      future: _restaurantDetail,
      builder: (context, AsyncSnapshot<RestaurantDetail> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var restaurantData = snapshot.data;
        if (!restaurantData.error) {
          return _mainBody();
        } else {
          return Center(child: Text("No Restaurant that you want"));
        }
      },
    );
  }

  CupertinoPageScaffold _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text('Restaurant'),
            ),
            _restaurantData == null
                ? SliverFillRemaining(
              hasScrollBody: false,
              child: _futureBuilder(),
            )
                : SliverList(
              delegate: SliverChildListDelegate([_futureBuilder()]),
            ),
            _setTitleItemSliver(),
            _listReviewSliver(),
          ],
        ),
      ),
    );
  }

  Scaffold _buildAndroid(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
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
            _restaurantData == null
                ? SliverFillRemaining(
              hasScrollBody: false,
              child: _futureBuilder(),
            )
                : SliverList(
              delegate: SliverChildListDelegate([_futureBuilder()]),
            ),
            _setTitleItemSliver(),
            _listReviewSliver(),
          ],
        ),
      ),
    );
  }

  Hero _buildImage() {
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

  Widget _body() {
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
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline5
                          .apply(fontWeightDelta: 2),
                      softWrap: true,
                    ), fit: FlexFit.loose,
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
                        _restaurantData.rating.toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6,
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
              _setTitleItem("Description"),
              SizedBox(height: 6),
              Text(
                _restaurantData.description,
                style: Theme
                    .of(context)
                    .textTheme
                    .caption
                    .apply(fontSizeDelta: 3),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        if (_restaurantData.menus.foods.length > 0)
          _setMenu(_restaurantData.menus.foods, "Food Menus")
        else
          _setTitleItem("No Food Menus"),
        SizedBox(height: 20),
        if (_restaurantData.menus.drinks.length > 0)
          _setMenu(_restaurantData.menus.drinks, "Drink Menus")
        else
          _setTitleItem("No Drink Menus"),
        SizedBox(height: 20),
      ],
    );
  }

  Text _setTitleItem(String title) {
    return Text(
      title,
      style: Theme
          .of(context)
          .textTheme
          .button
          .apply(fontSizeDelta: 5, color: Colors.grey[400]),
    );
  }

  Widget _setMenu(List<TypeMenu> listItemMenu, String title) {
    final sizePadding = 14.0;
    final sizeFont = 14.0;
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

  Widget _mainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (defaultTargetPlatform == TargetPlatform.iOS) _buildImage(),
        _body(),
      ],);
  }

  Widget _listReviewSliver() {
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
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText2,
                              children: <TextSpan>[
                                TextSpan(text: _restaurantData
                                    .customerReviews[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),

                          SizedBox(height: 2),
                          Text(_restaurantData.customerReviews[index].date,
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,),
                          SizedBox(height: 6),
                          Text(_restaurantData.customerReviews[index].review,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,),

                        ],
                      ),
                    ),
                  ),
                ),
            childCount: _restaurantData.customerReviews.length),
      ), padding: EdgeInsets.only(bottom: 20),
    );
  }

  Widget _setTitleItemSliver() {
    return _restaurantData?.customerReviews == null
        ? SliverFillRemaining()
        : SliverPadding(
      sliver: SliverToBoxAdapter(child: _setTitleItem("Customer Review"),),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),);
  }
}
