import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';

List<charts.Series<TimeSeriesSales, DateTime>> createSampleData() {
  final data = [
    new TimeSeriesSales(new DateTime(2020, 1, 31), 20),
    new TimeSeriesSales(new DateTime(2020, 2, 31), 25),
    new TimeSeriesSales(new DateTime(2020, 3, 31), 20),
    new TimeSeriesSales(new DateTime(2020, 4, 31), 30),
    new TimeSeriesSales(new DateTime(2020, 5, 31), 50),
    new TimeSeriesSales(new DateTime(2020, 6, 31), 45),
  ];

  return [
    new charts.Series<TimeSeriesSales, DateTime>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimeSeriesSales sales, _) => sales.time,
      measureFn: (TimeSeriesSales sales, _) => sales.sales,
      data: data,
    )
  ];
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      createSampleData(),
      animate: false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
