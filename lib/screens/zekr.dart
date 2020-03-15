import 'package:azkar/model/zekr.dart';
import 'package:azkar/screens/category.dart';
import 'package:azkar/screens/edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../main.dart';
import '../Routes/Router.gr.dart';

class Zekr extends StatelessWidget {
  final String title;

  Zekr({Key key, @required this.title}) : super(key: key);

  final SwiperController controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: btn(size),
      appBar: appBar(),
      body: Stack(
        children: <Widget>[
          backGround,
          swiper(size),
          restBtn(),
          title == CategoryNames.Custom ? addBtn(context) : Container(),
        ],
      ),
    );
  }

  TweenAnimationBuilder<Offset> swiper(Size size) {
    return TweenAnimationBuilder<Offset>(
      duration: Duration(seconds: 1),
      curve: Curves.elasticInOut,
      tween: Tween<Offset>(begin: Offset(0, -size.height), end: Offset.zero),
      builder: (BuildContext context, Offset value, Widget child) =>
          Transform.translate(
        offset: value,
        child: child,
      ),
      child: Swiper(
        //Todo: onIndexChanged: bloc add ,
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
            card(index, context, size),
      ),
    );
  }

  TweenAnimationBuilder<double> addBtn(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: -100, end: 16),
      builder: (BuildContext context, double value, Widget child) =>
          Positioned(bottom: 15, right: value, child: child),
      child: FloatingActionButton(
        heroTag: "$title 2",
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            barrierDismissible: true,
            context: context,
            child: EditDialog(
              zekrModel: ZekrModel(),
            ),
          );
        },
      ),
      duration: Duration(seconds: 1),
    );
  }

  TweenAnimationBuilder restBtn() {
    return TweenAnimationBuilder<double>(
      builder: (BuildContext context, double value, Widget child) => Positioned(
        bottom: 15,
        left: value,
        child: child,
      ),
      duration: const Duration(seconds: 1),
      tween: Tween<double>(begin: -100, end: 16.0),
      child: FloatingActionButton(
        heroTag: "$title 3",
        child: Icon(Icons.restore),
        onPressed: () {},
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text("أذكار ${this.title}"),
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

  TweenAnimationBuilder<Offset> btn(Size size) {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(seconds: 1),
      tween: Tween<Offset>(begin: Offset(0, 100), end: Offset.zero),
      builder: (BuildContext context, Offset value, Widget child) =>
          Transform.translate(
        offset: value,
        child: child,
      ),
      child: SizedBox(
        width: size.height / 5,
        height: size.height / 5,
        child: FloatingActionButton(
          splashColor: Colors.red,
          heroTag: title,
          onPressed: () {
            controller.move(4); //Todo:next after target
          },
          child: Center(
            child: Text("1000"),
          ),
        ),
      ),
    );
  }

  Card card(int index, BuildContext context, Size size) {
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
                  title == CategoryNames.Custom
                      ? Expanded(
                          child: FlatButton(
                              child: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    child: EditDialog(
                                        //Todo:pass ZekrModel
                                        ));
                              }),
                        )
                      : Container(),
                  title == CategoryNames.Custom
                      ? Expanded(
                          child: FlatButton(
                              child: Icon(Icons.delete, color: Colors.white),
                              onPressed: () async {
                                bool delete = await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () =>
                                            Router.navigator.pop(true),
                                        child: Text("نعم"),
                                      ),
                                      FlatButton(
                                        onPressed: () =>
                                            Router.navigator.pop(false),
                                        child: Text("لا"),
                                      ),
                                    ],
                                  ),
                                );
                                //Todo: Confirm delete
                              }),
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
