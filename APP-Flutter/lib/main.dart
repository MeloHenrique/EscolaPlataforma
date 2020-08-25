import 'package:flutter/material.dart';
import 'Pages/splash.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: Splash(),
    );
  }
}

