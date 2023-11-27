import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController startdate = TextEditingController();
  TextEditingController enddate = TextEditingController();

  DateTime? selectedDate;
  String? datefield1;

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
          TextBtn(),
          Container(
            margin: EdgeInsets.only(top: 20),
          ),
          Column(
            children: [
              ExpansionTile(
                backgroundColor: Color.fromARGB(255, 173, 104, 104),
                collapsedBackgroundColor: Color.fromARGB(255, 173, 104, 104),
                title: Text('Klo(B A546 CB)'),
                subtitle: Container(
                  // color: Colors.grey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "NoOrder",
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "03/04/2024 40:30",
                          textAlign: TextAlign.left,
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
