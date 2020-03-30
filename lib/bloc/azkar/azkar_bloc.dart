import 'dart:async';
import 'package:azkar/Routes/Router.gr.dart';
import 'package:azkar/bloc/animation/animation_bloc.dart';
import 'package:azkar/model/zekr.dart';
import 'package:azkar/screens/category.dart';
import 'package:azkar/screens/edit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'azkar_event.dart';
part 'azkar_state.dart';

class AzkarBloc extends Bloc<AzkarEvent, AzkarState> {
  @override
  AzkarState get initialState => AzkarState(list: [], pos: 0);

  String queryWhere = "1";

  @override
  Stream<AzkarState> mapEventToState(
    AzkarEvent event,
  ) async* {
    //Edit Or Add in Favorate
    if (event is AddOrUpdate) {
      ZekrModel zekr = await showDialog(
        context: event.context,
        barrierDismissible: false,
        child: EditDialog(
          zekrModel: event.zekr,
        ),
      );
      //That's if open Favorate For First Time and it insert
      if (zekr != null &&
          event.context.widget.toString().contains("Animation")) {
        add(
          OpenCategory(
              context: event.context, categoryName: CategoryNames.Favorite),
        );
      }
    } else if (event is ChangePosition) {
      state.pos = event.pos;
    } else if (event is OpenCategory) {
      state.title = "أذكار ${event.categoryName}";
      queryWhere = event.categoryName == CategoryNames.Favorite
          ? "`isFavorite`>0"
          : "`category`='${event.categoryName}'";

      //Fetsh Data
      List<ZekrModel> lst = await ZekrModel.fromDataBase(where: queryWhere);

      //if it Favorate and empty
      if (lst.isEmpty && event.categoryName == CategoryNames.Favorite) {
        BlocProvider.of<AnimationBloc>(event.context).add(Clicked());
        add(AddOrUpdate(context: event.context));
      } else {
        yield AzkarState(list: lst, title: state.title);
        Router.navigator.pushNamed(event.categoryName == CategoryNames.Search
            ? Router.search
            : Router.zekr);
      }
    } else if (event is Search) {
      state.title = "نتائج البحث";
      queryWhere = event.where;
    } else if (event is Increment) {
      await state.currentZekr.increment();
    } else if (event is Reset) {
      await state.currentZekr.reset();
    } else if (event is Delete) {
      if (state.currentZekr.category == CategoryNames.Favorite) {
        await state.currentZekr.delete();
      } else {
        await state.currentZekr.convertFavorate();
      }
//if it the last card
      if (state.list.length == 1) {
        Router.navigator.pop();
      }
//if it the last index
      else if (state.pos == state.list.length - 1) {
        --state.pos;
      }
    }
    List<ZekrModel> lst = await ZekrModel.fromDataBase(where: queryWhere);

    if (lst != null && lst.isNotEmpty) {
      yield AzkarState(list: lst, pos: state.pos, title: state.title);
    } else {
      yield AzkarState(
          list: [ZekrModel(name: "لا توجد نتائج", about: "")],
          title: "لا توجد نتائج");
    }
  }
}
