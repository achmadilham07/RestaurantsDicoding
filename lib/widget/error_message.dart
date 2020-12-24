import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final Function() onClick;

  const ErrorMessage({
    Key key,
    @required this.message,
    @required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(message),
          Builder(
            builder: (_) {
              var _text = Text('Get Post');
              if (isAndroidPlatform()) {
                return RaisedButton(
                  child: _text,
                  onPressed: onClick,
                );
              } else {
                return CupertinoButton(
                  onPressed: onClick,
                  child: _text,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  bool isAndroidPlatform() {
    return defaultTargetPlatform == TargetPlatform.android;
  }
}
