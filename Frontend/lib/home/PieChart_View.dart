import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './PieChart.dart';

class PieChartView extends StatelessWidget {
  const PieChartView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: LayoutBuilder(
        builder: (context, constraint) => Container(
//              decoration: BoxDecoration(
////                color:Colors.blueGrey,
//                color: Color.fromRGBO(193, 214, 233, 1),
//                shape: BoxShape.circle,
//                boxShadow: [
//                  BoxShadow(
//                    spreadRadius: -10,
//                    blurRadius: 17,
//                    offset: Offset(-5, -5),
//                    color: Colors.white,
//                  ),
//                  BoxShadow(
//                    spreadRadius: -2,
//                    blurRadius: 10,
//                    offset: Offset(7, 7),
//                    color: Color.fromRGBO(146, 182, 216, 1),
//                  )
//                ],
//              ),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: constraint.maxWidth * 0.7,
                  child: CustomPaint(
                    child: Center(),
                    foregroundPainter: PieChart(
                      width: constraint.maxWidth * 0.5,
                      categories: kCategories,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: constraint.maxWidth * 0.5,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(193, 200, 233, 1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        offset: Offset(-1, -1),
                        color: Colors.lightBlue,
                      ),
                      BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: Offset(2, 5),
                        color: Colors.black.withOpacity(0.5),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Rs. 5080.00',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue,
                          ),

                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Rs 3000.00',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromRGBO(200, 0, 0, 0.5)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
