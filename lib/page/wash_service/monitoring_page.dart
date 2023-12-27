// TODO Implement this library.

import 'package:flutter/material.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/main_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
import 'pre_order.dart';
import '../../env.dart';
import 'pay_order.dart';

class MonitoringAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Moniring"),
      backgroundColor: Colors.grey,
    );
  }
}

class Monitoring extends StatefulWidget {
  Monitoring({
    super.key,
  });

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  dynamic jsonData1; // Make jsonData1 nullable
  String? nama_karyawan;
  bool load_page = false;
  Map<String, dynamic>? role;
  @override
  void initState() {
    super.initState();
    setter();
    load_page = true;
  }

  Future<void> setter() async {
    Req req = Req(context); // Create an instance of 'Req' using the context
    await req.init();
    var req_role = await req.getRole();

    nama_karyawan = req?.karyawan_name;
    dynamic data = await req
        .fetchMonitoring1(); //a = Req(context); // Create an instance of 'Req' using the context
    // Use 'req' instance as needed
    setState(() {
      jsonData1 = data['response'];
      role = req_role['response'];

      // print(jsonData1);
    });
  }

  Future<void> fetchData() async {
    // const String apiUrl =
    //     '$APIHOST/order/get-spot'; // Replace with your API endpoint
    // final Map<String, String> headers = {
    //   'Authorization': 'Bearer $JWT',
    //   'Content-Type': 'application/json',
    //   // Replace with your authentication token
    // };

    // final response = await http.get(Uri.parse(apiUrl), headers: headers);

    // req_validation(context, response.statusCode);
    // if (response.statusCode == 200) {
    //   setState(() {
    //     jsonData1 = json.decode(response.body); // Update the fetched data
    //   });
    //   print(jsonData1);
    //   print("succes to get data"); // Print the response data to the console
    // } else {
    //   print('Failed to load data. Status code: ${response.statusCode}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load_page == false
          ? SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 19.0), // Adjust the padding as needed
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    top: 50, bottom: 20, right: 50),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          print("tab this");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Mainmenu()),
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
                                        'Monitoring',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign
                                            .left, // Apply bold font weight
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          nama_karyawan.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign
                                              .right, // Apply bold font weight
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 10,
                                children:
                                    (jsonData1 ?? const {'spot': []})['spot']
                                        .map<Widget>((spot) {
                                  final int id = spot['id'];
                                  final name = spot['name'];
                                  final status = spot['status'];
                                  final color = status
                                      ? const Color.fromARGB(255, 94, 207, 98)
                                      : const Color.fromARGB(
                                          255, 207, 204, 203);
                                  final owner = spot['vehicle_owner'] ?? "";
                                  final number = spot['vehicle_number'] ?? "";
                                  final order = spot['order'] ?? "";

                                  return ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            if (status) {
                                              // Execute code when status is true
                                              print(
                                                  'Containdasdasder tapped with true status - $order');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PayOrder(
                                                            id_order: order)),
                                              );
                                              // Add other actions for true status here
                                            } else {
                                              canAccess(role, kasir: true)
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Preorder(
                                                          spot_id: id,
                                                        ),
                                                      ),
                                                    )
                                                  : dbg("not ath");

                                              // Execute code when status is false

                                              // Add other actions for false status here
                                            }
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            color: color,
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    '$name',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ), // Display ID with bold style
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    '$owner',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ), // Display ID with bold style

                                                // ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    '$number',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ), // Display ID with bold style

                                                Expanded(
                                                  child: Container(
                                                    height: 20,
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      '${status ? 'Use' : 'Availble'}',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )));
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
