import 'package:flutter/material.dart';

import './sliderRow.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/HomePage.dart';
import 'sliderRow.dart';
class Goal extends StatefulWidget{
  @override
  _GoalState createState() => _GoalState();

}

class _GoalState extends State<Goal> {
  // This widget is the root of your application.
  List data = [];
  String token;
  String url;
  var isLoading = true;
  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    token = prefs.getString('token');
    var response = await http.get(
        Uri.encodeFull(url+ "/goal"), headers: {
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
      drawer: ActiveSideBar(),
      body: !isLoading
          ?RefreshIndicator(
            child: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int ind) {
            return new Card(
              child: SildeAbleRowGoal(
                  id: data[ind]['id'],
                  amount: data[ind]['amount_total'],
                  amountAchieved: data[ind]['amount_saved'],
                  date: data[ind]['due_date'].toString(),
                  purpose: data[ind]['description'],
                  nextPage: 1,
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