import 'dart:async';

import 'package:final_project/login_register/Vinnew.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent
        ),
      ),
      ),
      routes: {
        "/Home": (BuildContext context) => HomePage(),
        "/Login": (BuildContext context) => MyApp(),
      }
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getString('token')==null ? false:true;
    print(status);
    if (status) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MyApp()));
    }
  }
}