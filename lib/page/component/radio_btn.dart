import 'dart:ffi';

import 'package:MrCarwash/inc/method.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [Radio].

class RadioBtnApp extends StatelessWidget {
  RadioBtnApp({super.key});

  List<Map<String, dynamic>> data = [
    {"name": "test 2", "value": 2},
    {"name": "test 1", "value": 3},
    {"name": "test 1", "value": 4},
    {"name": "test 1", "value": 5},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio Sample')),
      body: RadioBtn(
        tittle: "Payment Method",
        data: data,
        def_value: data[0],
      ),
    );
  }
}

class RadioBtn extends StatefulWidget {
  final String tittle;
  final List<Map<String, dynamic>> data;
  dynamic value;
  VoidCallback? callback;
  dynamic def_value;

  RadioBtn(
      {Key? key,
      VoidCallback? callback,
      required this.def_value,
      required this.tittle,
      required this.data}) {
    this.callback = callback;
  }

  @override
  State<RadioBtn> createState() => _RadioBtnState();
}

class _RadioBtnState extends State<RadioBtn> {
  late List<Map<String, dynamic>> data;
  String? tittle;
  dynamic _selectedValue;
  void initState() {
    super.initState();

    setState(() {
      data = widget.data;
      tittle = "${widget.tittle} : ";
      _selectedValue = widget.def_value;
      widget.value = _selectedValue;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 50,
      child: Row(
        children: [
          Container(
            child: Text(tittle.toString()),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: data.map<Widget>(
                  (item) {
                    return Row(
                      children: [
                        Radio(
                          value: item,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              if (widget.callback != null) {
                                widget.callback!();
                              }
                              _selectedValue = value;
                              widget.value = _selectedValue;
                              // dbg(widget.value);
                            });
                          },
                        ),
                        Text(item["name"].toString()),
                        SizedBox(width: 10), // Adjust spacing between items
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
