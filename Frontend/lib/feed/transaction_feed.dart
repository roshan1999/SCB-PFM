import 'package:flutter/material.dart';

import './sliderRow.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'dart:convert';

import '../sidebar.dart';
import '../home/HomePage.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List data;
  String url;
  String token;

  Future<String> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    url = pref.getString('url');
    token = pref.getString('token');
    var response = await http.get(Uri.encodeFull(url + "/transaction"), headers: {
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
      return (response.body);
    });
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
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int ind) {
          return new Card(
            child: SildeAbleRow(
                amount: data[ind]['amount'],
                date: data[ind]['date'].toString(),
                purpose: data[ind]['description']),
          );
        },
      ),
     floatingActionButton: PlusButton(), 
    );
  }
}
