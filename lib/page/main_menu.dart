import 'package:MrCarwash/inc/db.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/login.dart';
import 'package:MrCarwash/page/report/menu_report.dart';
import 'package:flutter/material.dart';
import 'package:MrCarwash/env.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/page/wash_service/monitoring_page.dart';
import 'package:MrCarwash/page/report/report.dart';
import 'package:MrCarwash/page/setting/setting.dart';

class Mainmenu extends StatefulWidget {
  const Mainmenu({super.key});

  @override
  State<Mainmenu> createState() => _MainmenuState();
}

class _MainmenuState extends State<Mainmenu> {
  DatabaseHelper db = DatabaseHelper();
  Req? req;
  Map<String, dynamic>? role;
  @override
  bool load_page = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    req = Req(context);
    await req?.init();
    var req_role = await req?.getRole();

    setState(() {
      role = req_role?['response'];
      load_page = true;
    });
  }

  void logout() async {
    var logout = db.logoutSeason();
    dbg("log out is : $logout");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: load_page
            ? SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: HeighMediaQuery(
                            context, 0.5), // Adjust the height as needed
                        alignment: Alignment.center,
                        child: Image.asset('assets/logo.png'),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Monitoring()),
                                  );
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 207, 204, 203),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset('assets/washservice.png'),
                                    Padding(padding: EdgeInsets.only(top: 10)),
                                    Text(
                                      "Wash Service",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          canAccess(role, management: true, owner: true)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        print("tab this");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportMenu()),
                                        );
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 207, 204, 203),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/report.png'),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          Text(
                                            "Report",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          canAccess(role!, owner: true, management: true)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        nav_to(context, Settings());
                                      });
                                      // setState(() {
                                      //   print("tab this");
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(builder: (context) => Report()),
                                      //   );
                                      // });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 200,
                                      width: 200,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 207, 204, 203),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/setting.png'),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          Text(
                                            "Setting",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: GestureDetector(
                              onTap: () async {
                                MyConfrimDialog.title = "Logout";
                                MyConfrimDialog.content =
                                    "Are you sure Logout ?";
                                MyConfrimDialog.page = Login();
                                MyConfrimDialog.logic = logout;
                                MyConfrimDialog.showDialogMethod(context);

                                // nav_to(context, KaryawanList());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 200,
                                width: 200,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 207, 204, 203),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/setting.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10)),
                                    Text(
                                      "Log Out",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink());
  }
}
