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

  @override
  Stream<AzkarState> mapEventToState(
    AzkarEvent event,
  ) async* {
    if (event is AddOrUpdate) {
      ZekrModel zekr = await showDialog(
        context: event.context,
        barrierDismissible: false,
        child: EditDialog(
          zekrModel: event.zekr,
        ),
      );
      //That's if open Custom For First Time and it insert
      if (event.context.widget.toString().contains("Animation") &&
          zekr != null) {
        add(
          OpenCategory(
              context: event.context, categoryName: CategoryNames.Custom),
        );
      }
    } else if (event is ChangePosition) {
      state.pos = event.pos;
    } else if (event is OpenCategory) {
      List<ZekrModel> lst = await ZekrModel.fromDataBase(
          where: "`category`='${event.categoryName}'");
      yield AzkarState(list: lst, pos: 0);
      if (lst.isEmpty && event.categoryName == CategoryNames.Custom) {
        BlocProvider.of<AnimationBloc>(event.context).add(Clicked());
        add(AddOrUpdate(context: event.context));
      } else {
        Router.navigator.pushNamed(Router.zekr);
      }
    } else if (event is Increment) {
      state.currentZekr.increment();
    } else if (event is Reset) {
      await state.currentZekr.reset();
    } else if (event is Delete) {
      await state.currentZekr.delete();
//if it the last card
      if (state.list.length == 1) {
        Router.navigator.pop();
      }
//if it the last index
      if (state.pos == state.list.length - 1) {
        --state.pos;
      }
    }
    List<ZekrModel> lst = await ZekrModel.fromDataBase(
        where: "`category`='${state.currentZekr?.category}'");

    if (lst != null && lst.isNotEmpty)
      yield AzkarState(list: lst, pos: state.pos);
  }
}
