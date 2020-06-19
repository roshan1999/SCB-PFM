import 'package:final_project/home/HomePage.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Notify extends StatelessWidget {
  final int id;
  final int amount;
  final DateTime date;
  final String purpose;
  Notify(
      {@required this.id,
      @required this.amount,
      @required this.date,
      @required this.purpose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.fromLTRB(3, 5, 0, 0),
      child: Text(
        'You have a reminder pending of \"' + purpose +" " + amount.toString() + '\" on ' +date.day.toString() +'-'+ date.month.toString(),
        style: GoogleFonts.lato(
          fontSize: 18,
          color: Colors.lightBlueAccent,
        ),
      ),
    );
  }
}

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  // This widget is the root of your application.
  List data = [];
  String token;
  String url;
  var isLoading = true;
  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    token = prefs.getString('token');
    var response = await http
        .get(Uri.encodeFull(url + "/notification/reminder"), headers: {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'x-access-token': token
    });
    this.setState(() {
      debugPrint("abc");
      print(response.statusCode);
      data = json.decode(response.body);
      return (response.body);
    });
    isLoading = false;
    print(response.body);
    return "Success";
  }

  void initState() {
    debugPrint("Test");
    this.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications' ,
        style: GoogleFonts.lato(
          fontSize: 24,
        ),
      ),),
      body: !isLoading
          ? RefreshIndicator(
              child: new ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int ind) {
                  return new Card(
                    child: Notify(
                      id: data[ind]['id'],
                      amount: data[ind]['amount'],
                      date: DateTime.parse(data[ind]['due_date']),
                      purpose: data[ind]['description'],
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

//Two types of notifications in the feed : Locations(add transaction) & Alert

// class NotificationCard {
//   // This is location(add transaction)
//   // int flag; //0=> Alert, 1=> LocationNotification
//   int placesBehind; // places visited or behind_value
//   String dateGoal; // date or goal name
//   NotificationCard({this.placesBehind, this.dateGoal});
// }

// class NotificationNAlerts extends StatefulWidget {
//   @override
//   _NotificationNAlertsState createState() => _NotificationNAlertsState();
// }

// class _NotificationNAlertsState extends State<NotificationNAlerts> {
//   List<NotificationCard> notifications = [
//     NotificationCard( dateGoal: 'iPad Pro', placesBehind: 7000),
//     NotificationCard( placesBehind: 11, dateGoal: '11th May'),
//   ];

//   Widget notificationTemplate(noti) {
//     if (noti.flag == 1) {
//       return InkWell(
//         onTap: () {
//           Navigator.push(
//               context,
//               new MaterialPageRoute(
//                   builder: (context) => DailyLocationPlaces()));
//         },
//         child: Card(
//             color: Colors.green[50],
//             child: Row(
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.place),
//                   color: Colors.blue,
//                   onPressed: () {},
//                 ),
//                 Text(
//                   'You visited ${noti.placesBehind} places on ${noti.dateGoal}',
//                 )
//               ],
//             )),
//       );
//     } else {
//       return InkWell(
//         onTap: () {},
//         child: Card(
//             color: Colors.green[50],
//             child: Row(
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.warning),
//                   color: Colors.red,
//                   onPressed: () {},
//                 ),
//                 Text(
//                   'You are ₹${noti.placesBehind} behind for Goal : ${noti.dateGoal}',
//                 )
//               ],
//             )),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text('Notifications'),
//       ),
//       body: Column(
//         children:
//             notifications.map((noti) => notificationTemplate(noti)).toList(),
//       ),
//       floatingActionButton: PlusButton(),
//     );
//   }
// }
