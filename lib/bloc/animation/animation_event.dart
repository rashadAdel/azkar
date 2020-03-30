part of 'animation_bloc.dart';

abstract class AnimationEvent extends Equatable {
  const AnimationEvent();
}

class Clicked extends AnimationEvent {
  final String categoryName;

  Clicked({this.categoryName});

  @override
  List<Object> get props => [categoryName];
}

class SecondAnimation extends AnimationEvent {
  final bool anim;
  SecondAnimation(this.anim);
  @override
  List<Object> get props => [anim];
}
