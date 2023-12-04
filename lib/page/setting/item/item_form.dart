import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/component/dropdown_field_input.dart';
import 'package:MrCarwash/page/component/img_field_input.dart';
import 'package:MrCarwash/page/component/text_field_input.dart';
import 'package:MrCarwash/page/setting/item/item.dart';

class ItemForm extends StatelessWidget {
  ItemForm({Key? key, int? id_item}) : super(key: key) {
    this.id_item = id_item;
  }
  int? id_item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context),
            Myform(
              idItem: id_item,
            )
          ],
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
  Myform({Key? key, int? idItem}) : super(key: key) {
    this.idItem = idItem;
  }
  int? idItem;
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
  int sub_item_count = 1;
  int sub_item_minum_form = 1;
  List<dynamic> sub_item = [{}];
  List<dynamic> sub_item_existing = [{}];

  Map<String, dynamic>? payload = {'main_item': {}};
  Map<String, dynamic>? payload_update = {'mainitem': {}};

  dynamic subItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    dbg("init Page Start ${widget.idItem}");
    req = Req(context);
    await req?.init();
    var req_category = await req?.fetchCategory2();
    dbg(req_category);

    setState(() {
      category_list = req_category?['response']['category'];
    });
    if (widget.idItem != null) {
      var req_get_item = await req?.getItem(widget.idItem);
      dbg(req_get_item);

      setState(() {
        dbg("category list ${category_list}");
        sub_item_count = 0;
        sub_item_minum_form = 0;
      });

      setState(() {
        subItems = req_get_item?['response']['mainitem']['sub_item'];
        sub_item_existing = subItems;
        dbg("subItems is ${subItems}");

        item_name = TextFieldInput(
          field_name: "Item Name",
          initialValue: req_get_item?['response']['mainitem']['name'],
        );
        item_name?.value =
            req_get_item?['response']['mainitem']['name'].toString();

        price = TextFieldInput(
            field_name: "Item Price",
            inputType: "number",
            initialValue:
                req_get_item?['response']['mainitem']['price'].toString());
        price?.value =
            req_get_item?['response']['mainitem']['price'].toString();

        categoryItem = DropdownInputField(
            listItem: category_list,
            id_category: req_get_item?['response']['mainitem']['category']
                ['id']);
        categoryItem?.value =
            req_get_item?['response']['mainitem']['category']['id'].toString();

        imgField = ImageInputField(
            base64: null,
            imgUrl:
                "${req?.host}${req_get_item?['response']['mainitem']['img']}");
      });
    } else {
      setState(() {
        subItemName = TextFieldInput(field_name: "Sub Item Name");
        subItemPrice = TextFieldInput(
          field_name: "Sub Item Price",
          inputType: "number",
        );
        dbg(category_list);
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
    }

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
                      flex: 6,
                      child: Text(
                        "Sub Item",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
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
                      flex: 2,
                      child: Container(
                        // color: Colors.amberAccent,
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (sub_item_count > sub_item_minum_form) {
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
              widget.idItem != null ? subItemFormExisting() : SizedBox.shrink(),
              subItemForm(),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.idItem != null) {
                      setState(() {
                        payload_update!['mainitem']['sub_item'] =
                            sub_item_existing;

                        if (sub_item[0].length > 1) {
                          payload_update!['mainitem']['new_sub_item'] =
                              sub_item;
                        }
                        dbg("subleb : ${sub_item[0].length}");
                        payload_update!['mainitem']['name'] = item_name?.value;
                        payload_update!['mainitem']['price'] = price?.value;
                        payload_update!['mainitem']['category'] =
                            categoryItem?.value;
                        if (imgField?.base64 != null) {
                          payload_update!['mainitem']['img'] = imgField?.base64;
                        }
                      });
                      var req_upd_item =
                          await req?.updateItem(widget.idItem, payload_update);

                      if (req_upd_item!['status_code'] == 202) {
                        showDialogAndMove(context, 'Succes',
                            'Update data success', ItemList());
                      } else {
                        show_dialog(context, 'Fail to insert',
                            req_upd_item['response']);
                      }
                      dbg(payload_update);

                      dbg(req_upd_item);
                    } else {
                      if (sub_item[0].length > 1) {
                        payload!['main_item']['sub_item'] = sub_item;
                        dbg("this execute and sub item len is ${sub_item.length}");
                      }
                      payload!['main_item']['name'] = item_name?.value;
                      payload!['main_item']['price'] = price?.value;
                      payload!['main_item']['category'] = categoryItem?.value;
                      payload!['main_item']['img'] = imgField?.base64;
                      dbg(payload);
                      var req_ins_item = await req?.insertItem(payload);
                      if (req_ins_item!['status_code'] == 201) {
                        showDialogAndMove(context, 'Succes',
                            'Insert data success', ItemList());
                      } else {
                        show_dialog(context, 'Fail to insert',
                            req_ins_item['response']);
                      }
                      dbg(payload);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      "Submit",
                      textAlign: TextAlign.center,
                    ),
                  ),
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

  Column subItemFormExisting() {
    return Column(
      children: List.generate(subItems != null ? subItems.length : 0, (index) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller:
                          TextEditingController(text: subItems[index]['name']),
                      onChanged: (value) {
                        sub_item_existing[index]['name'] = value;
                        dbg(sub_item);
                      },
                      decoration: InputDecoration(
                        labelText: "Sub Item Name",
                        hintText: "Sub Item Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextField(
                        controller: TextEditingController(
                            text: subItems[index]['price'].toString()),
                        onChanged: (value) {
                          sub_item_existing[index]['price'] = value;
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
                ]),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    dbg("object");
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            ],
          ),
        );
      }),
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

  // Column subItemFormExisting() {
  //   return Column(
  //     children: List.generate(subItems != null ? subItems.length : 0, (index) {
  //       return Container(
  //         margin: EdgeInsets.only(top: 10),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Expanded(
  //                   flex: 9,
  //                   child: Container(
  //                     margin: EdgeInsets.only(top: 10),
  //                     child: TextField(
  //                       controller: TextEditingController(
  //                           text: subItems[index]['name']),
  //                       onChanged: (value) {
  //                         sub_item_existing[index]['name'] = value;
  //                         dbg(sub_item);
  //                       },
  //                       decoration: InputDecoration(
  //                         labelText: "Sub Item Name",
  //                         hintText: "Sub Item Name",
  //                         border: OutlineInputBorder(),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                     child: IconButton(
  //                         onPressed: () {
  //                           dbg("object");
  //                         },
  //                         icon: Icon(Icons.delete)))
  //               ],
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(top: 10),
  //               child: TextField(
  //                   controller: TextEditingController(
  //                       text: subItems[index]['price'].toString()),
  //                   onChanged: (value) {
  //                     sub_item_existing[index]['price'] = value;
  //                     dbg(sub_item);
  //                   },
  //                   decoration: InputDecoration(
  //                     labelText: "Sub Item Price",
  //                     hintText: "Sub Item Price",
  //                     border: OutlineInputBorder(),
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                   inputFormatters: <TextInputFormatter>[
  //                     FilteringTextInputFormatter.digitsOnly,
  //                     You can add more formatters if needed, for instance, to limit the length
  //                     LengthLimitingTextInputFormatter(5), // Allows only 5 characters
  //                   ]

  //                   Additional properties and handlers for the TextField
  //                   ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }),
  //   );
  // }

