import 'package:flutter/material.dart';
import 'package:login/SignIn.dart';
import 'splash.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login By Rehan',

      home: SplashScreen(),

      routes: <String,WidgetBuilder>
      {
        '/Home': (BuildContext context) => new SignIn()
      },

    );
  }
}