import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/component/dropdown_field_input.dart';
import 'package:MrCarwash/page/component/header.dart';
import 'package:MrCarwash/page/component/text_field_input.dart';
import 'package:MrCarwash/page/setting/karyawan/karyawan.dart';
import 'package:MrCarwash/page/setting/setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KaryawanForm extends StatelessWidget {
  KaryawanForm({Key? key, int? id_karyawan}) : super(key: key) {
    this.id_karyawan = id_karyawan;
  }
  int? id_karyawan;
  var header = MyHeader(prev_page: KaryawanList(), title: "Employee");

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
            MyKaryawanForm(
              id_karyawan: id_karyawan,
            ),

            // header(context),
            // SizedBox(height: 25),
            // CatForm(id_category: id_category),
          ],
        ),
      ),
    );
  }
}

class MyKaryawanForm extends StatefulWidget {
  MyKaryawanForm({Key? key, int? id_karyawan}) : super(key: key) {
    this.id_karyawan = id_karyawan;
  }
  int? id_karyawan;

  @override
  State<MyKaryawanForm> createState() => _MyKaryawanFormState();
}

class _MyKaryawanFormState extends State<MyKaryawanForm> {
  Req? req;
  TextFieldInput? karyawan_name;
  DropdownInputField? karyawan_role;
  TextFieldInput? karyawan_phone;
  List<dynamic>? role;
  Map<String, dynamic> payload = {};
  Map<String, dynamic>? karyawan;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    dbg(" this id karyawn ${widget.id_karyawan}");
    req = Req(context);
    await req?.init();
    var req_role = await req?.fechRole();
    dbg(req_role);

    setState(() {
      role = req_role?['response']['role'];
    });

    if (widget.id_karyawan != null) {
      var req_karyawan = await req?.getKaryawan(widget.id_karyawan);

      dbg(req_karyawan);

      setState(() {
        karyawan = req_karyawan?['response']['pegawai'];
        karyawan_name = TextFieldInput(
          field_name: "Empoyee Name",
          initialValue: karyawan?['name'],
        );
        karyawan_name?.value = karyawan?['name'];

        karyawan_phone = TextFieldInput(
          field_name: "Empoyee Phone",
          inputType: 'number',
          initialValue: karyawan?['phone'].toString(),
        );
        karyawan_phone?.value = karyawan?['phone'].toString();

        karyawan_role = DropdownInputField(
          listItem: role,
          id_category: karyawan?['role']['id'],
        );
        karyawan_role?.value = karyawan?['role']['id'].toString();
      });
    } else {
      setState(() {
        karyawan_name = TextFieldInput(field_name: "Empoyee Name");
        karyawan_phone = TextFieldInput(
          field_name: "Empoyee Phone",
          inputType: 'number',
        );
        karyawan_role = DropdownInputField(listItem: role);
      });
    }
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
                child: karyawan_name ?? SizedBox.shrink(),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: karyawan_phone ?? SizedBox.shrink(),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: karyawan_role ?? SizedBox.shrink(),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Visibility(
                  visible: submit_btn,
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          submit_btn = false;
                          payload['name'] = karyawan_name?.value;
                          payload['phone'] = karyawan_phone?.value;
                          payload['role'] = karyawan_role?.value;
                        });

                        if (karyawan_name?.value == null ||
                            karyawan_name!.value!.isEmpty) {
                          dbg(karyawan_name?.value);
                          show_dialog(context, "Form Requiere",
                              "Employee name cant be Null");
                          setState(() {
                            submit_btn = true;
                          });
                          return;
                        }

                        if (karyawan_phone?.value == null ||
                            karyawan_phone!.value!.isEmpty) {
                          dbg(karyawan_phone?.value);
                          show_dialog(context, "Form Requiere",
                              "Employee phone cant be Null");
                          setState(() {
                            submit_btn = true;
                          });
                          return;
                        }
                        if (karyawan_role?.value == null ||
                            karyawan_role!.value!.isEmpty) {
                          dbg(karyawan_role?.value);
                          show_dialog(context, "Form Requiere",
                              "Employee role cant be Null");
                          setState(() {
                            submit_btn = true;
                          });
                          return;
                        }

                        if (widget.id_karyawan != null) {
                          var req_update_karyawan = await req?.updateKaryawan(
                              widget.id_karyawan, payload);
                          if (req_update_karyawan?['status_code'] == 202) {
                            showDialogAndMove(context, "Success",
                                "Insert Data Success", KaryawanList());
                          } else {
                            dbg(req_update_karyawan);
                            show_dialog(
                                context, "Failed", "Failed to update data");
                          }
                        } else {
                          var req_create_karyawan =
                              await req?.createKaryawan(payload);

                          if (req_create_karyawan?['status_code'] == 201) {
                            showDialogAndMove(context, "Success",
                                "Insert Data Success", KaryawanList());
                          } else {
                            dbg(req_create_karyawan);
                            show_dialog(
                                context, "Failed", "Failed to add data");
                          }

                          dbg(req_create_karyawan);
                        }

                        setState(() {
                          submit_btn = true;
                        });
                      },
                      child: Text("Submit")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
