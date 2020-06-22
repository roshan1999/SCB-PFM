import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './Categories_row.dart';
import 'PieChart_View.dart';

class MonthlyExpensesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 10, 0.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Monthly Expenses',
              style:
                  GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
