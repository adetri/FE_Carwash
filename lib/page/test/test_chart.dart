// import 'package:MrCarwash/inc/method.dart';
// import 'package:MrCarwash/inc/req.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'dart:math';

// class Chart extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   Chart({Key? key}) : super(key: key);

//   @override
//   ChartState createState() => ChartState();
// }

// class ChartState extends State<Chart> {
//   late List<_ChartData> data;
//   late TooltipBehavior _tooltip;
//   Random random = Random();
//   Req? req;
//   @override
//   void initState() {
//     data = [];
//     for (int i = 1; i <= 30; i++) {
//       int randomNumber = random.nextInt(900000) +
//           100000; // Generates a random int between 100000 and 999999
//       data.add(_ChartData(i.toString(), (randomNumber + i)));
//     }
//     _tooltip = TooltipBehavior(enable: true);
//     init();
//     super.initState();
//   }

//   void init() async {
//     dbg("object exec");
//     req = Req(context);
//     await req?.init();
//     Map<String, dynamic>? req_monthly_record = await req?.fetchChartReport();

//     dbg("data req : $req_monthly_record");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Syncfusion Flutter chart'),
//         ),
//         body: SfCartesianChart(
//             primaryXAxis: CategoryAxis(),
//             // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
//             tooltipBehavior: _tooltip,
//             series: <ChartSeries<_ChartData, String>>[
//               ColumnSeries<_ChartData, String>(
//                   dataSource: data,
//                   xValueMapper: (_ChartData data, _) => data.x,
//                   yValueMapper: (_ChartData data, _) => data.y,
//                   name: 'Sales',
//                   color: Color.fromRGBO(8, 142, 255, 1))
//             ]));
//   }
// }

// class _ChartData {
//   _ChartData(this.x, this.y);

//   final String x;
//   final int y;
// }
