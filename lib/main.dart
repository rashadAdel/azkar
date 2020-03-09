import 'package:azkar/Routes/Router.gr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

void main() => runApp(MyApp());

Container backGround = Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      colors: [Colors.white, Color(0xffF2994A)],
    ),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, Color>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: state,
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(backgroundColor: state),
            ),
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            initialRoute: Router.loading,
            onGenerateRoute: Router.onGenerateRoute,
            navigatorKey: Router.navigator.key,
          );
        },
      ),
    );
  }
}

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
