import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import './DashBoard.dart';
import './Monthly_Expenses.dart';
import '../sidebar.dart';
//import './graphData.dart' as Graph;
import './LineGraph.dart';
import 'package:final_project/add/add_transaction.dart';
import 'package:final_project/add/add_reminder.dart';
import 'package:final_project/add/add_goal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  var res;
  String str;
  @override
  Widget build(BuildContext context) {
//    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        elevation: 0,
      ),
      floatingActionButton: PlusButton(),
      drawer: ActiveSideBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            DashBoard(),
            Container(
              color: Colors.black,
              child: RaisedButton(
              onPressed:()async {var response = await getAlert();
              print(response.body);
              // print('here');
              if(response.statusCode==200){
                res=json.decode(response.body);
                print(res);
                print('here');
                if(res['message']=="success")
                str="You are on track as of your last months expenses";
                  _showResult(context, str);
              }
              },
              child: Text('Check if you can meet all your goals or not',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[400])),
            )),
            Container(
              padding: EdgeInsets.all(20),
              height: 250,
              margin: EdgeInsets.all(10),
              child: SimpleTimeSeriesChart(
                createSampleData(),
                animate: false,
              ),
            ),
            Flexible(child: MonthlyExpensesView()),
          ],
        ),
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  const PlusButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      overlayColor: Colors.blueGrey,
      overlayOpacity: 0.4,
      curve: Curves.fastLinearToSlowEaseIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.attach_money),
          label: "Add Transaction",
          backgroundColor: Colors.greenAccent,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyTransPage()));
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.outlined_flag),
          label: "Add Goal",
          backgroundColor: Colors.redAccent,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyGoalPage()));
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.add_alert),
          label: "Add Reminder",
          backgroundColor: Colors.yellow,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyReminderPage()));
          },
        )
      ],
    );
  }
}
Future<void> _showResult(context , String message) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }
Future<dynamic> getAlert() async {
    String url;
    String token;
    var isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    print(url);
    token = prefs.getString('token');
    var response = await http.get(
        Uri.encodeFull(url+ "/alert"), headers: {
    'Content-type': 'application/json',
    'Accept': '*/*',
    'x-access-token': token
    });
    isLoading = false;
    // print(response.body);
    return response;
  }