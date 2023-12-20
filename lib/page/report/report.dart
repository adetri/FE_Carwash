import 'package:MrCarwash/page/report/menu_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:intl/intl.dart';
import '../../env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main_menu.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

dynamic payload = {};

class _ReportState extends State<Report> {
  TextEditingController startdate = TextEditingController();
  TextEditingController enddate = TextEditingController();

  String? field_startdate;
  String? field_enddate;
  dynamic total = 0;
  dynamic d_order;
  Req? req;
  @override
  void initState() {
    super.initState();
    init();
    // call_order();
  }

  String? karyawan_name;
  void init() async {
    req = Req(context);
    await req?.init();
    karyawan_name = req?.karyawan_name;
    orderReport();
  }

  void orderReport() async {
    var req_order = await req?.orderReporting(payload);
    setState(() {
      d_order = req_order?['response'];
      dbg(d_order);
      total = 0;
      if (req_order?['status_code'] == 200) {
        for (var data in d_order) {
          if (data['is_cancle'] == false) {
            total += data['sub_total'];
          }
        }
        total = formatCurrency(total);
      }
    });
  }
  // void call_order() async {
  //   String apiUrl =
  //       '$APIHOST/order/order-report'; // Replace with your API endpoint
  //   final Map<String, String> headers = {
  //     'Authorization': 'Bearer $JWT',
  //     'Content-Type': 'application/json',
  //   };

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: headers,
  //       body: jsonEncode(payload),
  //     );

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         d_order = json.decode(response.body);
  //       });

  //       total = 0;
  //       print("Success with order");
  //       for (var data in d_order) {
  //         if (data['is_cancle'] == false) {
  //           total += data['sub_total'];
  //         }
  //       }
  //       total = formatCurrency(total);
  //     } else {
  //       print(
  //           'Failed to load data item. Status code: ${response.statusCode} ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print("tab this");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportMenu()),
                      );
                    });
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/back.png'),
                  ),
                ),
                Container(
                  child: Text(
                    'Reporting',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left, // Apply bold font weight
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      karyawan_name.toString(),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right, // Apply bold font weight
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 25)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller:
                        startdate, //editing controller of this TextField
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Start Date", //label text of field
                      border: OutlineInputBorder(),
                    ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          startdate.text =
                              formattedDate; //set output date to TextField value.
                          field_startdate = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller: enddate, //editing controller of this TextField
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "End Date", //label text of field
                      border: OutlineInputBorder(),
                    ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          enddate.text =
                              formattedDate; //set output date to TextField value.
                          field_enddate = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(4)),
            child: TextButton(
              onPressed: () {
                if (field_startdate == null || field_enddate == null) {
                  show_dialog(context, "Field Require",
                      "Start & End date cant be null");
                  return;
                }

                setState(() {
                  payload['start_date'] = field_startdate.toString();
                  payload['end_date'] = field_enddate.toString();
                });
                orderReport();
                print(payload);
              },
              child: Text(
                "Search",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          list_item(),
          Container(
            margin: EdgeInsets.only(top: 20),
          ),
          Column(
            children: [
              ExpansionTile(
                backgroundColor: Colors.white,
                collapsedBackgroundColor: Colors.white,
                title: Text(
                  'TOTAL',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                // subtitle: Container(
                //   // color: Colors.grey,
                //   child: Column(
                //     children: [
                //       Container(
                //         alignment: Alignment.topLeft,
                //         child: Text(
                //           "NoOrder",
                //           textAlign: TextAlign.left,
                //           style: TextStyle(
                //             color: Colors.black,
                //           ),
                //         ),
                //       ),
                //       Container(
                //         alignment: Alignment.topLeft,
                //         child: Text(
                //           "03/04/2024 40:30",
                //           textAlign: TextAlign.left,
                //           style: TextStyle(
                //             color: Colors.black,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                trailing: Text(total.toString()),
                // controlAffinity: ListTileControlAffinity.leading,
                children: <Widget>[
                  // ListTile(title: Text('This is tile number 3')),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Expanded list_item() {
    dynamic item_price_total = 0;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            d_order == null || d_order.isEmpty
                ? Center(
                    child: Text("No items"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: d_order.length,
                    itemBuilder: (context, int i) {
                      String order_cod = d_order[i]['order_code'];
                      String vehicle =
                          "${d_order[i]['vehicle_owner']} (${d_order[i]['vehicle_number']})";
                      bool order_status = d_order[i]['is_cancle'];

                      DateTime originalDateTime =
                          DateTime.parse(d_order[i]['create_at']);

                      String kasir = d_order[i]['karyawan']['name'];

                      String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm')
                          .format(originalDateTime);
                      String Sub_total =
                          formatCurrency(d_order[i]['sub_total']);
                      String washers = "";
                      if (d_order[i]['order_washer_list'].isNotEmpty) {
                        for (var washer in d_order[i]['order_washer_list']) {
                          washers += "${washer['karyawan']['name']} ,";
                        }
                      }

                      dynamic total_order = 0;
                      return ExpansionTile(
                        backgroundColor: order_status == false
                            ? Color.fromARGB(255, 143, 207, 221)
                            : Color.fromARGB(255, 173, 104, 104),
                        collapsedBackgroundColor: order_status == false
                            ? Color.fromARGB(255, 143, 207, 221)
                            : Color.fromARGB(255, 173, 104, 104),
                        title: Text(
                          vehicle,
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Container(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  order_cod,
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  formattedDateTime,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Text(
                          Sub_total,
                          style: TextStyle(color: Colors.black),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text("Washer : ${washers}"),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        child: Text(
                                          "Kasir : ${kasir}",
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                d_order[i]['service_list_order'].isEmpty
                                    ? Text("Item Empty")
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: d_order[i]
                                                ['service_list_order']
                                            .length,
                                        itemBuilder: (context, int i1) {
                                          dynamic data_item =
                                              d_order[i]['service_list_order'];
                                          String item_name =
                                              data_item[i1]['item']['name'];
                                          dynamic item_price =
                                              data_item[i1]['price'];
                                          String qty =
                                              data_item[i1]['qty'].toString();

                                          if (d_order[i]['service_list_order']
                                                  [i1]['subitem_service_list']
                                              .isNotEmpty) {
                                            String sub_item_name = d_order[i]
                                                        ['service_list_order']
                                                    [i1]['subitem_service_list']
                                                [0]['sub_item']['name'];
                                            dynamic sub_harga = d_order[i]
                                                        ['service_list_order']
                                                    [i1]['subitem_service_list']
                                                [0]['price'];
                                            item_name =
                                                "$item_name ($sub_item_name)";
                                            item_price += (data_item[i1]
                                                    ['qty'] *
                                                sub_harga);
                                          }
                                          total_order += item_price;
                                          print("total  is $total_order");

                                          item_price =
                                              formatCurrency(item_price);
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Text(item_name),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  qty,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  item_price.toString(),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                Text(""),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("TOTAL"),
                                    ),
                                    Expanded(
                                      child: Text(
                                        Sub_total.toString(),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          // ListTile(title: Text('This is tile number ')),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class TextBtn extends StatelessWidget {
  const TextBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(4)),
      child: TextButton(
        onPressed: () {
          print("test1");
        },
        child: Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
