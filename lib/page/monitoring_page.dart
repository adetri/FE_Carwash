// TODO Implement this library.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
import 'pre_order.dart';
import '../env.dart';
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
  dynamic jsonData1;

  @override
  void initState() {
    super.initState();
    // Call the fetchData method when the widget is first built
    fetchData();
  }

  Future<void> fetchData() async {
    const String apiUrl =
        '$APIHOST/order/get-spot'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $JWT',
      'Content-Type': 'application/json',
      // Replace with your authentication token
    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        jsonData1 = json.decode(response.body); // Update the fetched data
      });
      print(jsonData1);
      print("succes to get data"); // Print the response data to the console
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
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
                        top: 50, left: 50, bottom: 20, right: 50),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 50,
                              alignment: Alignment.topLeft,
                              child: Image.asset('assets/back.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            // color: Colors.blue,
                            child: Text(
                              'Monitoring',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign:
                                  TextAlign.center, // Apply bold font weight
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
                    children: (jsonData1 ?? const {'spot': []})['spot']
                        .map<Widget>((spot) {
                      final id = spot['id'];
                      final name = spot['name'];
                      final status = spot['status'];
                      final color = status
                          ? const Color.fromARGB(255, 94, 207, 98)
                          : const Color.fromARGB(255, 207, 204, 203);
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
                                        builder: (context) => PayOrder()),
                                  );
                                  // Add other actions for true status here
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Preorder()),
                                  );
                                  // Execute code when status is false

                                  // Add other actions for false status here
                                }
                              },
                              child: Container(
                                width: 250,
                                height: 200,
                                color: color,
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('$name',
                                            style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight
                                                    .bold)), // Display ID with bold style
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('$owner',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight
                                                    .bold)), // Display ID with bold style
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('$number',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight
                                                    .bold)), // Display ID with bold style
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 50, top: 60),
                                              // Adds margin to the left of the child
                                            ),
                                            Text(
                                              '${status ? 'Use' : 'Availble'}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
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
        )),
      ],
    )));
  }
}
