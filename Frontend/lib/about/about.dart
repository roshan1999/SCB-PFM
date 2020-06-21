import 'package:final_project/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sidebar.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData _query=MediaQuery.of(context);
    return Scaffold(
      drawer: ActiveSideBar(),
      appBar: AppBar(title: Text('About the app')),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
              .01 * _query.size.width, .01 * _query.size.height, 0, 0),
          child: Column(
            children: <Widget>[
              Text(
                "Hi! Welcome to SCB's Personal Finance Manager App , Let's have a quick overview of the application",
                style: GoogleFonts.lato(
                  fontSize: 22,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, .01 *_query.size.height, 0, 0),
                child: Text(
                  "Manage your saving for different purposes with us",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          )),
    );
  }
}
