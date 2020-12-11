import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

var _width = 0.0;

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final isAndroid =
      defaultTargetPlatform == TargetPlatform.android ? true : false;

  @override
  void initState() {
    super.initState();
    _startTime();
  }

  _startTime() {
    var duration = new Duration(seconds: 5);
    Future.delayed(duration, () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var useMobileLayout = mediaQuery.size.shortestSide;
    _width = mediaQuery.size.width * 2 / 3;

    if (useMobileLayout < 600) {
      if (mediaQuery.orientation == Orientation.portrait) {
        _width = mediaQuery.size.width * 2 / 3;
        return _potraitView();
      } else {
        _width = mediaQuery.size.height * 3 / 5;
        return _landscapeView();
      }
    }
    return _potraitView();
  }

  Widget _potraitView() {
    return isAndroid
        ? Scaffold(
            body: _bodyPotrait(),
          )
        : CupertinoPageScaffold(
            child: _bodyPotrait(),
          );
  }

  Container _bodyPotrait() {
    return Container(
      decoration: _boxDecoration(),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageIcon(),
            SizedBox(height: 30),
            _nameApp(),
          ],
        ),
      ),
    );
  }

  Widget _landscapeView() {
    return isAndroid
        ? Scaffold(
            body: _bodyLanscape(),
          )
        : CupertinoPageScaffold(
            child: _bodyLanscape(),
          );
  }

  Container _bodyLanscape() {
    return Container(
      decoration: _boxDecoration(),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _imageIcon(),
            _nameApp(),
          ],
        ),
      ),
    );
  }

  Image _imageIcon() {
    return Image.asset("images/food-store.png",
        width: _width * 3 / 4, fit: BoxFit.contain);
  }

  Text _nameApp() {
    return Text('Restaurant List App',
        style: TextStyle(
          color: colorPrimary,
          fontSize: 36,
          fontWeight: FontWeight.w500,
        ),
        softWrap: true,
        textAlign: TextAlign.center);
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          colorAccentLight,
          colorAccent,
        ],
      ),
    );
  }
}
