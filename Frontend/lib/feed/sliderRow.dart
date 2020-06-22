import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:final_project/add/add_goal.dart';
import 'package:final_project/add/add_reminder.dart';

import 'package:final_project/add/add_transaction.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'tabbar.dart' as Tab;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class SildeAbleRow extends StatelessWidget {
  final int id;
  final int amount;
  final String date;
  final String purpose;
  final String label;
  int nextPage;
  String deleteId;
  bool type;

  Future <http.Response> _deleteId(String route) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = pref.getString('url');
    String token = pref.getString('token');
    String uri = Uri.encodeFull(url + "/" + route + "/" + deleteId.toString());
    print(uri);
    var response = await http.delete(uri, headers: {
      'Accept': '*/*',
      'x-access-token': token
    });
    return response;
  }

  SildeAbleRow({
    @required this.id,
    @required this.amount,
    @required this.date,
    @required this.purpose,
    @required this.nextPage,
    this.label,
    this.type,
  });
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text('R'),
            foregroundColor: Colors.white,
          ),
          trailing: Text(
            date,
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
          title: Text(
            '₹ '+amount.toString(),
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            purpose,
            style: GoogleFonts.lato(
              fontSize: 15,
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () {
            if (nextPage == 2) {
              print(date+amount.toString()+purpose);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => MyReminderPage(
                    id:id.toString(),
                    dateText: date,
                    amountText: amount,
                    descriptionText: purpose,
                    enabled:"true",
                  )));
            }
            else if (nextPage == 0) {
              print(label);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => MyTransPage(
                    id:id.toString(),
                    dateText: date,
                    amountText: amount,
                    descriptionText: purpose,
                    labelText: label,
                    enabled:"true",
                  )));
            }
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            if (nextPage == 0) {
              Tab.index = 0;
              deleteId = id.toString();
              print(deleteId);
              var response = await _deleteId("transaction");
              print(response.body);
              if (response.statusCode == 200) {
                Fluttertoast.showToast(msg: "Success");
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Tab.MyTabs()));
              }
              else {
                Fluttertoast.showToast(msg: "Failed");
              }
            }
            if (nextPage == 2) {
              Tab.index = 2;
              deleteId = id.toString();
              print(deleteId);
              var response = await _deleteId("reminder");
              print(response.body);
              if (response.statusCode == 200) {
                Fluttertoast.showToast(msg: "Success");
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Tab.MyTabs()));
              }
              else {
                Fluttertoast.showToast(msg: "Failed");
              }
            }
          },
        ),
      ],
    );
  }

}

class SildeAbleRowTransaction extends StatelessWidget {
  final int id;
  final int amount;
  final String date;
  final String purpose;
  final String label;
  int nextPage;
  String deleteId;
  bool type;

  Future <http.Response> _deleteId(String route) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = pref.getString('url');
    String token = pref.getString('token');
    String uri = Uri.encodeFull(url + "/" + route + "/" + deleteId.toString());
    print(uri);
    var response = await http.delete(uri, headers: {
      'Accept': '*/*',
      'x-access-token': token
    });
    return response;
  }

  SildeAbleRowTransaction({
    @required this.id,
    @required this.amount,
    @required this.date,
    @required this.purpose,
    @required this.nextPage,
    this.label,
    @required this.type,
  });
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: type==true ?Colors.red : Colors.green[400],
            child: Text(type==true ? 'E' : 'I'),
            foregroundColor: Colors.white,
          ),
          trailing: Text(
            date,
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
          title: Text(
            '₹ '+amount.toString(),
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            purpose,
            style: GoogleFonts.lato(
              fontSize: 15,
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () {
            if (nextPage == 2) {
              print(date+amount.toString()+purpose);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => MyReminderPage(
                    id:id.toString(),
                    dateText: date,
                    amountText: amount,
                    descriptionText: purpose,
                    enabled:"true",
                  )));
            }
            else if (nextPage == 0) {
              print(label);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => MyTransPage(
                    id:id.toString(),
                    dateText: date,
                    amountText: amount,
                    descriptionText: purpose,
                    labelText: label,
                    enabled:"true",
                  )));
            }
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            if (nextPage == 0) {
              Tab.index = 0;
              deleteId = id.toString();
              print(deleteId);
              var response = await _deleteId("transaction");
              print(response.body);
              if (response.statusCode == 200) {
                Fluttertoast.showToast(msg: "Success");
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Tab.MyTabs()));
              }
              else {
                Fluttertoast.showToast(msg: "Failed");
              }
            }
            if (nextPage == 2) {
              Tab.index = 2;
              deleteId = id.toString();
              print(deleteId);
              var response = await _deleteId("reminder");
              print(response.body);
              if (response.statusCode == 200) {
                Fluttertoast.showToast(msg: "Success");
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Tab.MyTabs()));
              }
              else {
                Fluttertoast.showToast(msg: "Failed");
              }
            }
          },
        ),
      ],
    );
  }

}

// ignore: must_be_immutable
class SildeAbleRowGoal extends StatelessWidget {
  final int id;
  final int amount;
  final String date;
  final String purpose;
  final int amountAchieved;
  int nextPage;
  String deleteIdGoal;
  TextEditingController amt = TextEditingController();

  Future <http.Response> _deleteIdGoal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = pref.getString('url');
    String token = pref.getString('token');
    String uri = Uri.encodeFull(url + "/goal/" + deleteIdGoal.toString());
    print(uri);
    var response = await http.delete(uri, headers: {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'x-access-token': token
    });
    return response;
  }

  Future <http.Response> _updateGoal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = pref.getString('url');
    String token = pref.getString('token');
    String uri = Uri.encodeFull(url + "/goal");
    print(uri);
    print(id);
    var bodyEncode = json.encode({
      "id": id.toString(),
      "amount": amt.text
    });
    print(bodyEncode);
    var response = await http.put(uri, headers: {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'x-access-token': token
    }, body: bodyEncode);

    return response;
  }

  SildeAbleRowGoal({
    @required this.id,
    @required this.amountAchieved,
    @required this.amount,
    @required this.date,
    @required this.purpose,
    @required this.nextPage
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text('G'),
            foregroundColor: Colors.white,
          ),
          trailing: Text(
            date,
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
          title: Text(
            '₹ '+amountAchieved.toString() + ' out of\n' + '₹ '+ amount.toString() + " saved ",
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            purpose,
            style: GoogleFonts.lato(
              fontSize: 15,
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Add amount',
          color: Colors.green[400],
          icon: Icons.attach_money,
          onTap: () async {
            print(id);
            await _showMyDialog(context);
          },
        ),
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () {
            print(date+amountAchieved.toString()+amount.toString()+purpose);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyGoalPage(
                  id:id.toString(),
                  dateText: date,
                  amountSaveText: amountAchieved,
                  amountText: amount,
                  descriptionText: purpose,
                  enabled:"true",
                )));
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            print('Delete called');
            if (nextPage == 1) {
              Tab.index = 1;
              deleteIdGoal = id.toString();
              print(deleteIdGoal);
              var response = await _deleteIdGoal();
              print(response.body);
              if (response.statusCode == 200) {
                Fluttertoast.showToast(msg: "Success");
              }
              else {
                Fluttertoast.showToast(msg: "Failed");
              }
            }
          },
        ),
      ],
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter amount to save: '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: amt,
                  decoration: InputDecoration(
                      hintText: "Enter amount"
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () async {
                print(id);
                var response = await _updateGoal();
                print(response.body);
                if (response.statusCode == 200) {
                  Fluttertoast.showToast(msg: "Success");
                }
                else {
                  Fluttertoast.showToast(msg: "Failure");
                }
                Tab.index = 2;
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Tab.MyTabs()));
              },
            ),
          ],
        );
      },
    );
  }
}