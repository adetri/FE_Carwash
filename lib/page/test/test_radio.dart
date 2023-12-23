import 'package:MrCarwash/inc/method.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [Radio].

class RadioExampleApp extends StatelessWidget {
  const RadioExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio Sample')),
      body: RadioExample(),
    );
  }
}

enum SingingCharacter { lafayette, jefferson }

class RadioExample extends StatefulWidget {
  const RadioExample({Key? key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  List<Map<String, dynamic>> data = [
    {"name": "test 2", "data_value": 2},
    {"name": "test 1", "data_value": 1}
  ];

  int? _selectedValue;

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 50,
      color: Colors.green,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: data.map<Widget>((item) {
            return Row(
              children: [
                Radio(
                  value: item["data_value"],
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value as int?;
                      dbg(_selectedValue);
                    });
                  },
                ),
                Text(item["name"].toString()),
                SizedBox(width: 10), // Adjust spacing between items
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
