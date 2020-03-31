import 'package:azkar/Routes/Router.gr.dart';
import 'package:flutter/material.dart';

void main() => runApp(Tst());

class Tst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
            child: Stack(
          children: <Widget>[
            InkWell(
              onTap: Router.navigator.pop(),
              child: CircleAvatar(
                child: Text("R"),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 15,
                height: 15,
                decoration:
                    BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ),
            )
          ],
        )),
      ),
    );
  }
}
