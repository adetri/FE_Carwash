import 'package:flutter_application_1/env.dart';
import 'package:flutter_application_1/page/login.dart';
import 'package:flutter_application_1/page/main_menu.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:jwt_decode/jwt_decode.dart';

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

void req_validation(BuildContext context, status_code) {
  if (status_code == 401) {
    MyDialogHelper.title = "";
    MyDialogHelper.content = "Session expired";
    MyDialogHelper.page = Login();
    MyDialogHelper.showDialogMethod(context);
  }
}

void request_failed(BuildContext context, e) {
  MyDialogHelper.title = "Request Error";
  MyDialogHelper.content = e;
  MyDialogHelper.page = Login();
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
