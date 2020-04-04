import 'package:flutter/material.dart';
import './theme.dart';
import './pages/splash.dart';
//import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themedata,
      home: Splash(),
    );
  }
}