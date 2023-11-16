import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

String formatCurrency(int amount) {
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  String result = currencyFormat.format(amount);
  List<String> substrings = result.split(',');
  return substrings[0];
}

class MyDialogHelper {
  static void showDialogMethod(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dialog Title'),
          content: Text('This is the content of the dialog.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
