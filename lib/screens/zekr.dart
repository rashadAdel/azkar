import 'package:azkar/bloc/animation/animation_bloc.dart';
import 'package:azkar/bloc/azkar/azkar_bloc.dart';
import 'package:azkar/screens/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
      duration: Duration(seconds: 1),
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
      tween: Tween<double>(begin: -100, end: 16),
      builder: (BuildContext context, double value, Widget child) =>
          Positioned(bottom: 15, right: value, child: child),
      child: FloatingActionButton(
        heroTag:
            "${BlocProvider.of<AzkarBloc>(context).state.currentZekr.category} 2",
        child: Icon(Icons.add),
        onPressed: () {
          BlocProvider.of<AzkarBloc>(context)
              .add(AddOrUpdate(context: context));
        },
      ),
      duration: Duration(seconds: 1),
    );
  }

  TweenAnimationBuilder restBtn(BuildContext context) {
    return TweenAnimationBuilder<double>(
      builder: (BuildContext context, double value, Widget child) => Positioned(
        bottom: 15,
        left: value,
        child: child,
      ),
      duration: const Duration(seconds: 1),
      tween: Tween<double>(begin: -100, end: 16.0),
      child: FloatingActionButton(
        heroTag:
            "${BlocProvider.of<AzkarBloc>(context).state.currentZekr.category} 3",
        child: Icon(Icons.restore),
        onPressed: () {
          BlocProvider.of<AzkarBloc>(context).add(Reset());
        },
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

  TweenAnimationBuilder<Offset> btn(BuildContext context, Size size) {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(seconds: 1),
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
            splashColor: Colors.red,
            heroTag:
                BlocProvider.of<AzkarBloc>(context).state.currentZekr.category,
            onPressed: () async {
              BlocProvider.of<AzkarBloc>(context).add(Increment());
              if (state.currentZekr.counter == 1 &&
                  state.currentZekr.target != 0) {
                BlocProvider.of<AzkarBloc>(context).add(Reset());
                controller.next();
              }
            },
            child: Center(
              child: Text(
                ("${state.currentZekr.counter}"),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                                content: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: size.height / 2,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Center(
                                      child: Text(state.currentZekr.name),
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
                                onPressed: () {}), //Todo:share
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
                                          title: Text("هل تريد الحذف؟"),
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
                                      if (delete)
                                        BlocProvider.of<AzkarBloc>(context)
                                            .add(Delete());
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
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(state.currentZekr.about),
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
