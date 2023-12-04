import 'package:flutter/material.dart';
import 'package:MrCarwash/inc/method.dart';

class DropdownMenuApp extends StatelessWidget {
  DropdownMenuApp({super.key});

  List<dynamic> newlist = [
    {"name": "name2", "id": 1, "tes": "name2", "tes2": 1},
    {"name": "name1", "id": 2, "tes": "name2", "tes2": 1},
    {"name": "name1", "id": 4, "tes": "name2", "tes2": 1},
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
  final List<dynamic>? listItem;
  String? value;
  DropdownInputField({Key? key, required this.listItem, int? id_category}) {
    this.id_category = id_category;
  }
  int? id_category;
  @override
  _DropdownInputFieldState createState() => _DropdownInputFieldState();
}

class _DropdownInputFieldState extends State<DropdownInputField> {
  dynamic? dropdownValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    dropdownValue = widget.id_category != null
        ? widget.listItem?.firstWhere(
            (element) => element['id'] == widget.id_category,
            orElse: () => null)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      value: dropdownValue,
      onChanged: (dynamic? newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.value = newValue['id'].toString();
          print(widget.value);
          // dbg(dropdownValue);
          // Handle your logic when selection changes
        });
      },
      items: widget.listItem?.map<DropdownMenuItem<dynamic>>((dynamic item) {
            return DropdownMenuItem<dynamic>(
              value: item,
              child: Text(item['name'].toString()),
            );
          }).toList() ??
          [],
    );
  }
}


// class DropdownInputField extends StatefulWidget {
//   DropdownInputField({Key? key, required this.listItem});
//   String? value;
//   List<dynamic>? listItem;
//   @override
//   State<DropdownInputField> createState() => _DropdownInputFieldState();
// }

// class _DropdownInputFieldState extends State<DropdownInputField> {
//   List<dynamic>? list_item;
//   dynamic dropdownValue;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     init();
//   }

//   void init() {
//     list_item = widget.listItem;
//     dropdownValue = list_item?.first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<dynamic>(
//       initialSelection: dropdownValue,
//       dropdownMenuEntries:
//           list_item!.map<DropdownMenuEntry<dynamic>>((dynamic value) {
//         return DropdownMenuEntry<dynamic>(
//           value: list_item,
//           label: value['name'], // Assuming 'name' is the field to be displayed
//         );
//       }).toList(),
//       onSelected: (dynamic value) {
//         // This is called when the user selects an item.
//         setState(() {
//           // dropdownValue = value;
//           // widget.value = value.toString();
//           // dbg(widget.value);
//         });
//       },
//     );
//   }
// }

