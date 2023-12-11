import 'package:flutter/material.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/setting/category/category.dart';
import 'package:MrCarwash/page/component/img_field_input.dart';
import 'package:MrCarwash/page/component/text_field_input.dart';
// import 'package:MrCarwash/page/test/test_img_field.dart';

class CategoryForm extends StatelessWidget {
  CategoryForm({Key? key, int? id_category}) : super(key: key) {
    this.id_category = id_category;
  }
  int? id_category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context),
            SizedBox(height: 25),
            CatForm(id_category: id_category),
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
            nav_to(context, CategoryList());
          },
          child: Container(
            height: 50,
            alignment: Alignment.topLeft,
            child: Image.asset('assets/back.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Category Form',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CatForm extends StatefulWidget {
  CatForm({Key? key, int? id_category}) : super(key: key) {
    this.id_category = id_category;
  }
  int? id_category;
  @override
  State<CatForm> createState() => _CatFormState();
}

class _CatFormState extends State<CatForm> {
  TextEditingController _categoryController = TextEditingController();
  ImageInputField? imgField;

  Req? req;
  TextFieldInput? category_name;

  @override
  void initState() {
    // TODO: implement initStateR
    super.initState();
    init();
  }

  void init() async {
    req = Req(context);
    await req?.init();

    if (widget.id_category != null) {
      var req_category = await req?.getCategory(widget.id_category);
      dbg(req?.host);

      setState(() {
        imgField = ImageInputField(
          base64: null,
          imgUrl:
              "${req?.host}${req_category?['response']['category']['img'].toString()}",
        );
        category_name = TextFieldInput(
            initialValue:
                req_category?['response']['category']['name'].toString(),
            field_name: "Category Name");
        category_name?.value =
            req_category?['response']['category']['name'].toString();
      });
    } else {
      setState(() {
        category_name = TextFieldInput(field_name: "Category Name");
        imgField = ImageInputField(
          base64: null,
        );
      });
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  bool btn_status = true;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              child: imgField,
            ),
          ),
          Expanded(flex: 7, child: category_name ?? Text("")),
          Expanded(
            child: Visibility(
              visible: btn_status,
              child: Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // print(imgField.base64)
                    dynamic payload = {};
                    setState(() {
                      btn_status = false;

                      payload['name'] = category_name?.value;
                      // if (widget.id_category == null) {
                      if (imgField?.base64 != null) {
                        payload['img'] = imgField?.base64;
                      }
                      // }
                    });

                    print(payload);

                    // category validasi
                    if (widget.id_category == null &&
                        imgField?.base64 == null) {
                      show_dialog(context, "Form Requiere",
                          "Category Foto Cant be Null");
                      setState(() {
                        btn_status = true;
                      });
                      return;
                    }

                    if (category_name?.value == null ||
                        category_name!.value!.isEmpty) {
                      dbg(category_name?.value);
                      show_dialog(context, "Form Requiere",
                          "Category name cant be Null");
                      setState(() {
                        btn_status = true;
                      });
                      return;
                    }

                    if (widget.id_category == null) {
                      var req_ins_category = await req?.insertCategory(payload);
                      if (req_ins_category?['status_code'] == 201) {
                        showDialogAndMove(context, "Success",
                            "Insert Data Success", CategoryList());
                      } else {
                        show_dialog(context, "Failed",
                            req_ins_category?['response'].toString());
                      }
                    } else {
                      var req_update_category = await req?.updateCategory(
                          widget.id_category, payload);
                      if (req_update_category?['status_code'] == 202) {
                        showDialogAndMove(context, "Success",
                            "Update Data Success", CategoryList());
                      } else {
                        show_dialog(context, "Failed",
                            req_update_category?['response'].toString());
                      }
                    }

                    setState(() {
                      btn_status = true;
                    });
                    // print('Category Name: $categoryName');
                  },
                  child: Text('Submit'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
