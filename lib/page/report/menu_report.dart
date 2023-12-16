import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/page/component/header.dart';
import 'package:MrCarwash/page/main_menu.dart';
import 'package:MrCarwash/page/report/report.dart';
import 'package:MrCarwash/page/report/report_chart.dart';
import 'package:MrCarwash/page/setting/setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReportMenu extends StatelessWidget {
  ReportMenu({super.key});
  var header = MyHeader(prev_page: Mainmenu(), title: "Report");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          children: [
            header,
            SizedBox(height: 50),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: GestureDetector(
                    onTap: () {
                      nav_to(context, Report());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 200,
                      width: 200,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 207, 204, 203),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/report.png',
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text(
                            "Report",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: GestureDetector(
                    onTap: () {
                      nav_to(context, ReportChart());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 200,
                      width: 200,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 207, 204, 203),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/report.png',
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text(
                            "Chart",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )

            // MyKaryawanForm(
            //   id_karyawan: id_karyawan,
            // ),

            // header(context),
            // SizedBox(height: 25),
            // CatForm(id_category: id_category),
          ],
        ),
      ),
    );
  }
}
