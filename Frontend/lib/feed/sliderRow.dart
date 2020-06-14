import 'package:final_project/add/add_goal.dart';
import 'package:final_project/add/add_reminder.dart';

import 'package:final_project/add/add_transaction.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';


class SildeAbleRow extends StatelessWidget {
  final int amount;
  final String date;
  final String purpose;

  SildeAbleRow({
    @required this.amount,
    @required this.date,
    @required this.purpose,
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
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyReminderPage()));
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

class SildeAbleRowTransaction extends StatelessWidget {
  final int amount;
  final String date;
  final String purpose;

  SildeAbleRowTransaction({
    @required this.amount,
    @required this.date,
    @required this.purpose,
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
  final int amount;
  final String date;
  final String purpose;
  final int amountAchieved;

  SildeAbleRowGoal({
    @required this.amountAchieved,
    @required this.amount,
    @required this.date,
    @required this.purpose,
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
          onTap: null,
        ),
      ],
    );
  }
}
