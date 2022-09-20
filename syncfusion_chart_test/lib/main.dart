import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 550,
              child: SfCartesianChart(
                // annotations: [
                //   CartesianChartAnnotation(x: )
                // ],
                series: <ChartSeries>[
                  LineSeries<SalesData, int>(
                    dataSource: getHugeData(),
                    xValueMapper: (SalesData sales, _) => sales.x,
                    yValueMapper: (SalesData sales, _) => sales.y,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      color: Colors.blue[900],
                    ),
                    // dataLabelSettings:
                    //     DataLabelSettings(alignment: ChartAlignment.far),
                  ),
                  SplineAreaSeries<SalesData, int>(
                    dataSource: getHugeData(),
                    xValueMapper: (SalesData sales, _) => sales.x,
                    yValueMapper: (SalesData sales, _) => sales.y,
                    color: HexColor('#BBE4FC'),
                  )
                ],
                primaryXAxis: CategoryAxis(
                    autoScrollingMode: AutoScrollingMode.start,
                    maximumLabels: 32,
                    autoScrollingDelta: 16,
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(width: 0),
                    labelAlignment: LabelAlignment.center),
                primaryYAxis: NumericAxis(
                  minimum: 1.0,
                  majorGridLines: const MajorGridLines(
                    width: 0,
                  ),
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                  enableSelectionZooming: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SalesData {
  int y;
  int x;
  SalesData(this.x, this.y);
  @override
  String toString() {
    // TODO: implement toString
    return '($x, $y)';
  }
}

dynamic getHugeData() {
  List<SalesData> hugeData = <SalesData>[];
  Random rand = Random();

  for (int i = 0; i < 33; i++) {
    hugeData.add(
      SalesData(i, 10 + rand.nextInt(40)),
    );
  }

  print(hugeData.toString());

  return hugeData;
}
