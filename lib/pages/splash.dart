import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  //Definindo o tempo de duração da tela antes de ir para a home page do aplicativo
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 5), (){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => Home() )  
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 150),
              Container(
                width: MediaQuery.of(context).size.width - 80,
                //width: 250,
                height: 250,
                child: FlareActor(
                  'assets/animation/my_travels.flr', 
                  animation: 'splashAnimation'
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Minhas Viagens',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 200,),
              Container(
               // height: 1,
                child: Text(
                  'code4line apps -  V1.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}