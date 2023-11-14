import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import '../inc/method.dart';
import '../env.dart';
import 'item_order_detail.dart';
import 'order_detail.dart';
import 'monitoring_page.dart';

class Preorder extends StatefulWidget {
  Preorder({Key? key, List? data1, required int spot_id}) : super(key: key) {
    this.data1 = data1 ?? [];
    this.spot_id = spot_id;
  }

  late int spot_id;
  late dynamic data1;

  @override
  _PreorderState createState() => _PreorderState();
}

class _PreorderState extends State<Preorder> {
  dynamic category;
  dynamic item;
  late final list_item = [];

  @override
  final requestBody = {
    'search': {},
  };

  final sub_total = {
    "item_count": 0,
    "sub_total": 0,
  };

  final customHeaders = {
    'Custom-Header': 'custom-value',
  };
  void initState() {
    super.initState();

    count_item();
    add_list_item();
    // Call the fetchData method when the widget is first built
    fetchData();
    itemdata(requestBody, customHeaders);

    print(widget.spot_id);
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

  void count_item() {
    if (widget.data1 is Iterable) {
      dynamic item_count = 0;
      dynamic total_item = 0;

      for (var item in widget.data1) {
        item_count += item['qty'];

        dynamic price = item['qty'] * item['price'];
        total_item += price;
        int sub = item['sub_item'] != null ? item['sub_item'].length : 0;
        if (sub > 0) {
          for (var sub_item in item['sub_item']) {
            dynamic price_sub_item = item['qty'] * sub_item['price'];
            total_item += price_sub_item;
          }
        }
      }

      sub_total['item_count'] = item_count;
      sub_total['sub_total'] = total_item;
    } else {
      print('data1 is not iterable');
    }
  }

  Future<void> fetchData() async {
    const String apiUrl =
        '$APIHOST/item/fatch-all-category'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer  $JWT', // Replace with your authentication token
    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        category = json.decode(response.body); // Update the fetched data
      });
      print("success with category"); // Print the response data to the console
    } else {
      print(
          'Failed to load data category. Status code: ${response.statusCode}');
    }
  }

  Future<int> itemdata(Map<String, dynamic> requestBody,
      Map<String, String> customHeaders) async {
    const String apiUrl =
        '$APIHOST/item/fatch-all-mainitem'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $JWT',
      'Content-Type': 'application/json',
      ...?customHeaders, // Include any custom headers passed as a parameter
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        item = json.decode(response.body);
      });
      print("Success with item");
    } else {
      print(
          'Failed to load data item. Status code: ${response.statusCode} ${response.body}');
    }

    return response.statusCode;
  }

  Map<String, dynamic> bookItem = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Monitoring(), // Ensure you pass 'data' as a named parameter
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 50, left: 10),
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/back.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 19.0, bottom: 19),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Wash Services',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 19.0, left: 10, bottom: 19),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Category',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0,
                      top: 20,
                      bottom: 15), // Adjust the padding as needed
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 75,
                    runSpacing: 20,
                    children: (category != null ? category['category'] : [])
                        .map<Widget>((category) {
                      final categoryName = category['name'];
                      final categoryImage = APIHOST + category['img'];
                      final categoryId = category['id'];

                      return GestureDetector(
                        onTap: () {
                          requestBody['search']?['category'] = categoryId;
                          Future<int> req =
                              itemdata(requestBody, customHeaders);
                          req.then((value) {
                            if (value != 200) {
                              ModalDialog(context);
                            }
                          });
                        },
                        child: Container(
                          width: 85,
                          height: 75,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(categoryImage),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 19.0, left: 10, bottom: 19),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Services',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15,
                        top: 10,
                        bottom: 100), // Adjust the padding as needed
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 15,
                      runSpacing: 20,
                      children:
                          (item != null ? item['results']['mainitem'] : [])
                              .map<Widget>((item) {
                        final itemName = item['name'].toUpperCase();
                        final itemImg = APIHOST + item['img'];
                        final itemPrice =
                            formatCurrency(item['price']).toString();

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: GestureDetector(
                            onTap: () {
                              print("this pushed $itemName");
                              // Handle category selection
                            },
                            child: Container(
                              width: 220,
                              height: 300,
                              color: const Color.fromARGB(255, 207, 204, 203),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      color: Colors.red,
                                      child: Center(
                                        child: Image.network(
                                          itemImg,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          itemName,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          itemPrice,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 210,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              print("btn press");

                                              int id_item = item['id'];

                                              dynamic payload = {
                                                "id_item": id_item,
                                                "list_item": list_item
                                              };
                                              print(payload);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ItemDetail(
                                                            data1: payload,
                                                            spot_id: widget
                                                                .spot_id)),
                                              );
                                              //
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                              ),
                                            ),
                                            child: Text('Open Dialog'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 75),
                )
              ],
            ),
          ),
          OrderSum(
            sub_total: sub_total,
            list_item: list_item,
            spot_id: widget.spot_id,
          ),
        ],
      ),
    );
  }

  Future<dynamic> ModalDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(''),
          content: Text('Item Not Found.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class OrderSum extends StatelessWidget {
  OrderSum({
    Key? key,
    required this.sub_total,
    required this.list_item,
    required this.spot_id,
  }) : super(key: key) {
    // Call your method here
    methodsetter();
  }
  final Map<String, int> sub_total;
  final int spot_id;

  final List list_item;
  late final String item_count;
  late final String total;

  void methodsetter() {
    String itm = sub_total['item_count']! > 1 ? " Items" : " Item";
    item_count = sub_total['item_count'].toString() + itm;
    total = formatCurrency(sub_total['sub_total']!);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: sub_total['item_count']! > 0 ? true : false,
      child: Transform.translate(
        offset: Offset(0.0, MediaQuery.of(context).size.height - 100),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderDetail(data1: list_item, spot_id: spot_id)),
            );
          },
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromARGB(
                  255, 211, 210, 210), // Set the background color
            ),
            height: 75, // Set the desired height

            // Add content for the new container here
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item_count,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        total,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
