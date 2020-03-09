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
        Positioned(
          //Logo
          top: 50,
          left: 0,
          right: 0,
          child: Image.asset(
            "assets/icons/logo.jpeg",
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          //CirculeProgress
          bottom: 30,
          child: CircularProgressIndicator(),
        ),
        TweenAnimationBuilder<Alignment>(
          //AnimatedText
          curve: Curves.elasticOut,
          builder: (BuildContext context, Alignment value, Widget child) {
            return Align(
              alignment: value,
              child: Text(
                "أذكار",
                style: TextStyle(
                    fontFamily: "Mj",
                    fontSize: 50,
                    fontWeight: FontWeight.w900),
              ),
            );
          },
          onEnd: () {
            Router.navigator.pushNamedAndRemoveUntil(
              Router.category,
              (_) => false,
            );
          },
          duration: Duration(seconds: 3),
          tween: AlignmentTween(
              begin: Alignment.bottomCenter, end: Alignment.center),
        )
      ],
    ));
  }
}
