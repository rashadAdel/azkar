import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animation_event.dart';
part 'animation_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  @override
  AnimationState get initialState => AnimationState();

  @override
  Stream<AnimationState> mapEventToState(
    AnimationEvent event,
  ) async* {
    if (event is Clicked) {
      yield AnimationState(categoryName: event.categoryName);
    } else if (event is SecondAnimation) {
      yield AnimationState(
          categoryName: state.categoryName, secondAnimation: event.anim);
    }
  }
}
