import 'dart:async';
import '../../Database/abstract.dart';
import '../../Routes/Router.gr.dart';
import '../animation/animation_bloc.dart';
import '../../screens/category.dart';
import '../../screens/edit.dart';
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
      Zekr zekr = await showDialog(
        context: event.context,
        barrierDismissible: false,
        child: EditDialog(
          zekr: event.zekr,
        ),
      );
      //That's if open Favorate For First Time and it insert
      if (zekr != null &&
          //if from Category screen
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
      List<Zekr> lst = await Repos.zekr.query(where: queryWhere);

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
      state.title = null;
      queryWhere = event.where;
    } else if (event is Increment) {
      state.list[state.pos] = await Repos.zekr.update(Zekr(
          id: state.currentZekr.id, actually: state.currentZekr.actually + 1));
    } else if (event is Reset) {
      state.list[state.pos] = await Repos.zekr
          .update(Zekr(actually: 0, id: state.list[state.pos].id));
    } else if (event is Delete) {
      int id = state.currentZekr.id;
      if (state.currentZekr.category == CategoryNames.Favorite) {
        //if it the last card
        if (state.list.length == 1) {
          Router.navigator.pop();
          await Repos.zekr.delete(model: Zekr(id: id));
          return;
        }

        //if it the last index
        if (state.pos == state.list.length - 1) {
          --state.pos;
        }
      } else {
        state.list[state.pos] = await Repos.zekr.update(
          Zekr(id: id, isFavorite: !state.currentZekr.isFavorite),
        );
      }
    }
    List<Zekr> lst = await Repos.zekr.query(where: queryWhere);

    if (lst != null && lst.isNotEmpty) {
      yield AzkarState(list: lst, pos: state.pos, title: state.title);
    } else {
      yield AzkarState(
          list: [Zekr(name: "لا توجد نتائج", about: "")],
          title: "لا توجد نتائج");
    }
  }
}
