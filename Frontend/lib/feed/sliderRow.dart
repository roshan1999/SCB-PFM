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
  int nextPage;
  String deleteId;

  Future <http.Response> _deleteId () async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = pref.getString('url');
    String token = pref.getString('token');
    String uri = Uri.encodeFull(url + "/reminder/" + deleteId.toString());
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
            amount.toString(),
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
            if (nextPage ==0){
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => MyTransPage()));
            }
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            if (nextPage ==2){
              Tab.index = 2;
              deleteId = id.toString();
              print(deleteId);
              var response = await _deleteId();
              print(response.body);
                if(response.statusCode == 200){
                  Fluttertoast.showToast(msg:"Success");
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Tab.MyTabs()));
                }
                else{
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
  int nextPage;

  SildeAbleRowTransaction({
    @required this.id,
    @required this.amount,
    @required this.date,
    @required this.purpose,
    @required this.nextPage,
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
            amount.toString(),
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
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => MyTransPage(),
              ),
            );
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: null,
        ),
      ],
    );
  }
}

class SildeAbleRowGoal extends StatelessWidget {
  final int id;
  final int amount;
  final String date;
  final String purpose;
  final int amountAchieved;
  int nextPage;
  String deleteIdGoal;

   Future <http.Response> _deleteIdGoal () async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = pref.getString('url');
    String token = pref.getString('token');
    String uri = Uri.encodeFull(url + "/goal/" + deleteIdGoal.toString());
    print(uri);
    var response = await http.delete(uri, headers: {
      'Accept': '*/*',
      'x-access-token': token
    });
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
            amountAchieved.toString() + '/' + amount.toString(),
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
          onTap: null,
        ),
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyGoalPage()));
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            print('Delete called');
            if (nextPage ==1){
              Tab.index = 1;
              deleteIdGoal = id.toString();
              print(deleteIdGoal);
              var response = await _deleteIdGoal();
              print(response.body);
                if(response.statusCode == 200){
                  Fluttertoast.showToast(msg:"Success");
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Tab.MyTabs()));
                }
                else{
                  Fluttertoast.showToast(msg: "Failed");
                }
            }
          },
        ),
      ],
    );
  }
}
