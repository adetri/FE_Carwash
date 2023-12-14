import 'package:MrCarwash/inc/method.dart';
import 'package:flutter/material.dart';

class CheckBoxField extends StatefulWidget {
  final String tittle;
  bool? value;
  CheckBoxField({Key? key, required this.tittle, double? fontSize}) {
    this.fontSize = fontSize;
  }

  double? fontSize;
  @override
  _CheckBoxFieldState createState() => _CheckBoxFieldState();
}

class _CheckBoxFieldState extends State<CheckBoxField> {
  String? text;
  double font_size = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() {
    text = widget.tittle;
    font_size = (widget.fontSize == null ? 20 : widget.fontSize)!;
    dbg(font_size);
  }

  bool isChecked = false; // Initial value of checkbox

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text.toString(),
          style: TextStyle(fontSize: font_size, fontWeight: FontWeight.w500),
        ),
        Checkbox(
          value: isChecked, // Current state of the checkbox
          onChanged: (bool? value) {
            // Function called when the state of the checkbox changes
            setState(() {
              isChecked = value ?? false;
              widget.value = isChecked;
              // dbg(widget.value); // Update the state of the checkbox
            });
          },
        ),
      ],
    );
  }
}

class TestRunCheckbox extends StatelessWidget {
  const TestRunCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkbox Example'),
      ),
      body: Center(
        child: CheckBoxField(
          tittle: "Stock ",
        ),
      ),
    );
  }
}
