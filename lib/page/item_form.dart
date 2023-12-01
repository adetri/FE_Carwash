import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:flutter_application_1/inc/req.dart';
import 'package:flutter_application_1/page/component/dropdown_field_input.dart';
import 'package:flutter_application_1/page/component/img_field_input.dart';
import 'package:flutter_application_1/page/component/text_field_input.dart';
import 'package:flutter_application_1/page/item.dart';

class ItemForm extends StatelessWidget {
  const ItemForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header(context), Myform()],
        ),
      ),
    );
  }

  Widget header(context) {
    print("this exec");
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Handle back button tap
            nav_to(context, ItemList());
          },
          child: Container(
            height: 50,
            alignment: Alignment.topLeft,
            child: Image.asset('assets/back.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Item Form',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Myform extends StatefulWidget {
  const Myform({super.key});

  @override
  State<Myform> createState() => _MyformState();
}

class _MyformState extends State<Myform> {
  TextFieldInput? item_name;
  TextFieldInput? price;
  ImageInputField? imgField;
  DropdownInputField? categoryItem;
  Req? req;
  TextFieldInput? subItemName;
  TextFieldInput? subItemPrice;

  List<dynamic>? category_list;

  int sub_item_count = 0;
  List<dynamic> sub_item = [{}];
  Map<String, dynamic>? payload;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    dbg("init Page Start");
    req = Req(context);
    await req?.init();
    var req_category = await req?.fetchCategory2();

    setState(() {
      subItemName = TextFieldInput(field_name: "Sub Item Name");
      subItemPrice = TextFieldInput(
        field_name: "Sub Item Price",
        inputType: "number",
      );

      category_list = req_category?['response']['category'];
      categoryItem = DropdownInputField(listItem: category_list);
      item_name = TextFieldInput(field_name: "Item Name");
      price = TextFieldInput(
        field_name: "Item Price",
        inputType: "number",
      );
      imgField = ImageInputField(
        base64: null,
      );
    });

    dbg("init Page End");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: imgField,
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                child: item_name ?? SizedBox.shrink(),
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                child: price ?? SizedBox.shrink(),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 10),
                  child: categoryItem ?? SizedBox.shrink()),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Sub Item",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.amberAccent,
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (sub_item_count < 4) {
                                sub_item_count += 1;

                                if (sub_item.length < sub_item_count) {
                                  sub_item.add({});
                                }
                              }
                            });
                            dbg("print");
                          },
                          icon: Icon(Icons.add_circle_outline),
                        ),

                        // Icon(Icons.add_circle_outline),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.amberAccent,
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (sub_item_count > 1) {
                                sub_item_count -= 1;

                                sub_item.removeLast();
                              }
                            });
                          },
                          icon: Icon(Icons.remove_circle_outline),
                        ),

                        // Icon(Icons.add_circle_outline),
                      ),
                    ),
                  ],
                ),
              ),
              subItemForm(),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    dbg(subItemName?.value);
                  },
                  child: Text("Submit"),
                ),
              ),

              // Expanded(child: item_name ?? Text("")),
              // Expanded(child: price ?? Text(""))
            ],
          ),
        ),
      ),
    );
  }

  Column subItemForm() {
    return Column(
      children: List.generate(sub_item_count, (index) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextField(
                  onChanged: (value) {
                    sub_item[index]['name'] = value;
                    dbg(sub_item);
                  },
                  decoration: InputDecoration(
                    labelText: "Sub Item Name",
                    hintText: "Sub Item Name",
                    border: OutlineInputBorder(),
                  ),
                  // keyboardType: input_type == 'number'
                  //     ? TextInputType.number
                  //     : TextInputType.text,
                  // inputFormatters: input_type == 'number'
                  //     ? <TextInputFormatter>[
                  //         FilteringTextInputFormatter.digitsOnly,
                  //         // You can add more formatters if needed, for instance, to limit the length
                  //         // LengthLimitingTextInputFormatter(5), // Allows only 5 characters
                  //       ]
                  //     : null
                  // // Additional properties and handlers for the TextField
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextField(
                    onChanged: (value) {
                      sub_item[index]['price'] = value;
                      dbg(sub_item);
                    },
                    decoration: InputDecoration(
                      labelText: "Sub Item Price",
                      hintText: "Sub Item Price",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      // You can add more formatters if needed, for instance, to limit the length
                      // LengthLimitingTextInputFormatter(5), // Allows only 5 characters
                    ]

                    // Additional properties and handlers for the TextField
                    ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
