import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewReview extends StatefulWidget {
  //
  final restaurantId;

  NewReview({this.restaurantId});

  @override
  _NewReviewState createState() => _NewReviewState();
}

class _NewReviewState extends State<NewReview> {
  final appbarTitle = "New Review";

  TextEditingController _nameController;
  TextEditingController _reviewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController()..addListener(_nameListener);
    _reviewController = TextEditingController()..addListener(_reviewListener);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: null,
      iosBuilder: null,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
      ),
      body: _buildBody(context),
    );
  }

  bool isAndroid() => defaultTargetPlatform == TargetPlatform.android;

  Widget _buildBody(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  icon: Icon(isAndroid()
                      ? Icons.person_outline
                      : CupertinoIcons.person),
                  labelText: 'Name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  icon: Icon(isAndroid()
                      ? Icons.person_outline
                      : CupertinoIcons.person),
                  labelText: 'Name'),
            ),
          ),
        ],
      ),
    );
  }

  void _nameListener() {}

  void _reviewListener() {}
}
