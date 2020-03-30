import 'package:flutter/material.dart';

class Tst extends StatefulWidget {
  @override
  _TstState createState() => _TstState();
}

class _TstState extends State<Tst> {
  Widget _myAnimatedWidget = FirstWidget();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                //Enable this for ScaleTransition
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SizeTransition(
                    child: child,
                    sizeFactor: animation,
                  );
                },
                // transitionBuilder: (Widget child, Animation<double> animation) {
                //   return RotationTransition(
                //     child: child,
                //     turns: animation,
                //   );
                // },
                child: _myAnimatedWidget,
              ),
              RaisedButton(
                child: Text('Click here'),
                onPressed: () {
                  setState(() {
                    _myAnimatedWidget =
                        (_myAnimatedWidget.toString() == "FirstWidget")
                            ? SecondWidget()
                            : FirstWidget();
                  });
                },
              )
            ]),
      ),
    );
  }
}

class FirstWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Center(child: Text("This is First Widget")),
      decoration: BoxDecoration(
        color: Colors.orange,
      ),
    );
  }
}

class SecondWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Center(child: Text("This is Second Widget")),
      decoration: BoxDecoration(
        color: Colors.green,
      ),
    );
  }
}
