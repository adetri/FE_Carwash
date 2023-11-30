import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/method.dart';

class TextFieldInput extends StatefulWidget {
  TextFieldInput(
      {super.key, String? initialValue, required String field_name}) {
    this.initialValue = initialValue;
    this.field_name = field_name;
  }
  late String field_name;
  String? value;
  String? initialValue;

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  String? output;
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    // Initialize the controller with the provided initial value
    _controller = TextEditingController(text: widget.initialValue);
    // Listen for changes in the TextField
    _controller.addListener(() {
      setState(() {
        output = _controller.text;
        update_value(output);
      });
    });
  }

  void update_value(output) {
    widget.value = output;
    dbg(widget.value);
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller, // Set the controller for the TextField
      decoration: InputDecoration(
        labelText: widget.field_name,
        hintText: widget.field_name,
        border: OutlineInputBorder(),
      ),
      // Additional properties and handlers for the TextField
    );
  }
}

class TextFieldInputTesting extends StatelessWidget {
  const TextFieldInputTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextFieldInput(
        initialValue: "Test Value",
        field_name: "Test Field",
      ),
    );
  }
}
