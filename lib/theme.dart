import 'package:flutter/material.dart';

 final themedata = ThemeData(
  //Definindo cores principais
  brightness: Brightness.light,
  primaryColor: Colors.teal,
  //fonte padarão
  fontFamily: 'Montserrat',
  textTheme: TextTheme(
    headline5: TextStyle(fontSize: 72, fontWeight: FontWeight.w700),
    bodyText1: TextStyle(fontSize: 30),
    bodyText2: TextStyle(fontSize: 12) 
  ),    
);