import 'package:RestaurantsDicoding/provider/preference_provider.dart';
import 'package:RestaurantsDicoding/provider/restaurant_provider.dart';
import 'package:RestaurantsDicoding/utils/result_state.dart';
import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewReview extends StatefulWidget {
  //
  static const routeName = '/new_review';
  final String restaurantId;

  NewReview({this.restaurantId});

  @override
  _NewReviewState createState() => _NewReviewState();
}

class _NewReviewState extends State<NewReview> {
  final appbarTitle = "New Review";
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _reviewController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<RestaurantProvider>(context, listen: false)
        .setState(ResultState.NoData);
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
          onPressed: _actionButton,
          child: Icon(CupertinoIcons.arrow_right_circle),
        ),
      ),
      child: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _formName()),
          SliverToBoxAdapter(child: _formReview()),
          SliverFillRemaining(child: _output()),
        ],
      )),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
        actions: [
          IconButton(
            onPressed: _actionButton,
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  bool _isAndroid() =>
      Provider.of<PreferencesProvider>(context, listen: false).isAndroidActive;

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _formName(),
          _formReview(),
          Expanded(child: _output()),
        ],
      ),
    );
  }

  Widget _output() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case ResultState.Loading:
              return Center(child: CircularProgressIndicator());
            case ResultState.Error:
              return Center(child: Text(provider.message));
            case ResultState.NoData:
              return Center(child: Text(provider.message));
            case ResultState.HasData:
              _nameController.clear();
              _reviewController.clear();
              print(provider.reviewResponse);
              var list =
                  provider.reviewResponse.customerReviews.reversed.toList();
              return ListView.separated(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                    child: ListTile(
                      onTap: () {},
                      title: Text(list[index].name),
                      subtitle: Text(list[index].review),
                      trailing: Text(list[index].date),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              );
            default:
              return Center(child: Text("no data"));
          }
        },
      ),
    );
  }

  Padding _formReview() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: _isAndroid()
          ? TextFormField(
              controller: _reviewController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Input Review';
                }
                return null;
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.mail_outline), labelText: 'New Review'),
            )
          : CupertinoTextField(
              controller: _reviewController,
              placeholder: 'New Review',
              prefix: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.mail),
              ),
            ),
    );
  }

  Padding _formName() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: _isAndroid()
          ? TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Input Name';
                }
                return null;
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.person_outline), labelText: 'Name'),
            )
          : CupertinoTextField(
              controller: _nameController,
              placeholder: 'Name',
              prefix: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.person),
              ),
            ),
    );
  }

  void _actionButton() {
    final name = _nameController.text;
    final review = _reviewController.text;

    print(name);
    print(review);
    if (_isAndroid()) {
      if (_formKey.currentState.validate()) {
        print(name);
        print(review);
        if (name.isNotEmpty && review.isNotEmpty) {
          Provider.of<RestaurantProvider>(context, listen: false)
              .fetchNewReview(widget.restaurantId, name, review);
        } else {
          print("empty");
        }
      } else {
        print("Not Validated");
      }
    } else {
      if (name.isEmpty || review.isEmpty) {
        showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Error"),
              content: Text("Form still empty, please fill the blank"),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
      } else {
        print(name);
        print(review);
        Provider.of<RestaurantProvider>(context, listen: false)
            .fetchNewReview(widget.restaurantId, name, review);
      }
    }
  }
}
