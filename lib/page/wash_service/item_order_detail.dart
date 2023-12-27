import 'package:flutter/material.dart';
import 'package:MrCarwash/inc/req.dart';
import '../../env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../inc/method.dart';
import 'pre_order.dart';

class ItemDetail extends StatefulWidget {
  ItemDetail({dynamic data1, Key? key, int? id_order, required int spot_id})
      : super(key: key) {
    this.data1 = data1 ?? {};
    this.spot_id = spot_id;
    this.id_order = id_order;
  }
  late int spot_id;
  int? id_order;

  late dynamic data1;

  @override
  _ItemDetailState createState() =>
      _ItemDetailState(); // Corrected the class name
}

class _ItemDetailState extends State<ItemDetail> {
  late final requestBody = [];
  // Corrected the class name
  dynamic item;
  Req? req;
  int qty = 1;
  int sub_itm_id = 0;
  late int sub_item_price;
  late String sub_item_name;

  void initState() {
    super.initState();
    fetchData();
    add_existing_item();

    // debug(widget.spot_id);

    // debug(widget.id_order);

    // Call the fetchData method when the widget is first built
  }

  Future<void> fetchData() async {
    req = Req(context);

    await req!.init();

    dynamic req_item =
        await req!.dataDetaiItem(widget.data1['id_item'].toString());

    setState(() {
      // debug(req_item['response']);
      item = req_item['response'];
    });
  }

  void testmethod() {
    print("this request_body : ${requestBody}");
  }

  void add_existing_item() {
    try {
      int count_existing_item = widget.data1['list_item'].length > 0
          ? widget.data1['list_item'].length
          : 0;
      if (count_existing_item > 0) {
        for (var item in widget.data1['list_item']) {
          requestBody.add(item);
        }
      }
    } catch (e) {
      // Handle the exception
      return print(
          'Exception: $e'); // Output: Exception: IntegerDivisionByZeroException
    }

    // requestBody?.add(list_item);
  }

  Future<void> itemdata() async {
    dynamic id_item = widget.data1['id_item'].toString();
    String apiUrl =
        '$APIHOST/item/get-mainitem/$id_item'; // Replace with your API endpoint
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
        item = json.decode(response.body);
      });
      print(item);
      print("Success with item");
    } else {
      print(
          'Failed to load data item. Status code: ${response.statusCode} ${response.body}');
    }
  }

  Color containerColor = Colors.white; // Default color

  void changeColor(int id) {
    setState(() {
      // Update the color of the specific container based on the 'id'
      for (int i = 0; i < item['mainitem']['sub_item'].length; i++) {
        if (i == id) {
          item['mainitem']['sub_item'][i]['containerColor'] = Colors.blue;
        } else {
          item['mainitem']['sub_item'][i]['containerColor'] = Colors.white;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Implement the specific content for this widget

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 50,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Preorder(
                              data1: requestBody,
                              spot_id: widget.spot_id,
                              id_order: widget.id_order,
                            ), // Ensure you pass 'data' as a named parameter
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset('assets/back.png'),
                      ),
                    ),
                    Container(
                      child: Text(
                        'Item Detail',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left, // Apply bold font weight
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context)
                    .size
                    .width, // Set width to 100% of the screen width
                height: MediaQuery.of(context).size.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 232, 239, 239),
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the radius to make it more or less rounded
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            color: Colors.red,
                            child: Center(
                              child: item != null &&
                                      item['mainitem'] != null &&
                                      item['mainitem']['img'] != null
                                  ? Image.network(
                                      req!.host! + item['mainitem']['img'],
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                    )
                                  : Text('Image URL is null'),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              item != null &&
                                      item['mainitem'] != null &&
                                      item['mainitem']['img'] != null
                                  ? item['mainitem']['name'].toUpperCase()
                                  : "Text Not Fond",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              item != null &&
                                      item['mainitem'] != null &&
                                      item['mainitem']['img'] != null
                                  ? formatCurrency(item['mainitem']['price'])
                                      .toString()
                                  : "Text Not Fond",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 117, 213),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    qty += 1;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/Plus.png'),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    qty.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (qty > 0) {
                                      qty -= 1;
                                    }
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/Minus.png'),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                alignment: Alignment.centerRight,
                                // width: 100,
                                // color: Colors.blueGrey,
                                child: GestureDetector(
                                  onTap: () {
                                    final list_item = {
                                      "item_id": item['mainitem']['id'],
                                      "qty": qty,
                                      "price": item['mainitem']['price'],
                                      "name": item['mainitem']['name'],
                                    };

                                    if (sub_itm_id > 0) {
                                      list_item['sub_item'] = [];
                                      list_item['sub_item'].add({
                                        "sub_item_id": sub_itm_id,
                                        "price": sub_item_price,
                                        "name": sub_item_name
                                      });
                                    }

                                    requestBody.add(list_item);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Preorder(
                                          data1: requestBody,
                                          spot_id: widget.spot_id,
                                          id_order: widget.id_order,
                                        ), // Ensure you pass 'data' as a named parameter
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.blue,
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   flex: 13,
                        //   child: Align(
                        //     alignment: Alignment.center,
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           flex: 1,
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               setState(() {
                        //                 qty += 1;
                        //               });
                        //             },
                        //             child: Expanded(
                        //               flex: 1,
                        //               child: Container(
                        //                 height: 50,
                        //                 child: Align(
                        //                   alignment: Alignment.center,
                        //                   child: Image.asset('assets/Plus.png'),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         Expanded(
                        //             flex: 2,
                        //             child: Container(
                        //               height: 100,
                        //               margin: EdgeInsets.all(20),
                        //               padding: EdgeInsets.all(15),
                        //               child: Align(
                        //                 alignment: Alignment.center,
                        //                 child: Text(
                        //                   qty.toString(),
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 40,
                        //                     fontWeight: FontWeight.bold,
                        //                   ),
                        //                 ),
                        //               ),
                        //             )),
                        //         Expanded(
                        //           flex: 1,
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               setState(() {
                        //                 if (qty > 0) {
                        //                   qty -= 1;
                        //                 }
                        //               });
                        //             },
                        //             child: Expanded(
                        //               flex: 1,
                        //               child: Container(
                        //                 height: 50,
                        //                 child: Align(
                        //                   alignment: Alignment.center,
                        //                   child:
                        //                       Image.asset('assets/Minus.png'),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),

                        //         // Transform.translate(
                        //         //   offset: Offset(0.0, MediaQuery.of(context).size.height - 200),
                        //         //   child: Container(
                        //         //     margin: EdgeInsets.all(20),
                        //         //     alignment: Alignment.center,
                        //         //     decoration: BoxDecoration(
                        //         //       borderRadius: BorderRadius.circular(10.0),
                        //         //       color: Colors.blue,
                        //         //     ),
                        //         //     height: 50,
                        //         //     width: double.infinity,
                        //         //     child: Align(
                        //         //       alignment: Alignment.center,
                        //         //       child: Text(
                        //         //         "Add Order",
                        //         //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        //         //       ),
                        //         //     ),
                        //         //   ),
                        //         // )

                        //         Expanded(
                        //           flex: 3,
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               final list_item = {
                        //                 "item_id": item['mainitem']['id'],
                        //                 "qty": qty,
                        //                 "price": item['mainitem']['price'],
                        //                 "name": item['mainitem']['name'],
                        //               };

                        //               if (sub_itm_id > 0) {
                        //                 list_item['sub_item'] = [];
                        //                 list_item['sub_item'].add({
                        //                   "sub_item_id": sub_itm_id,
                        //                   "price": sub_item_price,
                        //                   "name": sub_item_name
                        //                 });
                        //               }

                        //               requestBody.add(list_item);

                        //               Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder: (context) => Preorder(
                        //                     data1: requestBody,
                        //                     spot_id: widget.spot_id,
                        //                     id_order: widget.id_order,
                        //                   ), // Ensure you pass 'data' as a named parameter
                        //                 ),
                        //               );
                        //             },
                        //             child: Container(
                        //               height: 100,
                        //               margin: EdgeInsets.all(20),
                        //               decoration: BoxDecoration(
                        //                 borderRadius:
                        //                     BorderRadius.circular(10.0),
                        //                 color: Colors.blue,
                        //               ),
                        //               padding: EdgeInsets.all(15),
                        //               child: Align(
                        //                 alignment: Alignment.center,
                        //                 child: Text(
                        //                   "ADD",
                        //                   style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: 30,
                        //                     fontWeight: FontWeight.bold,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );

    // You can also add widget-specific methods and properties here
  }
}
