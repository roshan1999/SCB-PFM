import 'package:final_project/home/SplashScreen.dart';
import 'package:flutter/material.dart';

import 'login_register/Vinnew.dart';


class FinanceApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
      routes: <String, WidgetBuilder>{},
    );
  }
}


void main() {
  runApp(FinanceApp());
}
