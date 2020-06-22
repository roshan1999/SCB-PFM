import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import './graph.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphData();
  }
}

class GraphData extends StatelessWidget {
  final List<SubscriberSeries> data = [
    SubscriberSeries(
      year: "jan",
      subscribers: 10000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "feb",
      subscribers: 11000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "Mar",
      subscribers: 12000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "Apr",
      subscribers: 10000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "May",
      subscribers: 8500000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: SubscriberChart(
          data: data,
        ),
      ),
    );
  }
}