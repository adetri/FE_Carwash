import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
                  onTap: () {},
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
                          "Category",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(16.0),
              //   child: GestureDetector(
              //     onTap: () {},
              //     child: Container(
              //       alignment: Alignment.center,
              //       height: 200,
              //       width: 200,
              //       padding: EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //         color: const Color.fromARGB(255, 207, 204, 203),
              //       ),
              //       child: Column(
              //         children: [
              //           Image.asset('assets/setting.png'),
              //           Padding(padding: EdgeInsets.only(top: 10)),
              //           Text(
              //             "SettingS",
              //             style: TextStyle(fontWeight: FontWeight.w600),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(16.0),
              //   child: GestureDetector(
              //     onTap: () {},
              //     child: Container(
              //       alignment: Alignment.center,
              //       height: 200,
              //       width: 200,
              //       padding: EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //         color: const Color.fromARGB(255, 207, 204, 203),
              //       ),
              //       child: Column(
              //         children: [
              //           Image.asset('assets/setting.png'),
              //           Padding(padding: EdgeInsets.only(top: 10)),
              //           Text(
              //             "SettingS",
              //             style: TextStyle(fontWeight: FontWeight.w600),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
