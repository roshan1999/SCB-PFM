import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            Text(
              "Welcome To",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Personal Finance Manager App",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.indigo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
