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
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10.0,8.0,10.0,0.0),
              child: Card(
                  color: Colors.white,
                  child: Center(
                    child: RaisedButton(
                      color: Colors.white,
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
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50,0,0,0),
                        child: Row(
                    children: <Widget>[
                        Text('CHECK IF YOU ARE ON TRACK',
                          style: GoogleFonts.lato(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          iconSize: 25.0,
                          icon:Icon(Icons.directions_run, color: Colors.green,),
                          tooltip: 'Check if your goals are on track',
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

