import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:intl/intl.dart';
import '../env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  dynamic d_order;

  @override
  void initState() {
    super.initState();
    call_order();
  }

  void call_order() async {
    String apiUrl =
        '$APIHOST/order/order-report'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $JWT',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(payload),
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
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
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
                setState(() {
                  payload['start_date'] = field_startdate;
                  payload['end_date'] = field_startdate;
                  call_order();
                  print(payload);
                });
              },
              child: Text(
                "Search",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
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
                            bool order_status = d_order[i]['order_status'];

                            DateTime originalDateTime =
                                DateTime.parse(d_order[i]['create_at']);
                            String formattedDateTime =
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(originalDateTime);
                            String Sub_total =
                                formatCurrency(d_order[i]['sub_total']);
                            return ExpansionTile(
                              backgroundColor: order_status == true
                                  ? Color.fromARGB(255, 143, 207, 221)
                                  : Color.fromARGB(255, 173, 104, 104),
                              collapsedBackgroundColor: order_status == true
                                  ? Color.fromARGB(255, 143, 207, 221)
                                  : Color.fromARGB(255, 173, 104, 104),
                              title: Text(vehicle),
                              subtitle: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        order_cod,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        formattedDateTime,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Text(Sub_total),
                              controlAffinity: ListTileControlAffinity.leading,
                              children: <Widget>[
                                ListTile(title: Text('This is tile number ')),
                              ],
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
          ),
          Column(
            children: [
              ExpansionTile(
                backgroundColor: Color.fromARGB(255, 143, 207, 221),
                collapsedBackgroundColor: Color.fromARGB(255, 143, 207, 221),
                title: Text(
                  'Klo(B A546 CB)',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                subtitle: Container(
                  // color: Colors.grey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "NoOrder",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "03/04/2024 40:30",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Text("Rp.40.000"),
                controlAffinity: ListTileControlAffinity.leading,
                children: <Widget>[
                  ListTile(title: Text('This is tile number 3')),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
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
