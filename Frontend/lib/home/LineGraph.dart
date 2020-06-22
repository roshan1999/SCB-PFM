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

var isLoading = true;

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  List final_data_expense, final_data_income;
  @override
  void initState() {
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
    var response = await http.get(Uri.encodeFull(url + "/linegraph"), headers: {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'x-access-token': token
    });
    this.setState(() {
      print('setstate');
      final_data_expense = json.decode(response.body)['amount'];
      final_data_income = json.decode(response.body)['amount1'];
      print(response.body);
      isLoading = false;
    });
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading ? chart() : Center(child: CircularProgressIndicator());
  }

  Widget chart() {
    var today = DateTime.now();
    var i = 0;
    List<TimeSeriesSales> tsdata_expense = [],
        tsdata_income = [],
        tsdata_saving = [];
    if (final_data_expense != null) {
      print(final_data_expense);
      for (int m in final_data_expense) {
        print(i);
        try {
          tsdata_expense.add(
              new TimeSeriesSales(DateTime(today.year, today.month - i), m));
        } catch (e) {
          print(e.toString());
        }
        i++;
      }
    } else {
      tsdata_expense.add(new TimeSeriesSales(DateTime(today.month), 0));
    }
    today = DateTime.now();
    i = 0;
    if (final_data_income != null) {
      print(final_data_income);
      for (int m in final_data_income) {
        print(i);
        try {
          tsdata_income.add(
              new TimeSeriesSales(DateTime(today.year, today.month - i), m));
        } catch (e) {
          print(e.toString());
        }
        i++;
      }
    } else {
      tsdata_income.add(new TimeSeriesSales(DateTime(today.month), 0));
    }
    for (int i = 0; i < tsdata_income.length; i++) {
      try{
      var save = final_data_income[i] - final_data_expense[i];
      if (save < 0) save = 0;

         tsdata_saving.add(
             new TimeSeriesSales(DateTime(today.year, today.month - i), save));
       }
        catch(e){
         print(e.toString());
        }
    }
    var final_Series = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Expense',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        // labelAccessorFn: (TimeSeriesSales , _) => ,
        data: tsdata_expense,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Income',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        // labelAccessorFn: (TimeSeriesSales , _) => ,
        data: tsdata_income,
      ),

      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Savings',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        // labelAccessorFn: (TimeSeriesSales , _) => ,
        data: tsdata_saving,
      )
    ];
    var ans = new charts.TimeSeriesChart(
      final_Series,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        new charts.SeriesLegend(
          position : charts.BehaviorPosition.inside,
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: true,
          desiredMaxRows: 3,
          cellPadding: new EdgeInsets.only(left : 30 ,top : 2 , bottom: 1.0),
          entryTextStyle: charts.TextStyleSpec(
              color: charts.Color.black,
              fontFamily: 'Georgia' ,
              fontSize: 11
          ),
        )
      ],
    );
    return ans;
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}