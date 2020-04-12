import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:azkar/Database/abstract.dart';
import '../bloc/animation/animation_bloc.dart';
import '../bloc/azkar/azkar_bloc.dart';
import '../models/info.dart';
import 'category.dart';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../main.dart';
import '../Routes/Router.gr.dart';

class ZekrPage extends StatefulWidget {
  ZekrPage({Key key}) : super(key: key);
  static GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  @override
  _ZekrPageState createState() => _ZekrPageState();
}

class _ZekrPageState extends State<ZekrPage> with TickerProviderStateMixin {
  final SwiperController _controller = SwiperController();
  AnimationController _rotationController;
  final ScrollController _scrolText = ScrollController();

  @override
  void initState() {
    _rotationController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        upperBound: pi * 2);
    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scrolText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AnimationBloc>(context).add(Clicked());
    return BlocBuilder<AzkarBloc, AzkarState>(
      builder: (context, state) {
        if ((state.list.isEmpty)) {
          return Scaffold(body: backGround);
        } else {
          return Scaffold(
            key: ZekrPage.globalKey,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: btn(),
            appBar: appBar(),
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                backGround,
                swiper(),
                restBtn(),
                state.title == "أذكار مفضلة" ? addBtn() : Container(),
              ],
            ),
          );
        }
      },
    );
  }

  TweenAnimationBuilder<Offset> swiper() {
    Size size = MediaQuery.of(context).size;
    return TweenAnimationBuilder<Offset>(
      duration: Duration(milliseconds: 600),
      curve: Curves.elasticInOut,
      tween: Tween<Offset>(begin: Offset(0, -size.height), end: Offset.zero),
      builder: (BuildContext context, Offset value, Widget child) =>
          Transform.translate(
        offset: value,
        child: child,
      ),
      child: (BlocProvider.of<AzkarBloc>(context).state.list.length < 2)
          ? SizedBox(
              width: size.width * .9,
              height: size.height / 2.5,
              child: card(0),
            )
          : Swiper(
              onIndexChanged: (index) {
                BlocProvider.of<AzkarBloc>(context).add(ChangePosition(index));
              },
              index: BlocProvider.of<AzkarBloc>(context).state.pos,
              controller: _controller,
              itemCount: BlocProvider.of<AzkarBloc>(context).state.list.length,
              loop: false,
              control: SwiperPagination(),
              curve: Curves.fastOutSlowIn,
              scrollDirection: Axis.vertical,
              layout: SwiperLayout.STACK,
              duration: 500,
              pagination: FractionPaginationBuilder(),
              itemWidth: size.width * .9,
              itemHeight: size.height / 2.5,
              itemBuilder: (BuildContext context, int index) => card(index),
            ),
    );
  }

  TweenAnimationBuilder<double> addBtn() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: -16, end: 16),
      builder: (BuildContext context, double value, Widget child) =>
          Positioned(bottom: 15, right: value, child: child),
      child: FloatingActionButton(
        splashColor: Colors.red,
        heroTag: "addBtn",
        child: Icon(Icons.add),
        onPressed: () {
          BlocProvider.of<AzkarBloc>(context)
              .add(AddOrUpdate(context: context));
        },
      ),
      duration: Duration(milliseconds: 700),
    );
  }

  TweenAnimationBuilder restBtn() {
    return TweenAnimationBuilder<double>(
      builder: (BuildContext context, double value, Widget child) => Positioned(
        bottom: 15,
        left: value,
        child: child,
      ),
      duration: const Duration(milliseconds: 700),
      tween: Tween<double>(begin: -16, end: 16.0),
      child: BlocBuilder<AnimationBloc, AnimationState>(
        builder: (context, state) {
          return RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_rotationController),
            child: FloatingActionButton(
              splashColor: Colors.red,
              heroTag: "restBtn",
              child: Icon(Icons.restore),
              onPressed: () {
                SharedPreferences.getInstance().then(
                  (_shared) {
                    if (_shared.getBool("sound") ?? true)
                      try {
                        AudioCache().play("sounds/delete.mp3");
                      } catch (e) {}
                  },
                );
                _rotationController.forward(from: 0.0);

                BlocProvider.of<AzkarBloc>(context).add(
                  Reset(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget btn() {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(milliseconds: 700),
      tween: Tween<Offset>(begin: Offset(0, 100), end: Offset.zero),
      builder: (BuildContext context, Offset value, Widget child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: BlocBuilder<AzkarBloc, AzkarState>(
        builder: (context, state) => SizedBox(
          width: MediaQuery.of(context).size.height / 5,
          height: MediaQuery.of(context).size.height / 5,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            splashColor: Colors.red,
            heroTag: "btn",
            onPressed: () {
              //return scroll
              _scrolText.jumpTo(0);

              //check if sound enable to play sound
              SharedPreferences.getInstance().then(
                (shared) {
                  if (shared.getBool("sound") ?? true)
                    try {
                      AudioCache().play("sounds/clicked.mp3");
                    } catch (e) {}
                },
              );

              //call Bloc increment
              BlocProvider.of<AzkarBloc>(context).add(Increment());

              // if the last counter
              if (state.currentZekr.counter < 2 &&
                  state.currentZekr.target != 0) {
                //if sound enable play
                SharedPreferences.getInstance().then(
                  (_shared) {
                    if (_shared.getBool("vibration") ?? true)
                      Vibration.vibrate();
                  },
                );

                BlocProvider.of<AzkarBloc>(context).add(Reset());

                _controller.next();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    ("${state?.currentZekr?.counter}"),
                    style: TextStyle(fontSize: 45),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() => AppBar(
        title: Text("${BlocProvider.of<AzkarBloc>(context).state.title}"),
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
            onPressed: () {
              showDialog(
                context: context,
                child: Settings(),
                barrierDismissible: false,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Router.navigator.pushNamed(Router.search);
            },
          ),
        ],
      );

  Card card(int index) {
    return Card(
      color: index % 2 == 0
          ? Colors.indigo
          : index % 3 == 0 ? Colors.cyan : Colors.purple,
      elevation: 10,
      child: BlocBuilder<AzkarBloc, AzkarState>(builder: (context, state) {
        Zekr model = state.list[index];
        return Column(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  showCustomDialog(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Text(
                          model.name,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
                child: SingleChildScrollView(
                  controller: _scrolText,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    model.name,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      Share.share(
                          "${state.currentZekr.name} \n\n\n ${state.currentZekr.about} \n\n ${AppInfo.downloadLink}");
                    },
                  ),
                ),
                BlocProvider.of<AzkarBloc>(context)
                            .state
                            .currentZekr
                            .category ==
                        CategoryNames.Favorite
                    ? Expanded(
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            BlocProvider.of<AzkarBloc>(context).add(
                              AddOrUpdate(zekr: model, context: context),
                            );
                          },
                        ),
                      )
                    : Container(),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                        model.category == CategoryNames.Favorite
                            ? Icons.delete
                            : model.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                        color: Colors.red),
                    onPressed: () async {
                      bool delete = (model.isFavorite)
                          ? await showCustomDialog(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "هل تريد الحذف من المفضلة؟",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FloatingActionButton(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        onPressed: () =>
                                            Router.navigator.pop(false),
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                            shadows: [
                                              Shadow(
                                                blurRadius: 2,
                                                offset: Offset(-1, -1),
                                              )
                                            ],
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FloatingActionButton(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        onPressed: () =>
                                            Router.navigator.pop(true),
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                            shadows: [
                                              Shadow(
                                                blurRadius: 2,
                                                offset: Offset(-1, -1),
                                              )
                                            ],
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : true;

                      if (delete != null && delete) {
                        BlocProvider.of<AzkarBloc>(context).add(Delete());
                        if (model.category == CategoryNames.Favorite)
                          _controller.previous();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                      icon: Icon(Icons.info, color: Colors.white),
                      onPressed: () {
                        showCustomDialog(
                          child: Text(
                            state.currentZekr.about,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Future showCustomDialog({Widget child}) {
    return showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white, width: 3),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
