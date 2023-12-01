import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/method.dart';

class DropdownMenuApp extends StatelessWidget {
  DropdownMenuApp({super.key});

  List<dynamic> newlist = [
    {"name": "name2", "id": 1},
    {"name": "name1", "id": 2},
    {"name": "name1", "id": 4},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DropdownMenu Sample')),
      body: DropdownInputField(
        listItem: newlist,
      ),
    );
  }
}

class DropdownInputField extends StatefulWidget {
  DropdownInputField({Key? key, required this.listItem});

  List<dynamic>? listItem;
  @override
  State<DropdownInputField> createState() => _DropdownInputFieldState();
}

class _DropdownInputFieldState extends State<DropdownInputField> {
  List<dynamic>? list_item;
  dynamic dropdownValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() {
    list_item = widget.listItem;
    dropdownValue = list_item?.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<dynamic>(
      initialSelection: list_item?.first,
      onSelected: (dynamic value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value;
          dbg(dropdownValue);
        });
      },
      dropdownMenuEntries:
          list_item!.map<DropdownMenuEntry<dynamic>>((dynamic value) {
        return DropdownMenuEntry<dynamic>(
          value: value['id'],
          label: value['name']
              as String, // Assuming 'name' is the field to be displayed
        );
      }).toList(),
    );
  }
}
