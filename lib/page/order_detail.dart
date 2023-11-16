import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/page/pre_order.dart';
import 'monitoring_page.dart';
import '../inc/method.dart';
import '../env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetail extends StatefulWidget {
  OrderDetail({Key? key, List? data1, required this.spot_id})
      : super(key: key) {
    this.data1 = data1 ?? [];
  }
  final int spot_id;

  late dynamic data1;

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool isKeyboardVisible = false;
  late final list_item = [];
  dynamic p_washer;

  @override
  void initState() {
    super.initState();
    add_list_item();
    call_washer();

    // initializeWasherValues();
    // Add a listener to check keyboard visibility
  }

  Future<void> call_washer() async {
    String apiUrl =
        '$APIHOST/pegawai/get-washer-pegawai'; // Replace with your API endpoint
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
        p_washer = json.decode(response.body);
      });
      print(p_washer['pegawai']);
      print("Success with item");
    } else {
      print(
          'Failed to load data item. Status code: ${response.statusCode} ${response.body}');
    }
  }

  Future<Map<String, dynamic>> add_order(paylod, spot_id) async {
    String apiUrl =
        '$APIHOST/order/create-order/$spot_id'; // Replace with your API endpoint
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

  void add_list_item() {
    try {
      int itemcount = widget.data1.length > 0 ? widget.data1.length : 0;
    } catch (e) {
      return print(
          'Exception: $e'); // Output: Exception: IntegerDivisionByZeroException
    }
    for (var item in widget.data1) {
      list_item.add(item);
    }

    return print('Exception: $list_item');
  }

  dynamic count_total() {
    dynamic total = 0;
    for (int i = 0; i < list_item.length; i++) {
      total += list_item[i]['price'] * list_item[i]['qty'];

      int sub = list_item[i]['sub_item'] != null
          ? list_item[i]['sub_item'].length
          : 0;
      if (sub > 0) {
        for (var sub_item in list_item[i]['sub_item']) {
          total += sub_item['price'] * list_item[i]['qty'];
        }
      }
    }

    return total;
  }

  int washernum = 1;
  List<dynamic> washer = [null];
  String inputText = "";
  String platnum = "";
  String owner = "";

  // void initializeWasherValues() {
  //   // Access instance member p_washer here and set the value of washerValues
  //   washerValues.add(p_washer['pegawai']);
  // }

  @override
  Widget build(BuildContext context) {
    List<String?> selectedWashers = List<String?>.filled(washernum, null);
    late List<Map<String, dynamic>> washerValues =
        (p_washer['pegawai'] as List<dynamic>).cast<Map<String, dynamic>>();

    if (p_washer != null) {
      washerValues =
          (p_washer['pegawai'] as List<dynamic>).cast<Map<String, dynamic>>();
    } else {
      washerValues = [];
    }
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Tittle(list_item, widget.spot_id),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Li_item(),
                  ),
                ),
                total_btm_border(),
                total_list_item(),
                field_data_customer(),
                field_washer(selectedWashers, washerValues),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container total_btm_border() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 3))),
    );
  }

  Align field_washer(
      List<String?> selectedWashers, List<Map<String, dynamic>> washerValues) {
    return Align(
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
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (washernum < 4) {
                            washernum += 1;

                            if (washer.length < washernum) {
                              washer.add(null);
                            }
                          }
                        });
                      },
                      child: Container(
                        height: 50,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/Plus.png'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (washernum > 1) {
                            washernum -= 1;
                            washer.removeLast();
                          }
                        });
                        print(washernum);
                        print(washer);
                      },
                      child: Container(
                        height: 50,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/Minus.png'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: List.generate(
                washernum,
                (index) {
                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    child: DropdownButtonFormField<String?>(
                      value: selectedWashers[index],
                      onChanged: (String? newValue) {
                        setState(() {
                          washer[index] = newValue;
                        });
                      },
                      items: washerValues.map((value) {
                        return DropdownMenuItem<String?>(
                          value: value['id'].toString(),
                          child: Text(value['name']),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Washer ${index + 1}',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            navigate(),
            Container(
              margin: EdgeInsets.only(bottom: 100),
            )
          ],
        ),
      ),
    );
  }

  Container field_data_customer() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  platnum = text;
                });
                print(platnum);
              },
              decoration: InputDecoration(
                labelText: 'Vehicle Number',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  owner = text;
                });
                print(owner);
              },
              decoration: InputDecoration(
                labelText: 'Owner',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container total_list_item() {
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
                formatCurrency(count_total()),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column Li_item() {
    return Column(
      children: List<Widget>.generate(
        (list_item != null ? list_item.length : 0),
        (int index) {
          if (index < 0 || index >= list_item.length) {
            print('Index out of bounds: $index');
            return SizedBox(); // Or another placeholder widget or null
          }

          String item_name = list_item[index]['sub_item'] != null
              ? "${list_item[index]['name']} (${list_item[index]['sub_item'][0]['name']})"
              : list_item[index]['name'];

          dynamic harga = list_item[index]['sub_item'] != null
              ? (list_item[index]['price'] +
                  list_item[index]['sub_item'][0]['price'])
              : list_item[index]['price'];

          String item_harga = formatCurrency(harga);

          String item_qty = list_item[index]['qty'].toString();

          int item_id = list_item[index]['item_id'];

          dynamic total_harga = count_total();

          return Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.all(10.0), // Add margin here
                  child: Text(
                    item_name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.all(10.0), // Add margin here
                  child: Text(
                    item_harga,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
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
                          child: Container(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  list_item[index]['qty'] += 1;
                                });
                              },
                              child: Image.asset(
                                'assets/Plus.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            item_qty,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  // print(inputText);

                                  count_total();

                                  if (list_item[index]['qty'] > 1) {
                                    list_item[index]['qty'] -= 1;
                                  } else {
                                    list_item.remove(index);

                                    list_item.removeWhere(
                                        (item) => item['item_id'] == item_id);
                                  }
                                });
                              },
                              child: Image.asset(
                                'assets/Minus.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  GestureDetector navigate() {
    return GestureDetector(
      onTap: () {
        dynamic li = [];
        String field_req = "Field Require";
        print(widget.spot_id);
        setState(() async {
          if (owner == null || owner.isEmpty) {
            dialog("Owner name must be fill", field_req);
            return;
          }

          if (platnum == null || platnum.isEmpty) {
            dialog("Vehicle number must be fill", field_req);
            return;
          }

          for (var i = 0; i < washer.length; i++) {
            if (washer[i] == null) {
              dialog("Washer name must be fill", field_req);
              return;
            }
            li.add({"karyawan_id": int.parse(washer[i])});
          }

          dynamic payload = {
            "vehicle_owner": owner,
            "vehicle_number": platnum,
            "washer": li,
            "list_item": list_item,
          };

          Map<String, dynamic> send_req =
              await add_order(payload, widget.spot_id);

          if (send_req['status_code'] == 201) {
            dialog("Success to add order data", "Success",
                monitoring: "istrue");
          } else {
            dialog(send_req['response'], "Failed");
          }
          print(send_req);

          print(payload);
        });
      },
      child: Container(
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.blue,
        ),
        height: 50,
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "Add Order",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
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
}

class Tittle extends StatelessWidget {
  final List list_item;
  final spot_id;

  const Tittle(
    this.list_item,
    this.spot_id, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        children: [
          Container(
            height: 50,
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () {
                print("press");
                print(list_item);
                print(spot_id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Preorder(
                      data1: list_item,
                      spot_id: spot_id,
                    ),
                  ),
                );
              },
              child: Image.asset('assets/back.png'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                "Order Detail",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
