import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './signup.dart';

import '../home/HomePage.dart';

import 'dart:async';

import 'dart:core';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

String url;

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage()
      },
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  checkStatus() {
    SharedPreferences.getInstance().then((prefs) {
      var status = prefs.getString('token');
      if (status == null || status == "error") {
        print(prefs.getString('token'));
        return "Done";
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return 'Done2';
      }
    });
    return LoginPage();
  }

  @override
  void initState() {
    super.initState();
  }

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  var result;
  final _formKey = GlobalKey<FormState>();

  Future<http.Response> login(String email, password) async {
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$email:$password'));
    print(basicAuth);
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    String uri = Uri.encodeFull(url + "/login");
    print(uri);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'authorization': basicAuth
    };
    var response = await http.get(uri, headers: headers);
    print(response.body);
    if(json.decode(response.body)["message"]=="Token is invalid!"){
      Fluttertoast.showToast(msg: "Session expired Please Login again");
      prefs.setString('token', null);
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                          child: Text('Welcome !',
                              style: TextStyle(
                                fontSize: 50.0,
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
                  )),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          RegExp regExp = new RegExp(
                            r"^[\w+?\.]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$",
                          );
                          if (!regExp.hasMatch(value)) {
                            return 'Please Enter a valid Email Address';
                          }
                          return null;
                        },
                        controller: email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: password,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                          alignment: Alignment(1.0, 0.0),
                          padding: EdgeInsets.only(top: 15.0, left: 30.0),
                          child: InkWell(
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            login(email.text.replaceAll(' ', ''),
                                password.text)
                                .then((response) async {
                              print(result);
                              if (response.statusCode == 200) {
                                result = jsonDecode(response.body);
                                await storeToken(result['token'],result['name'],result['mail']);
                                debugPrint('Homepage');
                                Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage()),
                                );
                              } else  {
                                if(response.statusCode==401)
                                  Fluttertoast.showToast(msg: "Password or username is incorrect");
                                else
                                  Fluttertoast.showToast(msg: "Failed to login");
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 40.0,
                          child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7.0,
                              child: Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                          height: 40.0,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Image.asset('assets/image/sclogo.png'),
                                ),
                                Center(
                                  child: Text(
                                    'Bank with SC Mobile',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  )),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('New to PFM ?'),
                  SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => SignupPage()));
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.green,
                        ),
                      ))
                ],
              )
            ],
          ),
        ));
  }

  Future storeToken(String token , String name , String mail) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    print(name);
    prefs.setString('mail', mail);
    prefs.setString('token', token);
  }
}