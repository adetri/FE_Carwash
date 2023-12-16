import 'dart:math';

import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/component/header.dart';
import 'package:MrCarwash/page/component/horizontal_month_scroll.dart';
import 'package:MrCarwash/page/main_menu.dart';
import 'package:MrCarwash/page/report/menu_report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportChart extends StatelessWidget {
  ReportChart({super.key});
  var header = MyHeader(prev_page: ReportMenu(), title: "Report Chart");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(children: [
          header,
          SizedBox(height: 50),
          MyReportChart(),
        ]),
      ),
    );
  }
}

class MyReportChart extends StatefulWidget {
  const MyReportChart({super.key});

  @override
  State<MyReportChart> createState() => _MyReportChartState();
}

class _MyReportChartState extends State<MyReportChart> {
  List<_ChartData> data = [];
  TooltipBehavior? _tooltip;
  Req? req;
  HorizontalDate tanggal = HorizontalDate();
  Random random = Random();
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    dbg("object exec");
    req = Req(context);
    await req?.init();
    Map<String, dynamic>? req_monthly_record = await req?.fetchChartReport();
    for (var req_month in req_monthly_record?['response']['monthly_recod']) {
      dbg(req_month[0]);
      dbg(req_month[1]);

      setState(() {
        data.add(_ChartData(req_month[0].toString(), (req_month[1])));
      });
    }
    _tooltip = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        tanggal,
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: "Monthly Sales"),
          // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
          tooltipBehavior: _tooltip,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y.toDouble(),
                name: 'Sales',
                color: Color.fromRGBO(8, 142, 255, 1)),
          ],
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
