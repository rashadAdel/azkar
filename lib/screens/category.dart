import 'package:azkar/bloc/animation/animation_bloc.dart';
import 'package:azkar/bloc/azkar/azkar_bloc.dart';
import 'package:azkar/bloc/thems/ThemeBloc.dart';
import 'package:azkar/model/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../main.dart';

class Category extends StatefulWidget {
  Category({Key key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    super.initState();
    cardsData = <CardData>[
      CardData(
          title: CategoryNames.Evening,
          color: Color(0xffB63399),
          align: Alignment.topLeft,
          angle: .2),
      CardData(
          title: CategoryNames.Morning,
          color: Color(0xffFF7CE2),
          angle: .3,
          align: Alignment.topRight),
      CardData(
          title: CategoryNames.Pray,
          color: Color(0xffF2C94C),
          angle: -.3,
          align: Alignment.centerLeft),
      CardData(
          title: CategoryNames.Muslim,
          color: Color(0xffEB5757),
          angle: 44.0,
          align: Alignment.centerRight),
      CardData(
          title: CategoryNames.Sleep,
          color: Color(0xff27AE60),
          angle: -.5,
          align: Alignment.bottomLeft),
      CardData(
          title: CategoryNames.Custom,
          color: Color(0xff56CCF2),
          angle: .25,
          align: Alignment.bottomRight),
    ];
  }

  List<CardData> cardsData;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List cards = cardsData
        .map(
          (data) => BlocBuilder<AzkarBloc, AzkarState>(
            builder: (context, state) =>
                BlocBuilder<AnimationBloc, AnimationState>(
                    builder: (context, anim) => GestureDetector(
                          onTap: () {
                            BlocProvider.of<ThemeBloc>(context).add(data.color);
                            BlocProvider.of<AnimationBloc>(context)
                                .add(Clicked(categoryName: data.title));
                          },
                          child: AnimatedOpacity(
                            onEnd: () {
                              BlocProvider.of<AnimationBloc>(context).add(
                                SecondAnimation(anim.categoryName != null),
                              );
                            },
                            duration: Duration(milliseconds: 500),
                            opacity: anim.categoryName == null ||
                                    anim.categoryName == data.title
                                ? 1
                                : 0,
                            child: AnimatedAlign(
                              onEnd: () {
                                if (anim.categoryName == data.title &&
                                    anim.secondAnimation) {
                                  BlocProvider.of<AzkarBloc>(context).add(
                                    OpenCategory(
                                        context: context,
                                        categoryName: data.title),
                                  );
                                }
                              },
                              duration: Duration(milliseconds: 300),
                              alignment: anim.categoryName == null
                                  ? data.align
                                  : anim.secondAnimation
                                      ? Alignment.topCenter
                                      : Alignment.center,
                              child: Transform.rotate(
                                angle: anim.categoryName == data.title
                                    ? 0
                                    : data.angle,
                                child: Card(
                                  elevation: 7,
                                  child: AnimatedContainer(
                                    height: anim.secondAnimation
                                        ? AppBar().preferredSize.height
                                        : size.height / 3,
                                    width: anim.secondAnimation
                                        ? size.width
                                        : size.width / 2,
                                    color: data.color,
                                    child: Center(
                                      child: Text(
                                        "أذكار ${data.title}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 300),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
          ),
        )
        .toList();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: <Widget>[backGround] + cards),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(' الخروج'),
            content: new Text('هل تريد الخروج بالفعل؟'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('لا'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('نعم'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

class CategoryNames {
  static const String Morning = "الصباح";
  static const String Evening = "المساء";
  static const String Muslim = "المسلم";
  static const String Pray = "الصلاة";
  static const String Sleep = "النوم";
  static const String Custom = "مخصصة";
}
