// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:flutter_application_1/page/monitoring_page.dart';
import 'package:flutter_application_1/page/pre_order.dart';
import '../env.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'print.dart';
import 'package:intl/intl.dart';

class PayOrder extends StatefulWidget {
  // ignore: non_constant_identifier_names
  PayOrder({super.key, required this.id_order});

  final int? id_order;
  @override
  _PayOrderState createState() => _PayOrderState();
}

class _PayOrderState extends State<PayOrder> {
  dynamic d_order;
  dynamic paylod = {};
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    call_order();
  }

  // dynamic printer_check() async {
  //   bluetooth.isConnected.then((isConnected) {
  //     if (isConnected == true) {
  //       print("bluetooth is conect");

  //       return 1;
  //     } else {
  //       print("bluetooth is not conect");
  //       return 0;
  //     }
  //   });
  // }

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
      print(d_order);
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
      body: jsonEncode(paylod),
    );

    return {"status_code": response.statusCode, "response": response.body};
  }

  Future<Map<String, dynamic>> delete_order(order_id) async {
    String apiUrl =
        '$APIHOST/order/cancle-order/$order_id'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $JWT',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      // body: jsonEncode(paylod),
    );

    return {"status_code": response.statusCode, "response": response.body};
  }

  void printRecipt(data) {
    bluetooth.isConnected.then((isConnected) {
      bluetooth.printCustom(data['outlet_name'], 2, 1);
      bluetooth.printCustom(data['outlet_alamt'], 1, 1);
      bluetooth.printCustom(data['phone_number'], 1, 1);

      bluetooth.printNewLine();
      bluetooth.printCustom(data['datetime'], 0, 0);

      bluetooth.printCustom("No order : ${data['no_order']}", 0, 0);

      bluetooth.printCustom("==========================================", 0, 0);

      for (var d in data['list_item']) {
        String item_name = d['item']['name'];
        int price = d['price'];
        if (d['subitem_service_list'].isNotEmpty) {
          String sub_item = d['subitem_service_list'][0]['sub_item']['name'];
          item_name = "$item_name ($sub_item)";
          int harga_sub = d['subitem_service_list'][0]['sub_item']['price'];
          price += harga_sub;
        }
        int sub_total = d['qty'] * price;
        bluetooth.printCustom(item_name, 0, 0);
        bluetooth.printLeftRight(
            "${d['qty'].toString()} x ${formatCurrency(price)}",
            formatCurrency(sub_total),
            0);
      }

      bluetooth.printCustom("==========================================", 0, 0);
      // checkDataType(data['nominal'] as int);
      // checkDataType(data['total'] as int);
      // data['nominal'] as int;
      // data['total'] as int;

      checkDataType(data['nominal'] as int);
      checkDataType(data['sub_total'] as int);
      if (data['total'] != null) {
        print(data['total']); // Output: 42
      } else {
        print('Invalid integer format');
      }
      int kembalian = data['nominal'] - data['sub_total'];

      // dynamic kembalian = data['nominal'] - data['total'];
      bluetooth.printLeftRight("Pay", formatCurrency(data['nominal']), 0);
      bluetooth.printLeftRight("Total", data['total'].toString(), 0);

      bluetooth.printLeftRight("Change", formatCurrency(kembalian), 0);

      bluetooth.paperCut();
    });
  }

  int? nominal = 0;

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

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
    List<Map<dynamic, dynamic>> send_list_item = [];
    for (var it in list_item) {
      Map<dynamic, dynamic> item = {
        'item_id': it['id'],
        'name': it['item']['name'],
        'price': it['price'],
        'qty': it['qty'],
      };

      if (it['subitem_service_list'] != null &&
          it['subitem_service_list'].isNotEmpty) {
        List<Map<String, dynamic>> sub_it = [
          {
            'sub_item_id': it['subitem_service_list'][0]['sub_item']['id'],
            'price': it['subitem_service_list'][0]['sub_item']['price'],
            'name': it['subitem_service_list'][0]['sub_item']['name'],
          },
        ];
        item['sub_item'] = sub_it;
      }
      send_list_item.add(item);
    }

    print("this seend_list_itm ${send_list_item}");
    dynamic data_recipe = {
      "id_order":
          data != null && data['order'] != null ? data['order']['id'] : null,
      "sub_total": data != null && data['order'] != null
          ? data['order']['sub_total']
          : 0,
      "total": total,
      "list_item": list_item,
      "outlet_name": "Mr Carwash",
      "outlet_alamt": "Jagakarsa, Kec. Jagakarsa, Kota Jakarta Selatan",
      "phone_number": "085157792607",
      "nominal": nominal,
      "datetime": formattedDate,
      "no_order": data != null && data['order'] != null
          ? data['order']['order_code']
          : ""
    };
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
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 10),
              child: ElevatedButton(
                onPressed: () {
                  nav_to(
                      context,
                      Preorder(
                          spot_id: data['order']['spot'], id_order: id_order));
                },
                child: Text("Add more item"),
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
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Pay",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            onChanged: (num) {
                              setState(() {
                                nominal = int.parse(num);

                                print(nominal);
                              });
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              // You can add more formatters if needed, for instance, to limit the length
                              // LengthLimitingTextInputFormatter(5), // Allows only 5 characters
                            ],
                            decoration: InputDecoration(
                              labelText: 'Nominal',
                              hintText: 'Nominal',
                              border: OutlineInputBorder(),
                            ),
                            // Additional properties and handlers for the TextField
                          ),
                        )
                      ],
                    ),
                    pay_btn(data_recipe, context),
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

  Container pay_btn(data, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 105, 216, 109),
          borderRadius: BorderRadius.circular(4)),
      child: TextButton(
        onPressed: () async {
          // print(data['order']['sub_total']);
          print(nominal);
          print(data);
          if (nominal! < data['sub_total']) {
            dialog(
                "Nominal Most be Equar or higher than total", "Nominal Error");
            return;
          }

          int? printer_cek = await printerCheck();

          if (printer_cek == 1) {
            paylod['nominal'] = nominal;
            Map<String, dynamic> send_req = await pay_order(data['id_order']);

            if (send_req['status_code'] == 201) {
              printRecipt(data);

              dialog("Success to add order data", "Success",
                  monitoring: "istrue");
            } else {
              dialog(send_req['response'], "Failed");
            }
            print(send_req);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ThermalPrint(), // Ensure you pass 'data' as a named parameter
              ),
            );
          }
        },
        child: Center(
          child: Text(
            "Pay",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
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
