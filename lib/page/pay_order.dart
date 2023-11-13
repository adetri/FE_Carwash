// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PayOrder extends StatefulWidget {
  const PayOrder({super.key});

  @override
  _PayOrderState createState() => _PayOrderState();
}

class _PayOrderState extends State<PayOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String inputText = "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Your Order'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(20.0), // Add margin here
                  child: Text(
                    "Order Detail",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.all(10.0), // Add margin here
                        child: Text(
                          "Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(10.0), // Add margin here
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 50,
                                  child: Align(
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 50,
                                  child: Align(
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(10.0), // Add margin here
                        child: Text(
                          "Rp400.0000.000",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide(width: 3))),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "TOTAL",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Rp400.0000.000",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 55,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black, width: 1)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Plat Number",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 55,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black, width: 1)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Owner Name",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Washers",
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: Container(
                              //     height: 50,
                              //     child: Align(
                              //       alignment: Alignment.topRight,
                              //       child: Image.asset('assets/Plus.png'),
                              //     ),
                              //   ),
                              // )
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 55,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Washer Name",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 55,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Washer Name",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 55,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Washer Name",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 105, 216, 109),
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Text(
                            "Pay",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 205, 52, 52),
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Text(
                            "Cancle",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
