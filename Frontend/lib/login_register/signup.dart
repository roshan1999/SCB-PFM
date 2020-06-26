import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home/HomePage.dart';
import '../sidebar.dart';

import '../home/graphData.dart' as Graph;

import '../home/LineGraph.dart';

import '../add/choose_category.dart';

import 'package:http/http.dart' as http;

import 'dart:async';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget header(String s) {
  return Container(
      child: Center(
    child: Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(10.0, 110.0, 0.0, 0.0),
            child: Text('$s',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ))),
        Container(
            padding: EdgeInsets.fromLTRB(15.0, 155.0, 0.0, 0.0),
            child: Text('SC',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[400],
                ))),
        Container(
            padding: EdgeInsets.fromLTRB(85.0, 155.0, 0.0, 0.0),
            child: Text('PFM',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                )))
      ],
    ),
  ));
}

Widget detailEntry(String s) {
  return Container(
      padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: '$s',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ));
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController tc = TextEditingController();
  static String sessionData;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tc.dispose();
    super.dispose();
  }

  Future<http.Response> getSessionData(String body) async {
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    String uri = Uri.encodeFull(url + "/getOTP");
    print(uri);
    var bodyEncoded = json.encode({"mobileNo": body});
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(uri, headers: headers, body: bodyEncoded);
    return (response);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header('Signing Up'),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tc,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Mobile No.',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: Center(
                child: RaisedButton.icon(
                    onPressed: () {
                      print('get otp');
                      if (tc.text.length != 10 ||
                          tc.text[0] == '0' ||
                          tc.text[0] == '1' ||
                          tc.text[0] == '2' ||
                          tc.text[0] == '3' ||
                          tc.text[0] == '4' ||
                          tc.text[0] == '5') {
                        Fluttertoast.showToast(
                            msg: "Please enter a valid 10 digit mobile number");
                      } else {
                        getSessionData(tc.text).then((response) {
                          // Maintain enum for the status codes and URI
                          if (response.statusCode == 200) {
                            sessionData = jsonDecode(response.body)['message'];
                            print(sessionData);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => OtpCheck()));
                          } else {
                            print(response.statusCode);
                            Fluttertoast.showToast(
                                msg: "OTP could not be generated");
                          }
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    textColor: Colors.white,
                    splashColor: Colors.greenAccent,
                    color: Colors.green,
                    icon: Icon(Icons.send),
                    label: Text(
                      'Send OTP',
                    )),
              ),
            ),
          ],
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('tc', tc));
  }
}

class OtpCheck extends StatefulWidget {
  @override
  _OtpCheckState createState() => _OtpCheckState();
}

class _OtpCheckState extends State<OtpCheck> {
  TextEditingController tp = new TextEditingController();
  Map<String, dynamic> verify;
  String sessionId = _SignupPageState.sessionData;

  Future<http.Response> verifyOtp(String body) async {
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    String uri = Uri.encodeFull(url + "/checkOTP");

    var bodyEncoded = json.encode({"sessionId": sessionId, "OTP": body});
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(uri, headers: headers, body: bodyEncoded);
    print(response.body);
    return (response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header('Signing Up'),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tp,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: Center(
                child: RaisedButton.icon(
                    onPressed: () {
                      verifyOtp(tp.text).then((response) {
                        verify = jsonDecode(response.body);
                        if (verify['message'] == "OTP true") {
                          Fluttertoast.showToast(msg: "OTP verified");
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => enterDetails()));
                        } else {
                          print(response.statusCode);
                          Fluttertoast.showToast(msg: "Incorrect OTP");
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    textColor: Colors.white,
                    splashColor: Colors.greenAccent,
                    color: Colors.green,
                    icon: Icon(Icons.verified_user),
                    label: Text(
                      'Verify',
                    )),
              ),
            ),
          ],
        ));
  }
}

// ignore: camel_case_types
class enterDetails extends StatelessWidget {
  final TextEditingController tp = new TextEditingController();
  static String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header('Signing Up'),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tp,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: Center(
                child: RaisedButton.icon(
                    onPressed: () {
                      name = tp.text;
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => EnterEmail()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    textColor: Colors.white,
                    splashColor: Colors.greenAccent,
                    color: Colors.green,
                    icon: Icon(Icons.arrow_forward),
                    label: Text(
                      'Next',
                    )),
              ),
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class EnterEmail extends StatelessWidget {
  static String email;
  TextEditingController tp = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header('Signing Up'),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tp,
                      decoration: InputDecoration(
                        labelText: 'Enter Email',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: Center(
                child: RaisedButton.icon(
                    onPressed: () {
                      email = tp.text;
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => SetPassword()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    textColor: Colors.white,
                    splashColor: Colors.greenAccent,
                    color: Colors.green,
                    icon: Icon(Icons.done),
                    label: Text(
                      'Done',
                    )),
              ),
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class SetPassword extends StatelessWidget {
  TextEditingController tp = new TextEditingController();
  TextEditingController tc = new TextEditingController();
  String token;
  Map<String, dynamic> result;
  String sessionId = _SignupPageState.sessionData;

  Future<http.Response> register(String body) async {
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    String uri = Uri.encodeFull(url + "/register");
    var bodyEncoded = json.encode({
      "sessionId": sessionId,
      "name": enterDetails.name,
      "email": EnterEmail.email,
      "password": body
    });
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(uri, headers: headers, body: bodyEncoded);
    print(response.body);
    return (response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header('Signing Up'),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tp,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Enter password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tc,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Repeat Password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: Center(
                child: RaisedButton.icon(
                    onPressed: () {
                      if (tc.text != tp.text) {
                        Fluttertoast.showToast(msg: "Passwords don't match");
                      } else {
                        register(tp.text).then((response) async {
                          if (response.statusCode == 200) {
                            token = json.decode(response.body)['message'];
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('token', token);
                            prefs.setString('name', enterDetails.name);
                            prefs.setString('mail', EnterEmail.email);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } else {
                            print(response.statusCode);
                            if (response.statusCode == 401) {
                              Fluttertoast.showToast(msg: "OTP incorrect");
                            } else {
                              Fluttertoast.showToast(msg: "User Registered");
                            }
                          }
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    textColor: Colors.white,
                    splashColor: Colors.greenAccent,
                    color: Colors.green,
                    icon: Icon(Icons.create),
                    label: Text(
                      'Sign in Now',
                    )),
              ),
            ),
          ],
        ));
  }
}

class HomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi that is home page'),
      ),
      drawer: ActiveSideBar(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            height: 300,
            margin: EdgeInsets.all(10),
            child: SimpleTimeSeriesChart(),
          ),
          Graph.MyApp(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => ChooseCategoryPage()),
          );
        },
      ),
    );
  }
}
