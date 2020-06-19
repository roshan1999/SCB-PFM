import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './Categories_row.dart';
import 'PieChart_View.dart';

class MonthlyExpensesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return  SizedBox(
                height: height * 0.5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0,10,25.0,100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Monthly Expenses',
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            CategoriesRow(),
                            PieChartView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}