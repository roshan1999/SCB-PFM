import '../login_register/PlusButton.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Notify extends StatelessWidget {
  final int id;
  final int amount;
  final DateTime date;
  final String purpose;
  Notify(
      {@required this.id,
      @required this.amount,
      @required this.date,
      @required this.purpose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
          child: Card(
        elevation: 3.0,
        color: Colors.blue[50],
        margin: EdgeInsets.fromLTRB(10 , 15, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          SizedBox(width:2.0),
          Icon(Icons.warning,color: Colors.red,size: 45.0,),
          SizedBox(width:10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          SizedBox(width:3.0),
          Text('$purpose',style: GoogleFonts.lato(fontSize: 15.0,fontWeight: FontWeight.bold),),
          SizedBox(height: 3.0,),
          Text('₹ $amount on '+ date.day.toString()+ '-'+date.month.toString(),style: GoogleFonts.lato(fontSize:15.0,fontWeight: FontWeight.bold))
        ],),
        ],)
      ),
    );
  }
}
class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  // This widget is the root of your application.
  List data = [];
  String token;
  String url;
  var isLoading = true;
  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    token = prefs.getString('token');
    var response = await http
        .get(Uri.encodeFull(url + "/notification/reminder"), headers: {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'x-access-token': token
    });
    this.setState(() {
      debugPrint("abc");
      print(response.statusCode);
      data = json.decode(response.body);
      return (response.body);
    });
    isLoading = false;
    print(response.body);
    return "Success";
  }

  void initState() {
    debugPrint("Test");
    this.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Notifications' ,
        style: GoogleFonts.lato(
          fontSize: 24,
        ),
      ),),
      body: !isLoading
          ? RefreshIndicator(
              child: new ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int ind) {
                  return new Notify(
                      id: data[ind]['id'],
                      amount: data[ind]['amount'],
                      date: DateTime.parse(data[ind]['due_date']),
                      purpose: data[ind]['description'],
                    );
                },
              ),
              onRefresh: getData,
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: PlusButton(),
    );
  }
}