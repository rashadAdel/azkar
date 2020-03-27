import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<Color, Color> {
  @override
  Color get initialState => Colors.blue;
  @override
  Stream<Color> mapEventToState(
    Color event,
  ) async* {
    yield event;
  }
}
