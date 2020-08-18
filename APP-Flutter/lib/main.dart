import 'package:flutter/material.dart';
import 'Pages/splash.dart';
import 'package:flutter/services.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: Splash(),
    );
  }
}

