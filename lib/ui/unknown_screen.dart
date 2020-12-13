import 'package:RestaurantsDicoding/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  final titleAppBar = "Invalid Page";
  final message = "Error Page, please go back to previous page.";

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  CupertinoPageScaffold _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(titleAppBar),
      ),
      child: _buildMessage(),
    );
  }

  Scaffold _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleAppBar),
      ),
      body: _buildMessage(),
    );
  }

  Center _buildMessage() {
    return Center(
      child: Text(message),
    );
  }
}
