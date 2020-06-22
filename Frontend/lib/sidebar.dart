import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import './feed/reminder_feed.dart' as Rem;

import './feed/goal_feed.dart' as Gol;

import './feed/transaction_feed.dart' as Tra;

import './feed/tabbar.dart' as tab;

import './notification_alerts/notifications.dart' as not;

import 'home/HomePage.dart';
import 'about/about.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ActiveSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SideBar(),
      routes: <String, WidgetBuilder>{
        "/Remainder": (BuildContext context) => Rem.Remainder(),
        "/Goals": (BuildContext context) => Gol.Goal(),
        "/Transaction": (BuildContext context) => Tra.Transaction(),
        "/tab": (BuildContext context) => tab.MyTabs(),
        "/notification": (BuildContext context) => not.Notification(),
        "/Home": (BuildContext context) => HomePage(),
      },
    );
  }
}

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  var data;
  var isLoading = false;
  String name, mail, url , token;
  Future<void> getUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    token = prefs.getString('token');
    var response = await http.get(
        Uri.encodeFull(url+ "/user"), headers: {
    'Content-type': 'application/json',
    'Accept': '*/*',
    'x-access-token': token
        });
        this.setState((){
          print(response.body);
          data = json.decode(response.body)["user"];
          // print(data);
          return (response.body);
        });
  }
  String retrieveUser()  {
    int flag=0;
    SharedPreferences.getInstance().then((value) {
      setState(() {
        name = value.getString('name');
        mail = value.getString('mail');
        print(name);
        if(name==null){
          print('entered if and');
          flag++;
        }
      });
      // print(name);
      print(flag);
      if(flag>0)
        return "failed";
      return "success";
    });
  }

  @override
  void initState()  {
    print("here");
    String check = retrieveUser();
    print(check);
    if(check!="success"){
      print("entered checked");
       this.getUser().then((value) {name = data['name'];
      mail = data['email'];
      isLoading=true;});
      print("data is" + data.toString());
    }
    print(name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 0, 100, 0),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: name==null ? Center(child: CircularProgressIndicator()) : Text(
                name,
                style: GoogleFonts.lato(fontSize: 18),
              ),
              accountEmail: Text(
                mail,
                style: GoogleFonts.lato(fontSize: 18),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.green[400],
                child: Text(name[0]),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: ListTile(
                leading: const Icon(Icons.home),
                title: Text(
                  'Home',
                  style: GoogleFonts.lato(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: ExpansionTile(
                leading: const Icon(Icons.local_activity),
                title: Text(
                  'Feed',
                  style: GoogleFonts.lato(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              tab.index = 0;
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new tab.MyTabs()));
                            },
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.archive),
                                  Text(
                                    'Transactions',
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[400]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              tab.index = 1;
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new tab.MyTabs()));
                            },
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.attach_money),
                                  Text(
                                    'Goals',
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[400]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              tab.index = 2;
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new tab.MyTabs()));
                            },
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.add_alert),
                                  Text('Reminders',
                                      style: GoogleFonts.lato(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[400])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: ListTile(
                leading: const Icon(Icons.notifications_active),
                title: Text(
                  'Notifications and alerts',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  tab.index = 1;
                  Navigator.of(context).pushNamed("/notification");
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: ListTile(
                leading: const Icon(Icons.help),
                title: Text(
                  'Help',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  'About',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                 debugPrint('abc');
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => new About()));
                },
              ),
            ),
//            Container(
//                margin: EdgeInsets.all(5),
//                child: ListTile(
//                  leading: const Icon(Icons.power),
//                  title: Text(
//                    'Logout',
//                    style: GoogleFonts.lato(
//                      fontSize: 18,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                  onTap: () async{
//                    SharedPreferences prefs = await SharedPreferences.getInstance();
//                    prefs?.clear();
//                    Navigator.pushAndRemoveUntil(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => new SplashScreen()),
//                        ModalRoute.withName("/Home")
//                    );
//                  },
//              ),
//            )
          ],
        ),
      ),
    ) : Center(child: CircularProgressIndicator());
  }
}