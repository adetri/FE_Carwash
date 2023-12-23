import 'dart:io';

import 'package:MrCarwash/env.dart';
import 'package:MrCarwash/page/checking.dart';
import 'package:MrCarwash/page/login.dart';
import 'package:MrCarwash/page/main_menu.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

int get_user_id(jwt) {
  String jwtToken = '$jwt'; // Replace this with your actual JWT token
  dynamic userId;
  Map<String, dynamic> decodedToken = Jwt.parseJwt(jwtToken);

  if (decodedToken != null && decodedToken.containsKey('user_id')) {
    userId = decodedToken['user_id'];
  } else {
    print('Invalid token or no user ID found in the token.');
  }
  return userId;
}

BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

String formatCurrency(int amount) {
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  String result = currencyFormat.format(amount);
  List<String> substrings = result.split(',');
  return substrings[0];
}

class MyDialogHelper {
  static String? title;
  static String? content;
  static dynamic page;

  static void showDialogMethod(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? ''),
          content: Text(content ?? ''),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (page != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                }
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class MyConfrimDialog {
  static String? title;
  static String? content;
  static dynamic page;

  static void Function()? logic;

  static void showDialogMethod(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? ""),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content ?? ""),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes
                if (logic != null) {
                  logic!(); // Execute the logic function
                }
                if (page != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                }
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

Future<int> printerCheck() async {
  bool? isConnected = await bluetooth.isConnected;
  if (isConnected == true) {
    print("Bluetooth is connected");
    return 1;
  } else {
    print("Bluetooth is not connected");
    return 0;
  }
}

void checkDataType(dynamic data) {
  if (data is int) {
    print('Data is an integer.');
  } else if (data is double) {
    print('Data is a double.');
  } else if (data is String) {
    print('Data is a string.');
  } else {
    print('Data is of some other type.');
  }
}

void to_login(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Login()),
  );
}

void nav_to(BuildContext context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void closeApp() {
  exit(0);
}

void req_validation(BuildContext context, status_code) {
  if (status_code == 401) {
    MyDialogHelper.title = "";
    MyDialogHelper.content = "Session expired";
    MyDialogHelper.page = Login();
    MyDialogHelper.showDialogMethod(context);
  }
}

double HeighMediaQuery(BuildContext context, double ascpect) {
  var height = MediaQuery.of(context).size.height * ascpect;

  return height;
}

double WidthMediaQuery(BuildContext context, double ascpect) {
  var width = MediaQuery.of(context).size.width * ascpect;

  return width;
}

void logic_dialog(BuildContext context,
    {String? title, String? content, dynamic page, void Function()? logic}) {
  MyConfrimDialog.title = title;
  MyConfrimDialog.content = content;
  MyConfrimDialog.page = page;
  MyConfrimDialog.logic = logic;
  MyConfrimDialog.showDialogMethod(context);
}

void request_failed(BuildContext context, e) {
  MyDialogHelper.title = "Request Error";
  MyDialogHelper.content = e;
  MyDialogHelper.page = CheckingPage();
  MyDialogHelper.showDialogMethod(context);
}

void show_dialog(BuildContext context, title, content) {
  MyDialogHelper.title = title;
  MyDialogHelper.content = content;
  MyDialogHelper.showDialogMethod(context);
}

void showDialogAndMove(BuildContext context, title, content, page) {
  MyDialogHelper.title = title;
  MyDialogHelper.content = content;
  MyDialogHelper.page = page;

  MyDialogHelper.showDialogMethod(context);
}

void dbg(object) {
  if (DEBUG == true) {
    print(object);
  }
}

Row headerPage(context, prev_page, title) {
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          // Handle back button tap
          nav_to(context, prev_page);
        },
        child: Container(
          height: 50,
          alignment: Alignment.topLeft,
          child: Image.asset('assets/back.png'),
        ),
      ),
      SizedBox(width: 10),
      Text(
        title.toString(),
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Expanded(
      //   child: Text(
      //     karyawan_name.toString(),
      //     style: TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //     textAlign: TextAlign.right,
      //   ),
      // ),
    ],
  );
}

class LoadingSc extends StatelessWidget {
  const LoadingSc({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        size: 200,
        color: Colors.blue,
      ),
    );
  }
}

bool canAccess(role, {kasir = false, management = false, owner = false}) {
  if (role['is_dev'] == true) {
    return true;
  }

  if (kasir == true && role['is_cashier'] == true) {
    return true;
  } else if (management == true && role['is_management'] == true) {
    return true;
  } else if (owner == true && role['is_owner']) {
    return true;
  } else {
    return false;
  }
}
