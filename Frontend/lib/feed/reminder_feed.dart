import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './sliderRow.dart';

import '../sidebar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../login_register/PlusButton.dart';


class Remainder extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _RemainderState createState() => _RemainderState();
}

class _RemainderState extends State<Remainder> {
  List data = [];
  String url;
  String token;
  var isLoading = true;

  Future<String> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    url = pref.getString('url');
    token = pref.getString('token');
    var response = await http.get(Uri.encodeFull(url + "/reminder"), headers: {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'x-access-token': token
    });
    this.setState(() {
      debugPrint("abc");
      print(token);
      print(Uri.encodeFull(url + "/reminder"));
      print(response.statusCode);
      data = json.decode(response.body);
      if(data == null || data.length ==0){
        Fluttertoast.showToast(msg: "Reminders empty");
      }
      return (response.body);
    });
    print(response.body);
    isLoading = false;
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
      backgroundColor :  const Color(0xffeceaeb),
      drawer: ActiveSideBar(),
      body: !isLoading
          ? RefreshIndicator(
        child: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int ind) {
            return new Card(
              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
              elevation: 3.0,
              child: SildeAbleRow(
                id: data[ind]['id'],
                amount: data[ind]['amount'],
                date: data[ind]['due_date'].toString(),
                purpose: data[ind]['description'],
                nextPage: 2,
                achieved: data[ind]['achieved'],
              ),
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