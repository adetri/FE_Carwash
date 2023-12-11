import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/component/dropdown_field_input.dart';
import 'package:MrCarwash/page/component/header.dart';
import 'package:MrCarwash/page/component/text_field_input.dart';
import 'package:MrCarwash/page/setting/karyawan/karyawan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  UserForm({super.key});
  var header = MyHeader(prev_page: KaryawanList(), title: "User");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            SizedBox(height: 25),
            MyUserForm(),
            // MyKaryawanForm(
            //   id_karyawan: id_karyawan,
            // ),

            // header(context),
            // SizedBox(height: 25),
            // CatForm(id_category: id_category),
          ],
        ),
      ),
    );
  }
}

class MyUserForm extends StatefulWidget {
  const MyUserForm({super.key});

  @override
  State<MyUserForm> createState() => _MyUserFormState();
}

class _MyUserFormState extends State<MyUserForm> {
  TextFieldInput Username = TextFieldInput(field_name: "Username");
  TextFieldInput password = TextFieldInput(
    field_name: "Password",
    inputType: 'password',
  );
  Req? req;
  List<dynamic>? valid_karyawan;
  DropdownInputField? karyawan_val;

  Map<String, dynamic> payload = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    req = Req(context);
    await req?.init();
    var req_valid_karyawan = await req?.validateKaryawan();
    dbg(req_valid_karyawan);
    setState(() {
      valid_karyawan = req_valid_karyawan?['response'];
      karyawan_val = DropdownInputField(listItem: valid_karyawan);
    });
  }

  bool submit_btn = true;
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
                  child: Username ?? SizedBox.shrink(),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: password ?? SizedBox.shrink(),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: karyawan_val ?? SizedBox.shrink(),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Visibility(
                    visible: submit_btn,
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            submit_btn = false;
                            payload['username'] = Username.value;
                            payload['password'] = password.value;
                            payload['karyawan'] = karyawan_val?.value;
                          });

                          if (Username?.value == null ||
                              Username!.value!.isEmpty) {
                            dbg(Username?.value);
                            show_dialog(context, "Form Requiere",
                                "Username cant be Null");
                            setState(() {
                              submit_btn = true;
                            });
                            return;
                          }

                          if (password?.value == null ||
                              password!.value!.isEmpty) {
                            dbg(password?.value);
                            show_dialog(context, "Form Requiere",
                                "Password cant be Null");
                            setState(() {
                              submit_btn = true;
                            });
                            return;
                          }

                          if (karyawan_val?.value == null ||
                              karyawan_val!.value!.isEmpty) {
                            dbg(karyawan_val?.value);
                            show_dialog(context, "Form Requiere",
                                "Employee cant be Null");
                            setState(() {
                              submit_btn = true;
                            });
                            return;
                          }

                          var req_add_user = await req?.createUser(payload);
                          if (req_add_user?['status_code'] == 201) {
                            showDialogAndMove(context, "Success",
                                "Success Insert Data", KaryawanList());
                          } else {
                            show_dialog(context, "Fail", "Failed To Insert");
                          }

                          dbg(req_add_user);
                        },
                        child: Text("Submit")),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
