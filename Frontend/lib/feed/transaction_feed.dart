import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './sliderRow.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'dart:convert';

import '../sidebar.dart';
import '../login_register/PlusButton.dart';


class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List data = [];
  String url;
  String token;
  var isLoading = true;
  var response;
  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    url = pref.getString('url');
    token = pref.getString('token');
    response = await http.get(Uri.encodeFull(url + "/transaction"), headers: {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'x-access-token': token
    });
    this.setState(() {
      debugPrint("abc");
      print(Uri.encodeFull(url + "/transaction"));
      data = json.decode(response.body);
      if (data == null || data.length == 0) {
        Fluttertoast.showToast(msg: "Transactions empty");
      }
      isLoading = false;
    });
  }
//  }
//  margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
//  elevation: 12.0,
//  backgroundColor :  const Color(0xffeceaeb),

  void initState(){
    print("Test");
    this.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor :  const Color(0xffeceaeb),
      drawer: ActiveSideBar(),
      body: !isLoading?
      RefreshIndicator(
        child: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int ind) {
            return new Card(
              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
              elevation: 3.0,
              child: SildeAbleRowTransaction(
                id:data[ind]['id'],
                amount: data[ind]['amount'],
                date: data[ind]['date'].toString(),
                purpose: data[ind]['description'],
                label: data[ind]['label'].toString(),
                nextPage: 0,
                type : data[ind]['type'],
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