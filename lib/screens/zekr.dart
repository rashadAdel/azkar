import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../main.dart';
import '../Routes/Router.gr.dart';

class Zekr extends StatelessWidget {
  final String title;

  Zekr({Key key, @required this.title}) : super(key: key);

  bool canEdit;
  @override
  Widget build(BuildContext context) {
    canEdit = title == "أذكار مخصصه";
    Size size = MediaQuery.of(context).size;
    var controller = SwiperController();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: size.height / 4,
        width: size.height / 4,
        child: FloatingActionButton(
          heroTag: title,
          onPressed: () {
            controller.next();
          },
          child: Container(
              height: 500, width: 500, child: Center(child: Text("1000"))),
        ),
      ),
      appBar: AppBar(
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
      ),
      body: Stack(
        children: <Widget>[
          backGround,
          Swiper(
            controller: controller,
            itemCount: 10,
            loop: false,
            scrollDirection: Axis.vertical,
            layout: SwiperLayout.STACK,
            duration: 100,
            itemWidth: size.width * .9,
            pagination: SwiperPagination(),
            itemHeight: size.height / 2.5,
            itemBuilder: (BuildContext context, int index) => card(index),
          ),
          Positioned(
            bottom: 15,
            left: 16,
            child: FloatingActionButton(
              heroTag: "$title 3",
              child: Icon(Icons.restore),
              onPressed: () {},
            ),
          ),
          canEdit
              ? Positioned(
                  bottom: 15,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: "$title 2",
                    child: Icon(Icons.add),
                    onPressed: () {},
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Card card(int index) {
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
              SingleChildScrollView(
                  child: Text(List.generate(3, (g)=>"$g \n").toList().join(), style: TextStyle(color: Colors.white))),
              Spacer(),
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
