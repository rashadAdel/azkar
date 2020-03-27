import 'package:azkar/Routes/Router.gr.dart';
import 'package:azkar/bloc/animation/animation_bloc.dart';
import 'package:azkar/bloc/azkar/azkar_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'bloc/thems/ThemeBloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<AzkarBloc>(
          create: (context) => AzkarBloc(),
        ),
        BlocProvider<AnimationBloc>(
          create: (context) => AnimationBloc(),
        )
      ],
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
            initialRoute: Router.initial,
            onGenerateRoute: Router.onGenerateRoute,
            navigatorKey: Router.navigator.key,
          );
        },
      ),
    );
  }
}
