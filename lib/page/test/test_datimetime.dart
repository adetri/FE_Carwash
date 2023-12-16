import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TestDateTImePicker extends StatefulWidget {
  const TestDateTImePicker({super.key});

  @override
  State<TestDateTImePicker> createState() => _TestDateTImePickerState();
}

class _TestDateTImePickerState extends State<TestDateTImePicker> {
  TextEditingController startdate = TextEditingController();
  String? field_startdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextField(
        controller: startdate, //editing controller of this TextField
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Start Date", //label text of field
          border: OutlineInputBorder(),
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101),
              currentDate: DateTime.now(),
              initialEntryMode: DatePickerEntryMode.input);

          if (pickedDate != null) {
            print(
                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
            String formattedDate = DateFormat('yyyy-MM').format(pickedDate);
            print(
                formattedDate); //formatted date output using intl package =>  2021-03
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
    );
  }
}
