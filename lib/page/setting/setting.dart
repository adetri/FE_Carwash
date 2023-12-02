import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/page/setting/category/category.dart';
import 'package:MrCarwash/page/setting/item/item.dart';
import 'package:MrCarwash/page/main_menu.dart';
import 'package:MrCarwash/page/setting/spot/spot.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          header(context),
          SizedBox(
            height: 50,
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
                    nav_to(context, CategoryList());
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
                          'assets/category.png',
                          height: 100,
                          width: 100,
                        ),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: GestureDetector(
                  onTap: () {
                    nav_to(context, ItemList());
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
                          'assets/items.png',
                          height: 100,
                          width: 100,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          "Item",
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
                    nav_to(context, SpotList());
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
                          'assets/spot.png',
                          height: 100,
                          width: 100,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          "Spot",
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

  Widget header(context) {
    print("this exec");
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Handle back button tap
            nav_to(context, Mainmenu());
          },
          child: Container(
            height: 50,
            alignment: Alignment.topLeft,
            child: Image.asset('assets/back.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Setting',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
