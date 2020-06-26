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

import 'login_register/Vinnew.dart';

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
  String name = 'n', mail = 'user@xyz.com';
  void retrieveUser() {
    try{
      SharedPreferences.getInstance().then((value) {
        setState(() {
          name = value.getString('name');
          mail = value.getString('mail');
        });
      });
    }
    catch(e){
      print(e.toString());
      name = "userName";
      mail = "user@mail.com";
    }
  }

  @override
  void initState() {
    retrieveUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 0, 100, 0),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
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
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.archive, color: Colors.blueAccent,),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      child: Text(
                                        'Transactions',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo),
                                      ),
                                    ),
                                  ],
                                ),
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
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.attach_money, color: Colors.blueAccent,),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      child: Text(
                                        'Goals',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo),
                                      ),
                                    ),
                                  ],
                                ),
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
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.add_alert,color: Colors.blue),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      child: Text('Reminders',
                                          style: GoogleFonts.lato(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo)),
                                    ),
                                  ],
                                ),
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
                  'about',
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
    );
  }
}