import 'package:azkar/bloc/animation/animation_bloc.dart';
import 'package:azkar/bloc/azkar/azkar_bloc.dart';
import 'package:azkar/screens/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:share/share.dart';
// import 'package:vibration/vibration.dart';
import '../main.dart';
import '../Routes/Router.gr.dart';

class Zekr extends StatelessWidget {
  Zekr({Key key}) : super(key: key);
  final SwiperController controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AnimationBloc>(context).add(Clicked());
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<AzkarBloc, AzkarState>(
      builder: (context, state) => Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: btn(context, size),
          appBar: appBar(context),
          body: Stack(
            children: <Widget>[
              backGround,
              swiper(size, context),
              restBtn(context),
              state.currentZekr.category == CategoryNames.Custom
                  ? addBtn(context)
                  : Container(),
            ],
          )),
    );
  }

  TweenAnimationBuilder<Offset> swiper(Size size, BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      duration: Duration(milliseconds: 600),
      curve: Curves.elasticInOut,
      tween: Tween<Offset>(begin: Offset(0, -size.height), end: Offset.zero),
      builder: (BuildContext context, Offset value, Widget child) =>
          Transform.translate(
        offset: value,
        child: child,
      ),
      child: Swiper(
        onIndexChanged: (index) {
          BlocProvider.of<AzkarBloc>(context).add(ChangePosition(index));
        },
        controller: controller,
        itemCount: BlocProvider.of<AzkarBloc>(context).state.list.length,
        loop: false,
        control: SwiperPagination(),
        curve: Curves.fastOutSlowIn,
        scrollDirection: Axis.vertical,
        layout: SwiperLayout.STACK,
        duration: 500,
        itemWidth: size.width * .9,
        pagination: FractionPaginationBuilder(),
        itemHeight: size.height / 2.5,
        itemBuilder: (BuildContext context, int index) =>
            card(index, context, size),
      ),
    );
  }

  TweenAnimationBuilder<double> addBtn(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: -16, end: 16),
      builder: (BuildContext context, double value, Widget child) =>
          Positioned(bottom: 15, right: value, child: child),
      child: FloatingActionButton(
        splashColor: Colors.red,
        heroTag:
            "${BlocProvider.of<AzkarBloc>(context).state.currentZekr.category} 2",
        child: Icon(Icons.add),
        onPressed: () {
          BlocProvider.of<AzkarBloc>(context)
              .add(AddOrUpdate(context: context));
        },
      ),
      duration: Duration(milliseconds: 700),
    );
  }

  TweenAnimationBuilder restBtn(BuildContext context) {
    return TweenAnimationBuilder<double>(
      builder: (BuildContext context, double value, Widget child) => Positioned(
        bottom: 15,
        left: value,
        child: child,
      ),
      duration: const Duration(milliseconds: 700),
      tween: Tween<double>(begin: -16, end: 16.0),
      child: FloatingActionButton(
        splashColor: Colors.red,
        heroTag:
            "${BlocProvider.of<AzkarBloc>(context).state.currentZekr.category} 3",
        child: Icon(Icons.restore),
        onPressed: () {
          //Todo:Make sound
          //Todo:Make Animation Round
          BlocProvider.of<AzkarBloc>(context).add(Reset());
        },
      ),
    );
  }

  TweenAnimationBuilder<Offset> btn(BuildContext context, Size size) {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(milliseconds: 700),
      tween: Tween<Offset>(begin: Offset(0, 100), end: Offset.zero),
      builder: (BuildContext context, Offset value, Widget child) =>
          Transform.translate(
        offset: value,
        child: child,
      ),
      child: BlocBuilder<AzkarBloc, AzkarState>(
        builder: (context, state) => SizedBox(
          width: size.height / 5,
          height: size.height / 5,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            splashColor: Colors.red,
            heroTag:
                BlocProvider.of<AzkarBloc>(context).state.currentZekr.category,
            onPressed: () async {
              BlocProvider.of<AzkarBloc>(context).add(Increment());
              if (state.currentZekr.counter < 2 &&
                  state.currentZekr.target != 0) {
                BlocProvider.of<AzkarBloc>(context).add(Reset());
                controller.next();
                // Vibration.vibrate(duration: 500);
                //Todo: make vibration
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
                    ("${state.currentZekr.counter}"),
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

  AppBar appBar(BuildContext context) => AppBar(
        title: Text(
            "أذكار ${BlocProvider.of<AzkarBloc>(context).state.currentZekr.category}"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Router.navigator.pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings), //Todo:Settings screen
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search), //Todo:search
            onPressed: () {},
          ),
        ],
      );

  Card card(int index, BuildContext context, Size size) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 7,
      child: BlocBuilder<AzkarBloc, AzkarState>(
          builder: (context, state) => Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side:
                                      BorderSide(color: Colors.white, width: 3),
                                ),
                                content: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: size.height / 2,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Center(
                                      child: Text(
                                        state.currentZekr.name,
                                        textAlign: TextAlign.center,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                state.list[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
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
                                onPressed: () {
                                  Share.share(state.currentZekr.name);
                                }), //Todo:share
                          ),
                          BlocProvider.of<AzkarBloc>(context)
                                      .state
                                      .currentZekr
                                      .category ==
                                  CategoryNames.Custom
                              ? Expanded(
                                  child: FlatButton(
                                    child:
                                        Icon(Icons.edit, color: Colors.white),
                                    onPressed: () {
                                      BlocProvider.of<AzkarBloc>(context).add(
                                        AddOrUpdate(
                                            zekr: state.currentZekr,
                                            context: context),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          BlocProvider.of<AzkarBloc>(context)
                                      .state
                                      .currentZekr
                                      .category ==
                                  CategoryNames.Custom
                              ? Expanded(
                                  child: FlatButton(
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                    onPressed: () async {
                                      bool delete = await showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide(
                                                color: Colors.white, width: 3),
                                          ),
                                          title: Text(
                                            "هل تريد الحذف؟",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              FloatingActionButton(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
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
                                                    Theme.of(context)
                                                        .primaryColor,
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
                                        ),
                                      );
                                      if (delete != null && delete) {
                                        BlocProvider.of<AzkarBloc>(context)
                                            .add(Delete());
                                        controller.previous();
                                      }
                                    },
                                  ),
                                )
                              : Container(),
                          Expanded(
                            child: FlatButton(
                                child: Icon(Icons.info, color: Colors.white),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: Colors.white, width: 3),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            state.currentZekr.about,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
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
              )),
    );
  }
}
