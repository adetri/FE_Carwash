// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:flutter_application_1/page/monitoring_page.dart';
import '../env.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PayOrder extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const PayOrder({super.key, required this.id_order});

  final int id_order;
  @override
  _PayOrderState createState() => _PayOrderState();
}

class _PayOrderState extends State<PayOrder> {
  dynamic d_order;

  @override
  void initState() {
    super.initState();
    call_order();
  }

  void call_order() async {
    String apiUrl =
        '$APIHOST/order/preogres-order/${widget.id_order}'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $JWT',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        d_order = json.decode(response.body);
      });
      // print(d_order);
      print("Success with order");
    } else {
      print(
          'Failed to load data item. Status code: ${response.statusCode} ${response.body}');
    }
  }

  Future<Map<String, dynamic>> pay_order(order_id) async {
    String apiUrl =
        '$APIHOST/order/pay-order/$order_id'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $JWT',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      // body: jsonEncode(paylod),
    );

    return {"status_code": response.statusCode, "response": response.body};
  }

  Future<Map<String, dynamic>> delete_order(order_id) async {
    String apiUrl =
        '$APIHOST/order/delete-order/$order_id'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $JWT',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
      // body: jsonEncode(paylod),
    );

    return {"status_code": response.statusCode, "response": response.body};
  }

  @override
  Widget build(BuildContext context) {
    String inputText = "";
    dynamic data = d_order;
    dynamic total = data != null && data['order'] != null
        ? formatCurrency(data['order']['sub_total'])
        : null;

    dynamic id_order =
        data != null && data['order'] != null ? data['order']['id'] : null;

    dynamic owner = data != null && data['order'] != null
        ? data['order']['vehicle_owner']
        : null;
    dynamic vehicle_number = data != null && data['order'] != null
        ? data['order']['vehicle_number']
        : null;

    dynamic list_item = data != null && data['order'] != null
        ? data['order']['service_list_order']
        : [];

    dynamic washer_list = data != null && data['order'] != null
        ? data['order']['order_washer_list']
        : [];

    // String total = formatCurrency(d_order['sub_total']);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Monitoring(),
                          ),
                        );
                      },
                      child: Image.asset('assets/back.png'),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Order Detail",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            list_itm(list_item),
            Container(
              margin: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide(width: 3))),
            ),
            sub_total(total),
            data_owner(vehicle_number, owner),
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
                      ),
                    ),
                    wahser_list(washer_list),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 105, 216, 109),
                          borderRadius: BorderRadius.circular(4)),
                      child: TextButton(
                        onPressed: () async {
                          print("click");

                          Map<String, dynamic> send_req =
                              await pay_order(id_order);

                          if (send_req['status_code'] == 201) {
                            dialog("Success to add order data", "Success",
                                monitoring: "istrue");
                          } else {
                            dialog(send_req['response'], "Failed");
                          }
                          print(send_req);
                        },
                        child: Center(
                          child: Text(
                            "Pay",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 205, 52, 52),
                          borderRadius: BorderRadius.circular(4)),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete"),
                                content: Text("Are you sure to delete ?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog

                                      Map<String, dynamic> send_req =
                                          await delete_order(id_order);

                                      if (send_req['status_code'] == 202) {
                                        dialog("Success to delete order data",
                                            "Success",
                                            monitoring: "istrue");
                                      } else {
                                        dialog(send_req['response'], "Failed");
                                      }
                                    },
                                    child: Text('OK'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text('NO'),
                                  )
                                ],
                              );
                            },
                          );
                          // delete_order
                        },
                        child: Center(
                          child: Text(
                            "Cancle",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> dialog(String msg, String title, {dynamic monitoring}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

                if (monitoring != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Monitoring(), // Ensure you pass 'data' as a named parameter
                    ),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Column wahser_list(washer_list) {
    return Column(
      children: List<Widget>.generate(
          (washer_list != null ? washer_list.length : 0), (int i) {
        if (washer_list == null) {
          print('Index out of bounds: $i');
          return SizedBox();
        }
        String name = washer_list[i]['karyawan']['name'];
        return Container(
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
              name.toString(),
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }),
    );
  }

  Container data_owner(vehicle_number, owner) {
    return Container(
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
                vehicle_number.toString(),
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
                owner.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container sub_total(total) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                "TOTAL",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                total.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column list_itm(list_item) {
    return Column(
      children: List<Widget>.generate(
        (list_item != null ? list_item.length : 0),
        (int i) {
          if (i < 0 || i >= list_item.length) {
            print('Index out of bounds: $i');
            return SizedBox(); // Or another placeholder widget or null
          }

          String item_name = list_item[i]['item']['name'];
          dynamic qty = list_item[i]['qty'];

          dynamic harga = list_item[i]['subitem_service_list'] != null &&
                  list_item[i]['subitem_service_list'].isNotEmpty
              ? (list_item[i]['price'] +
                  list_item[i]['subitem_service_list'][0]['price'])
              : list_item[i]['price'];

          String harga_item = formatCurrency(harga);
          return Container(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.all(10.0), // Add margin here
                    child: Text(
                      item_name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                              qty.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
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
                      harga_item,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
