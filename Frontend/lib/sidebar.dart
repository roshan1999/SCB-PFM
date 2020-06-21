import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import './feed/reminder_feed.dart' as Rem;

import './feed/goal_feed.dart' as Gol;

import './feed/transaction_feed.dart' as Tra;

import './feed/tabbar.dart' as tab;

import './notification_alerts/notifications.dart' as not;

import 'home/HomePage.dart';

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
        "/Home" : (BuildContext context) => HomePage(),
      },
    );
  }
}

class SideBar extends StatelessWidget {
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
                'admin',
                style: GoogleFonts.lato(fontSize: 18),
              ),
              accountEmail: Text(
                'admin@sc.com',
                style: GoogleFonts.lato(fontSize: 18),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.green[400],
                child: Text('K'),
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
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
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
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
