import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'monitoring_page.dart';
import '../inc/method.dart';
import '../env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetail extends StatefulWidget {
  OrderDetail({Key? key, List? data1}) : super(key: key) {
    this.data1 = data1 ?? [];
  }

  late dynamic data1;

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  void initState() {
    super.initState();
    // add_list_item();
    // call_washer();

    // initializeWasherValues();
    // Add a listener to check keyboard visibility
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20.0), // Add margin here
              child: const Text(
                "Order Detail",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
