import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../main.dart';
import '../Routes/Router.gr.dart';

class Zekr extends StatelessWidget {
  final String title;

  Zekr({Key key, @required this.title}) : super(key: key);

  bool get canEdit => title == "أذكار مخصصه";
  Size size;
  SwiperController controller;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    controller = SwiperController();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: btn(),
      appBar: appBar(),
      body: Stack(
        children: <Widget>[
          backGround,
          swiper(),
          restBtn(),
          canEdit ? addBtn(context) : Container(),
        ],
      ),
    );
  }

  TweenAnimationBuilder<Offset> swiper() {
    return TweenAnimationBuilder<Offset>(
        duration: Duration(seconds: 1),
        tween: Tween<Offset>(begin: Offset(0, -size.height), end: Offset.zero),
        builder: (BuildContext context, Offset value, Widget child) =>
            Transform.translate(
              offset: value,
              child: Swiper(
                controller: controller,
                itemCount: 10,
                loop: false,
                curve: Curves.fastOutSlowIn,
                scrollDirection: Axis.vertical,
                layout: SwiperLayout.STACK,
                duration: 500,
                itemWidth: size.width * .9,
                pagination: SwiperPagination(),
                itemHeight: size.height / 2.5,
                itemBuilder: (BuildContext context, int index) =>
                    card(index, context),
              ),
            ));
  }

  TweenAnimationBuilder<double> addBtn(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween:Tween<double>(begin: -100,end:16),
      builder: (BuildContext context, double value, Widget child) =>
          Positioned(
            bottom: 15,
            right: value,
            child: FloatingActionButton(
              heroTag: "$title 2",
              child: Icon(Icons.add),
              onPressed: () {
                // showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (_) => AlertDialog(
                //           actions: <Widget>[
                //             FlatButton(
                //               child: Text("ok"),
                //               onPressed: () {
                //                 Navigator.of(context).pop();
                //               },
                //             ),
                //             FlatButton(
                //               child: Text("no"),
                //               onPressed: () {},
                //             ),
                //           ],
                //         ));
              },
            ),
          ),
      duration: Duration(seconds: 1),
    );
  }

  TweenAnimationBuilder restBtn() {
    return TweenAnimationBuilder<double>(
      builder: (BuildContext context, double value, Widget child) => Positioned(
        bottom: 15,
        left: value,
        child: FloatingActionButton(
          heroTag: "$title 3",
          child: Icon(Icons.restore),
          onPressed: () {},
        ),
      ),
      duration: const Duration(seconds: 1),
      tween: Tween<double>(begin: -100, end: 16.0),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(this.title),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: () {
          Router.navigator.pop();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }

  TweenAnimationBuilder<Offset> btn() {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(seconds: 1),
      tween: Tween<Offset>(begin: Offset(0, 100), end: Offset.zero),
      builder: (BuildContext context, Offset value, Widget child) {
        return Transform.translate(
          offset: value,
          child: SizedBox(
            height: size.height / 5,
            width: size.height / 5,
            child: FloatingActionButton(
              splashColor: Colors.red,
              heroTag: title,
              onPressed: () {
                controller.next();
              },
              child: Container(
                  height: 500, width: 500, child: Center(child: Text("1000"))),
            ),
          ),
        );
      },
    );
  }

  Card card(int index, BuildContext context) {
    String txt =
        List.generate(43, (g) => "${List.generate(20, (g) => "$g").join()} \n")
            .toList()
            .join(); //Todo: replace with real text
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 7,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Container(
                            constraints: BoxConstraints(
                              maxHeight: size.height / 2,
                            ),
                            child: SingleChildScrollView(
                              child: Center(child: Text(txt)),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      txt,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                        child: Icon(Icons.share, color: Colors.white),
                        onPressed: () {}),
                  ),
                  canEdit
                      ? Expanded(
                          child: FlatButton(
                              child: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {}),
                        )
                      : Container(),
                  canEdit
                      ? Expanded(
                          child: FlatButton(
                              child: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {}),
                        )
                      : Container(),
                  Expanded(
                    child: FlatButton(
                        child: Icon(Icons.info, color: Colors.white),
                        onPressed: () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: index % 2 == 0
                ? Colors.indigo
                : index % 3 == 0 ? Colors.cyan : Colors.red),
      ),
    );
  }
}
