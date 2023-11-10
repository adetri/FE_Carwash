import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'monitoring_page.dart';
import '../inc/method.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail({Key? key, List? data1}) : super(key: key) {
    this.data1 = data1 ?? [];
  }

  late dynamic data1;

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool isKeyboardVisible = false;
  late final list_item = [];

  @override
  void initState() {
    super.initState();
    add_list_item();
    // Add a listener to check keyboard visibility
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
      print(list_item[i]['price']);
      print(list_item[i]['qty']);
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

  @override
  Widget build(BuildContext context) {
    String inputText = "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.all(20.0), // Add margin here
                    child: Text(
                      "Order Detail",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: List<Widget>.generate(
                        (list_item != null ? list_item.length : 0),
                        (int index) {
                          if (index < 0 || index >= list_item.length) {
                            print('Index out of bounds: $index');
                            return SizedBox(); // Or another placeholder widget or null
                          }

                          String item_name = list_item[index]['sub_item'] !=
                                  null
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
                                  margin:
                                      EdgeInsets.all(10.0), // Add margin here
                                  child: Text(
                                    item_name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin:
                                      EdgeInsets.all(10.0), // Add margin here
                                  child: Text(
                                    item_harga,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin:
                                      EdgeInsets.all(10.0), // Add margin here
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                list_item[index]['qty'] += 1;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                    'assets/Plus.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            item_qty,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                count_total();
                                                print(harga);
                                                if (list_item[index]['qty'] >
                                                    1) {
                                                  list_item[index]['qty'] -= 1;
                                                } else {
                                                  list_item.remove(index);

                                                  list_item.removeWhere(
                                                      (item) =>
                                                          item['item_id'] ==
                                                          item_id);
                                                  print(list_item);
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                    'assets/Minus.png'),
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

                      // Row(
                      //   children: List<Widget>.generate(
                      //     (list_item != null ? list_item.length : 0),
                      //     (int index) {
                      //       return Expanded(
                      //         flex: 5,
                      //         child: Container(
                      //           margin: EdgeInsets.all(10.0), // Add margin here
                      //           child: Text(
                      //             "Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail Order Detail ",
                      //             style: TextStyle(
                      //                 fontSize: 20, fontWeight: FontWeight.w500),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 3))),
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
                            formatCurrency(count_total()),
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
                        margin: EdgeInsets.only(top: 10),
                        child: TextField(
                          onChanged: (text) {
                            setState(() {
                              inputText = text;
                            });
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
                              inputText = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Owner',
                            border: OutlineInputBorder(),
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
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Image.asset('assets/Plus.png'),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            onChanged: (text) {
                              setState(() {
                                inputText = text;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Washer',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            onChanged: (text) {
                              setState(() {
                                inputText = text;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Washer',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            onChanged: (text) {
                              setState(() {
                                inputText = text;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Washer',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1000, style: BorderStyle.solid)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 100),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: Offset(0.0, MediaQuery.of(context).size.height - 200),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Monitoring()),
                );
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
            ),
          ) // Adjust the X and Y coordinates
        ],
      ),
    );
  }
}
