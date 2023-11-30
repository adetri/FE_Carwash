import 'package:flutter/material.dart';
import 'package:flutter_application_1/env.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:flutter_application_1/page/monitoring_page.dart';
import 'package:flutter_application_1/page/report.dart';
import 'package:flutter_application_1/page/setting.dart';

class Mainmenu extends StatefulWidget {
  const Mainmenu({super.key});

  @override
  State<Mainmenu> createState() => _MainmenuState();
}

class _MainmenuState extends State<Mainmenu> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
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
                      print("tab this");

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Monitoring()),
                      );
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 207, 204, 203),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/washservice.png'),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          "Wash Service",
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
                    setState(() {
                      print("tab this");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Report()),
                      );
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 207, 204, 203),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/report.png'),
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
                      color: const Color.fromARGB(255, 207, 204, 203),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/setting.png'),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          "Setting",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
