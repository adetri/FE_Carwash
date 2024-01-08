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
  late HorizontalDate tanggal;
  bool is_visible = false;
  bool ignore_date = true;
  Random random = Random();

  late int monthly_total_order;
  late int monthly_total;
  late int total_daily;
  late int total_daily_order;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    tanggal = HorizontalDate(
      callback: change_date,
    );
    dbg("object exec");
    req = Req(context);
    await req?.init();
    change_date();
  }

  void change_date() async {
    setState(() {
      is_visible = false;
      ignore_date = true;
    });
    await tanggal.value;
    setState(() {
      data = [];
      tanggal.value;
    });
    dbg(tanggal.value);
    Map<String, dynamic>? req_monthly_record = await req?.fetchChartReport(
        tanggal.value['year'],
        tanggal.value['month_int'],
        tanggal.value['day']);

    monthly_total_order =
        req_monthly_record?['response']['monthly_total_order'];
    monthly_total = req_monthly_record?['response']['monthly_total'];
    total_daily = req_monthly_record?['response']['total_today'];
    total_daily_order = req_monthly_record?['response']['total_today_order'];

    dbg(req_monthly_record);
    for (var req_month in req_monthly_record?['response']['monthly_recod']) {
      // dbg(req_month[0]);
      // dbg(req_month[1]);

      setState(() {
        data.add(_ChartData(req_month[0].toString(), (req_month[1])));
      });
    }
    if (req_monthly_record?['response'] == 200) {
      setState(() {});
    }
    setState(() {
      is_visible = true;
      ignore_date = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          IgnorePointer(
            ignoring: ignore_date,
            child: tanggal,
          ),
          is_visible == true
              ? SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: "Monthly Sales"),
                  // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_ChartData, String>>[
                    ColumnSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y.toDouble(),
                        name: 'Sales',
                        color: Color.fromRGBO(8, 142, 255, 1)),
                  ],
                )
              : SizedBox.shrink(),
          is_visible == true
              ? Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.center,
                              width: 50, // Adjust width as needed
                              child: Icon(Icons.article_outlined),
                            ),
                            title: Text(
                              'Total Monthly Order',
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              monthly_total_order.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.center,
                              width: 50, // Adjust width as needed
                              child: Icon(Icons.attach_money_outlined),
                            ),
                            title: Text(
                              'Total Monthly Revenue',
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              formatCurrency(monthly_total),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
          is_visible == true
              ? Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.center,
                              width: 50, // Adjust width as needed
                              child: Icon(Icons.article_outlined),
                            ),
                            title: Text(
                              'Total Daily Order',
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              total_daily_order.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.center,
                              width: 50, // Adjust width as needed
                              child: Icon(Icons.attach_money_outlined),
                            ),
                            title: Text(
                              'Total Daily Revenue',
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              formatCurrency(total_daily),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
