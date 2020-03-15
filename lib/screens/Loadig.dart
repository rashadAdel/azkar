import 'package:azkar/Routes/Router.gr.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        backGround,
        TweenAnimationBuilder<double>(
          onEnd: () {
            Router.navigator
                .pushNamedAndRemoveUntil(Router.category, (_) => false);
          },
          duration: Duration(seconds: 1),
          tween: Tween(begin: MediaQuery.of(context).size.height, end: 50),
          curve: Curves.elasticInOut,
          child: Image.asset(
            "assets/icons/icon.png",
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
          builder: (BuildContext context, double value, Widget child) =>
              Positioned(
            right: 0,
            left: 0,
            top: value,
            child: child,
          ),
        ),
        Positioned(
          //CirculeProgress
          bottom: 30,
          child: CircularProgressIndicator(),
        ),
      ],
    ));
  }
}
