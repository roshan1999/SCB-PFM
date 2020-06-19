import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './PieChart.dart';
import 'package:http/http.dart' as http;
var isLoading = true;
class PieChartView extends StatefulWidget {
  const PieChartView({
    Key key,
  }) : super(key: key);

  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  List Data = [];
  List <Category> myCategories = [];
  String expense;
  String income;
  Future getCategory() async {
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    String uri = Uri.encodeFull(url + "/category");
    String token = prefs.getString('token');
    print(uri);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-access-token': token,
    };
    var response = await http.get(uri, headers: headers);
    this.setState(() {
      Data = json.decode(response.body);
      print(Data);
      print("HERE");
      isLoading = false;
      double amountexpense =0;
      double amountincome =0;

      for(int i =0;i<Data.length;i++){
        if(Data[i]["cat_type"]==true){
          myCategories.add(Category(Data[i]["label"], amount: double.parse(Data[i]["amount"].toString())));
          amountexpense +=  double.parse(Data[i]["amount"].toString()) ;
        }
        else{
          amountincome += double.parse(Data[i]["amount"].toString());
        }
      }
      kCategories = myCategories;
      expense = amountexpense.toString();
      income  = amountincome.toString();
    });
  }
  @override
  void initState(){
    this.getCategory();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Expanded(
      flex: 4,
      child: !isLoading?
      LayoutBuilder(
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
                      categories: myCategories,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Center(
                          child: Text('Expense:',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text('Rs. ' +expense,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: Text(
                          'Income:',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromRGBO(200, 0, 0, 0.5)
                          ),
                        ),
                      ),
                      Center(
                        child: Text('Rs. '+income,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromRGBO(200, 0, 0, 0.5),
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
      ):
      Center(child: CircularProgressIndicator()),

    );
  }
}
