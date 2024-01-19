import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MrCarwash/inc/method.dart';

class TextFieldInput extends StatefulWidget {
  TextFieldInput(
      {super.key,
      String? initialValue,
      String? inputType,
      String? errorMsg,
      required String field_name}) {
    this.initialValue = initialValue;
    this.field_name = field_name;
    this.inputType = inputType;
  }
  late String field_name;
  String? value;
  String? initialValue;
  String? inputType;
  String? errorMsg;
  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  String? output;
  late TextEditingController _controller;
  String? input_type;
  @override
  void initState() {
    super.initState();

    if (widget.inputType != null) {
      input_type = widget.inputType;
    } else {
      input_type = "text";
    }

    dbg(input_type);
    // Initialize the controller with the provided initial value
    _controller = TextEditingController(text: widget.initialValue);
    // Listen for changes in the TextField
    _controller.addListener(() {
      setState(() {
        output = _controller.text;
        update_value(output);
      });
    });

    dbg("this textfield called??");
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
    return Container(
      // color: Colors.amber,
      height: input_type == "textarea" ? 120 : 80,
      child: Column(
        children: [
          TextField(
              maxLines: input_type == "textarea" ? 3 : 1, //or null
              controller: _controller, // Set the controller for the TextField
              decoration: InputDecoration(
                labelText: widget.field_name,
                hintText: widget.field_name,
                border: OutlineInputBorder(),
              ),
              obscureText: input_type == 'password'
                  ? true
                  : false, // Set this to true for a password field
              keyboardType: input_type == 'number'
                  ? TextInputType.number
                  : input_type == 'email'
                      ? TextInputType.emailAddress
                      : TextInputType.text,
              inputFormatters: input_type == 'number'
                  ? <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      // You can add more formatters if needed, for instance, to limit the length
                      // LengthLimitingTextInputFormatter(5), // Allows only 5 characters
                    ]
                  : null
              // Additional properties and handlers for the TextField
              ),
          widget.errorMsg != null
              ? Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 2, left: 3),
                  // color: Colors.amberAccent,
                  child: Text(
                    widget.errorMsg.toString(),
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
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
