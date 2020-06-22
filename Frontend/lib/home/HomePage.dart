import 'package:final_project/home/Categories_Row.dart';
import 'package:final_project/home/PieChart_View.dart';
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
import 'DashBoard.dart' as dash;
import 'PieChart.dart';

class HomePage extends StatefulWidget {
  static String balance=0.toString();
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
    } catch (error) {
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
  void initState() {
    isLoading = true;
    this.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return errorMessage == null
        ? !isLoading
            ? Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  iconTheme: new IconThemeData(color: Colors.blueAccent),
                  backgroundColor: Colors.transparent,
                  title: DashBoard(),
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.power),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs?.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                    )
                  ],
                ),
                floatingActionButton: PlusButton(context),
                drawer: ActiveSideBar(),
                body: Container(
                  decoration: BoxDecoration(
                    image:DecorationImage(image: AssetImage("assets/image/background.png"),
                    fit: BoxFit.cover,),
                  ),
                  child: SafeArea(
                    child: SizedBox.expand(
                      child: Stack(
                        children: <Widget>[
//                          Positioned(
//                            top: -10,
//                            child: SizedBox(
//                                height: height * 0.5, child: DashBoard()),
//                          ),
                          Positioned(
                            top: height*0.03,
                            left: width*0.0094,
                            height: height * 0.4,
                            width: width *0.95,
                            child: Container(
                              child: Card(
                                elevation: 14,
                                color: Colors.white,
                                shadowColor: Colors.indigo,
                                margin: EdgeInsets.fromLTRB(width*0.035, 0, 0, 0),
                                child: SimpleTimeSeriesChart(),
                              ),
                            ),
                          ),
//                          Positioned(
//                            top: 70,
//                            right: 50,
//                            child: Container(child: Card(elevation: 8,shadowColor: Colors.blueGrey,child: Padding(
//                              padding: const EdgeInsets.all(10.0),
//                              child: Column( children: <Widget>[
//                                Text("Expense", style: GoogleFonts.lato(color: Colors.redAccent)),
//                                Text("Income", style: GoogleFonts.lato(color: Colors.blueAccent)),
//                                Text("Balance", style: GoogleFonts.lato(color: Colors.greenAccent)),
//                              ],),
//                            )))
//                          ),
                          Positioned(
                              bottom: 50,
                              left: 12,
                              width: width,
                              height: height * 0.36,
                              child: Card(
                                elevation: 18,
                                margin: EdgeInsets.fromLTRB(0, 0, 20, 40),
                                child: Row(
                                  children: <Widget>[
//                        Placeholder(),
                                    CategoriesRow(),
                                    PieChartView(),
                                  ],
                                ),
                              )),
                          SizedBox.expand(child: showLargeMenu()),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Scaffold(body: Center(child: CircularProgressIndicator()))
        : Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  Widget PlusButton(BuildContext context) {
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
                    new MaterialPageRoute(builder: (context) => MyTransPage()))
                .then((status) {
              if (status != 0)
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
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

  showLargeMenu() {
    return DraggableScrollableSheet(
        initialChildSize: 0.08,
        minChildSize: 0.08,
        maxChildSize: 1,
        builder: (BuildContext context, sc) {
          return Container(
            color: Colors.indigo,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: 56.0,
            child: ListView(
              controller: sc,
              children: <Widget>[
                Row(children: <Widget>[
                  IconButton(
                    onPressed: showLargeMenu,
                    icon: Icon(Icons.menu),
                    color: Colors.white,
                  ),
                  Spacer(),
                  !isLoading?Text("Balance : ₹ " + HomePage.balance,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16)):CircularProgressIndicator(),
                  Spacer(),
                  IconButton(
                    onPressed: showLargeMenu,
                    icon: Icon(Icons.menu),
                    color: Colors.indigo
                  ),
                ]),
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text("Income",
                          style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                  children: <Widget>[
                    for (var category in kIncomeCategories)
                      if(category.amount!=0)
                        CategoryList(text: category.name, index: kIncomeCategories.indexOf(category)),
                  ],
                ),
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text("Expense",
                          style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                  children: <Widget>[
                    for (var category in kCategories)
                      if(category.amount!=0)
                        CategoryList(text: category.name, index: kCategories.indexOf(category)),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key key,
    @required this.index,
    @required this.text,
  }) : super(key: key);

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(text,
          style: GoogleFonts.lato(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      leading: Padding(
        padding: EdgeInsets.fromLTRB(52, 0, 0, 0),
        child: Icon(Icons.category, color:  kNeumorphicColors.elementAt(index % kNeumorphicColors.length)),
      ),
      children: <Widget>[
        for(var transaction in kTransactions)
          if(transaction.label == text)
            TransactionList(name: transaction.description, amount: transaction.amount, date: transaction.date),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({
    Key key,
    @required this.name,
    @required this.amount,
    @required this.date,
  }) : super(key: key);

  final String name;
  final String amount;
  final String date;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('₹ '+ amount, style: GoogleFonts.lato(color: Colors.lightBlue)),
      subtitle: Text(name, style: GoogleFonts.lato(color: Colors.lightBlue)),
      trailing: Text(date, style: GoogleFonts.lato(color: Colors.lightBlue)),
    );
  }
}

