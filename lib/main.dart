import 'package:flutter/material.dart';
import 'page/monitoring_page.dart';
// import 'page/pre_order.dart';
// import 'page/order_detail.dart';
import 'page/pay_order.dart';
// import 'page/item_order_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter List from JSON',
      home: Monitoring(),
    );
  }
}
