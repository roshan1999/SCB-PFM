import 'dart:convert';
import 'package:flutter/material.dart';
import './feed/reminder_feed.dart' as Rem;
import './feed/goal_feed.dart' as Gol;
import './feed/transaction_feed.dart' as Tra;
import './feed/tabbar.dart' as tab;
import './notification_alerts/notifications.dart' as not;
import 'home/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_register/login.dart';



class FinanceApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('url', 'http://68df501b49f6.ngrok.io');
    var jwt = prefs.getString("token");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SC PFM',
      routes: <String, WidgetBuilder>{
        "/Remainder": (BuildContext context) => Rem.Remainder(),
        "/Goals": (BuildContext context) => Gol.Goal(),
        "/Transaction": (BuildContext context) => Tra.Transaction(),
        "/tab": (BuildContext context) => tab.MyTabs(),
        "/notification": (BuildContext context) => not.Notification(),
        "/Home": (BuildContext context) => HomePage(),
        "/login": (BuildContext context) => MyApp(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");

              if(jwt.length !=3) {
                return MyApp();
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  return HomePage();
                } else {
                  return LoginPage();
                }
              }
            } else {
              return LoginPage();
            }
          }
      ),
    );
  }
}
void main(){
  runApp(FinanceApp());
}