import 'package:flutter/material.dart';
import 'package:final_project/feed/reminder_feed.dart';
import 'package:final_project/feed/transaction_feed.dart';
import 'package:final_project/feed/goal_feed.dart';


int index;

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3, initialIndex: index);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.indigo,
          bottom: new TabBar(
            controller: controller,
            tabs: <Tab>[
              new Tab(
                child: Text('Transactions', style: TextStyle(fontSize: 18)),
              ),
              new Tab(
                child: Text('Goals', style: TextStyle(fontSize: 18)),
              ),
              new Tab(
                child: Text('Reminders', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
        body: new TabBarView(controller: controller, children: <Widget>[
          new Transaction(),
          new Goal(),
          new Remainder(),
        ]));
  }
}
