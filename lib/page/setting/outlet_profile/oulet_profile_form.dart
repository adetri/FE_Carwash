import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/component/header.dart';
import 'package:MrCarwash/page/component/img_field_input.dart';
import 'package:MrCarwash/page/component/text_field_input.dart';
import 'package:MrCarwash/page/setting/setting.dart';
import 'package:flutter/material.dart';

class OutletProfiles extends StatelessWidget {
  OutletProfiles({super.key});
  var header = MyHeader(prev_page: Settings(), title: "Outlet Profile");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            SizedBox(height: 25),
            OutletProfileForm()
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

class OutletProfileForm extends StatefulWidget {
  const OutletProfileForm({super.key});

  @override
  State<OutletProfileForm> createState() => _OutletProfileFormState();
}

class _OutletProfileFormState extends State<OutletProfileForm> {
  Map<String, dynamic>? outlet;
  Map<String, dynamic> payload = {};

  Req? req;
  ImageInputField? foto_outlet;
  TextFieldInput? name_outlet;
  TextFieldInput? phone_outlet;
  TextFieldInput? email_outle;
  TextFieldInput? adress_outle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    req = Req(context);
    await req?.init();
    var req_outlet = await req?.getOutlet();
    dbg(req_outlet);

    setState(() {
      outlet = req_outlet?['response'];
      String img_outlet = "${req?.host}${outlet?['img']}";
      foto_outlet = ImageInputField(
        base64: null,
        imgUrl: img_outlet,
      );
      name_outlet = TextFieldInput(
        field_name: "Outlet Name",
        initialValue: outlet?['name'].toString(),
      );
      name_outlet?.value = outlet?['name'].toString();

      phone_outlet = TextFieldInput(
        field_name: "Outlet Phone",
        initialValue: outlet?['phone'].toString(),
        inputType: "number",
      );
      phone_outlet?.value = outlet?['phone'].toString();

      email_outle = TextFieldInput(
        field_name: "Outlet Email",
        initialValue: outlet?['email'].toString(),
        inputType: "email",
      );
      email_outle?.value = outlet?['email'].toString();

      adress_outle = TextFieldInput(
        field_name: "Outlet Address",
        initialValue: outlet?['address'].toString(),
        inputType: "textarea",
      );
      adress_outle?.value = outlet?['address'].toString();
    });
  }

  bool submit_btn = true;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: foto_outlet ?? SizedBox.shrink(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: name_outlet ?? SizedBox.shrink(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: phone_outlet ?? SizedBox.shrink(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: email_outle ?? SizedBox.shrink(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: adress_outle ?? SizedBox.shrink(),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                child: adress_outle != null
                    ? Visibility(
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                submit_btn = false;
                                if (foto_outlet?.base64 != null) {
                                  payload['img'] = foto_outlet?.base64;
                                }
                                payload['name'] = name_outlet?.value;
                                payload['phone'] = phone_outlet?.value;
                                payload['address'] = adress_outle?.value;
                                payload['email'] = email_outle?.value;
                              });

                              if (name_outlet?.value == null ||
                                  name_outlet!.value!.isEmpty) {
                                dbg(name_outlet?.value);
                                show_dialog(context, "Form Requiere",
                                    "Outlet name cant be Null");
                                setState(() {
                                  submit_btn = true;
                                });
                                return;
                              }

                              if (phone_outlet?.value == null ||
                                  phone_outlet!.value!.isEmpty) {
                                dbg(phone_outlet?.value);
                                show_dialog(context, "Form Requiere",
                                    "Outlet phone cant be Null");
                                setState(() {
                                  submit_btn = true;
                                });
                                return;
                              }

                              if (adress_outle?.value == null ||
                                  adress_outle!.value!.isEmpty) {
                                dbg(adress_outle?.value);
                                show_dialog(context, "Form Requiere",
                                    "Outlet address cant be Null");
                                setState(() {
                                  submit_btn = true;
                                });
                                return;
                              }
                              if (email_outle?.value == null ||
                                  email_outle!.value!.isEmpty) {
                                dbg(email_outle?.value);
                                show_dialog(context, "Form Requiere",
                                    "Outlet email cant be Null");
                                setState(() {
                                  submit_btn = true;
                                });
                                return;
                              }
                              dbg(payload);
                              var req_update_outlet =
                                  await req?.updateOutlet(payload);
                              if (req_update_outlet?['status_code'] == 202) {
                                showDialogAndMove(context, "Success",
                                    "Update Data Success", Settings());
                              } else {
                                show_dialog(
                                    context, "Failed", "Failed to update data");
                              }
                              dbg(req_update_outlet);
                              setState(() {
                                submit_btn = true;
                              });
                              // {"id":1,"name":null,"phone":null,"address":"","img":"/media/outlet/spot.png","email":null}
                            },
                            child: Text("Submint")))
                    : SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
