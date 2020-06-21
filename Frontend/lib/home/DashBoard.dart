import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashBoard extends StatelessWidget {
  var isLoading;
  var res;
  var str;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10.0,8.0,10.0,0.0),
              child: Card(
                  color: Colors.white,
                  child: Center(
                    child: RaisedButton(
                      disabledColor: Colors.white,
                      onPressed: null,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                        child: Row(
                    children: <Widget>[
                        Text('CHECK IF YOU ARE ON TRACK',
                          style: GoogleFonts.lato(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton( // This is the button for checking if user is on track for goals(based on previous months expenses and this month's income)
                          onPressed:()async {var response = await getAlert();
                        print(response.body);
                        if(response.statusCode==200){
                          res=json.decode(response.body);
                          print(res);
                          print('here');
                          if(res['message']=="success"){
                            str="You are on track as of your last months expenses";
                            _showResult(context, str);
                          }
                          else if(res['message']=="fail"){
                            str=res['trivia'];
                            _showResult(context,str);
                          }
                          else{
                            str="server issues try again later";
                            _showResult(context,str);
                          }
                        }
                        },
                          iconSize: 25.0,
                          icon:Icon(Icons.directions_run, color: Colors.green,),
                          tooltip: 'Check if your goals are on track',
                        ),
                        SizedBox(width: 1.0),
                        IconButton( // This is the button to divide the current balance in proportion to goals. Ideally this will be triggered at ast day of every month.
                          onPressed:()async {var response2 = await divide_savings_to_goals();
                        print(response2.body);
                        if(response2.statusCode==200){
                          var res2=json.decode(response2.body);
                          print(res2);
                          print('here');
                          if(res2['message']=="Savings divided into goals"){
                            str="The current balance is divided proportionally into your future goals";
                            _showResult(context, str);
                          }
                          else if(res2['message']=="Not enough balance to divide any amount"){
                            str="You do not have any savings. Please spend wisely.";
                            _showResult(context,str);
                          }
                          else if(res2['message']=="You have achieved all your goals"){
                            str="Heyy ! You have achieved all your goals already";
                            _showResult(context,str);
                          }
                          else{
                            str="server issues try again later";
                            _showResult(context,str);
                          }
                        }
                        },
                          iconSize: 25.0,
                          icon:Icon(Icons.category, color: Colors.blue),
                          tooltip: 'Divide your current savings balance in goals',
                        ),
                    ],
                  ),
                      )
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<dynamic> getAlert() async {
    String url;
    String token;
    isLoading = true;
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

  Future<dynamic> divide_savings_to_goals() async {
    String url;
    String token;
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    print(url);
    token = prefs.getString('token');
    var response = await http.get(
        Uri.encodeFull(url+ "/divide_savings"), headers: {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'x-access-token': token
    });
    isLoading = false;
    // print(response.body);
    return response;
  }
}
Future<void> _showResult(context , String message) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Close'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message,
                style: GoogleFonts.lato(
                    fontSize:18,
                    fontWeight:FontWeight.bold
                ),),
            ],
          ),
        ),
      );
    },
  );
}

