import 'package:final_project/login_register/Vinnew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './DashBoard.dart';
import './Monthly_Expenses.dart';
import '../sidebar.dart';
import './LineGraph.dart';
import 'package:final_project/add/add_transaction.dart';
import 'package:final_project/add/add_reminder.dart';
import 'package:final_project/add/add_goal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var isRefresh;

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token;
  var response;
  static String errorMessage;
  List data = [];

  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    url = pref.getString('url');
    token = pref.getString('token');
    try {
      response = await http.get(Uri.encodeFull(url + "/transaction"), headers: {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'x-access-token': token
      });
      this.setState(() {
        debugPrint("abc");
        print(Uri.encodeFull(url + "/transaction"));
        print(response.body);
        data = json.decode(response.body);
        isLoading = false;
      });
    }
    catch(error){
      this.setState(() {
        errorMessage = error.toString();
        pref.setString('token', 'error');
      });
    }
  }
  var homeCalled;
   String str;
  var isLoading;
   @override
   void initState(){
     isLoading = true;
       this.getData();
     super.initState();
   }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return errorMessage==null?
    !isLoading?RefreshIndicator(
    child: Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        elevation: 0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power),
          onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs?.clear();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyApp()),
              );
          },)
        ],
      ),
      floatingActionButton: PlusButton(),
      drawer: ActiveSideBar(),
      body:
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DashBoard(),
            SizedBox(
              height: height * 0.35,
              child: Container(
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.green[50],
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SimpleTimeSeriesChart(),
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: MonthlyExpensesView()),
          ],
        ),
      ),
    ),
      onRefresh: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
      return;
      }
    ):Scaffold(body:Center(child: CircularProgressIndicator()))

        : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
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
                new MaterialPageRoute(builder: (context) => MyTransPage())).then((status)
            {
              isRefresh = status;
            });
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
