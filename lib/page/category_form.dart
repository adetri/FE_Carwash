import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:flutter_application_1/inc/req.dart';
import 'package:flutter_application_1/page/category.dart';
import 'package:flutter_application_1/page/component/Img_field_input.dart';
import 'package:flutter_application_1/page/component/text_field_input.dart';
// import 'package:flutter_application_1/page/test/test_img_field.dart';

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
  ImageInputField imgField = ImageInputField(base64: null);

  Req? req;
  TextFieldInput? category_name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    req = Req(context);
    await req?.init();
    if (widget.id_category != null) {
      dbg(widget.id_category);

      setState(() {
        category_name = TextFieldInput(
            initialValue: "asdnuasdnsaudasudnasudnsaudnu",
            field_name: "Category Name");
      });
    } else {
      setState(() {
        category_name = TextFieldInput(field_name: "Category Name");
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

                    setState(() {
                      btn_status = false;
                    });

                    dynamic payload = {
                      "name": category_name?.value,
                      "img": imgField.base64
                    };
                    print(payload);
                    // var req_ins_category = await req?.insertCategory(payload);
                    // if (req_ins_category?['status_code'] == 201) {
                    //   showDialogAndMove(context, "Success",
                    //       "Insert Data Success", CategoryList());
                    // }
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
