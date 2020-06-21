import 'package:final_project/add/add_goal.dart';
import 'package:final_project/add/add_reminder.dart';
import 'package:final_project/add/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
class PlusButton extends StatelessWidget {
  const PlusButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      overlayColor: Colors.blueGrey,
      overlayOpacity: 0.4,
      curve: Curves.fastLinearToSlowEaseIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.attach_money),
          label: "Add Transaction",
          backgroundColor: Colors.greenAccent,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyTransPage())).then((status)
            {

            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.outlined_flag),
          label: "Add Goal",
          backgroundColor: Colors.redAccent,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyGoalPage()));
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.add_alert),
          label: "Add Reminder",
          backgroundColor: Colors.yellow,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyReminderPage()));
          },
        )
      ],
    );
  }
}
