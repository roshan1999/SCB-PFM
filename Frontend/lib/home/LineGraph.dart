import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SimpleTimeSeriesChart extends StatefulWidget {
  @override
  _SimpleTimeSeriesChartState createState() => _SimpleTimeSeriesChartState();
}

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  List final_data;
  @override
    void initState(){
      print('abc');
      this.makeRequest();
      super.initState();
    }
  Future<String> makeRequest() async {
    String url;
    String token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    print(url);
    token = prefs.getString('token');
    var response = await http.get(
        Uri.encodeFull(url+ "/linegraph"), headers: {
    'Content-type': 'application/json',
    'Accept': '*/*',
    'x-access-token': token
    });
    this.setState(() {
      print('setstate');
      final_data = json.decode(response.body)['amount'];
      print(response.body);
    });
    return response.body;
  }
  @override
  Widget build(BuildContext context){
    return chart();
  }
  Widget chart(){
    var today = DateTime.now();
    var i=0;
    List<TimeSeriesSales> tsdata = [];
    if(final_data!=null){
    print(final_data);
    for(int m in final_data){
      print(i);
      try {
        tsdata.add(new TimeSeriesSales(DateTime(today.year ,today.month -i) , m));
      } 
      catch (e) {
        print(e.toString());
      }
      i++; 
    }
    }
    else {
      tsdata.add(new TimeSeriesSales(DateTime(today.month), 20));
    }
    var final_Series=[
      new charts.Series<TimeSeriesSales, DateTime>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimeSeriesSales sales, _) => sales.time,
      measureFn: (TimeSeriesSales sales, _) => sales.sales,
      data: tsdata,
    )
  ];
  var ans= new charts.TimeSeriesChart(
  final_Series,
  animate: true,
  dateTimeFactory: const charts.LocalDateTimeFactory(),);
  return ans;
  }

}
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
