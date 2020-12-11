import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  final titleAppBar = "Invalid Page";
  final message = "Error Page, please go back to previous page.";

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
      navigationBar: CupertinoNavigationBar(
        middle: Text(titleAppBar),
      ),
      child: _buildMessage(),
    );
  }

  Scaffold _buildAndroid() {
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
