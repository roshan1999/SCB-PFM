import 'package:flutter/material.dart';

import './location/location_list.dart';

//Two types of notifications in the feed : Locations(add transaction) & Alert

class NotificationCard{     // This is location(add transaction)
  int flag ; //0=> Alert, 1=> LocationNotification 
  int placesBehind;   // places visited or behind_value
  String dateGoal;     // date or goal name
  NotificationCard({this.flag,this.placesBehind,this.dateGoal});
}

class NotificationNAlerts extends StatefulWidget {
  @override
  _NotificationNAlertsState createState() => _NotificationNAlertsState();
}

class _NotificationNAlertsState extends State<NotificationNAlerts> {
  List<NotificationCard> notifications = [
    NotificationCard(flag: 0,dateGoal: 'iPad Pro',placesBehind: 7000),
    NotificationCard(flag: 1,placesBehind: 11, dateGoal:'11th May'),
  ];

  Widget notificationTemplate(noti){
    if(noti.flag==1){
      return InkWell(onTap: (){
        Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => DailyLocationPlaces()
                  ));
      },
              child: Card(
        color: Colors.green[50],
        child:Row(
          children: <Widget>[
            IconButton(
                    icon: Icon(Icons.place),
                    color: Colors.blue,
                    onPressed: (){

                    },
                  ),
            Text(
              'You visited ${noti.placesBehind} places on ${noti.dateGoal}',
            )
          ],
        )
    ),
      );
    }
    else{
      return InkWell(onTap: (){

      },
              child: Card(
        color: Colors.green[50],
        child:Row(
          children: <Widget>[
            IconButton(
                    icon: Icon(Icons.warning),
                    color: Colors.red,
                    onPressed: (){

                    },
                  ),
            Text(
              'You are ₹${noti.placesBehind} behind for Goal : ${noti.dateGoal}',
            )
          ],
        )
    ),
      );
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Notifications'
        ),
      ),
      body: Column(
        children: notifications.map((noti)=>notificationTemplate(noti)).toList(),
      ),
    );
  }
}