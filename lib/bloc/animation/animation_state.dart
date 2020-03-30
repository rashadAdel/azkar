part of 'animation_bloc.dart';

class AnimationState extends Equatable {
  final bool secondAnimation;
  final String categoryName;
  AnimationState({this.secondAnimation = false, this.categoryName});

  @override
  List<Object> get props => [secondAnimation, categoryName];
}
