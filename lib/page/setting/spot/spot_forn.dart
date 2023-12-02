import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/component/text_field_input.dart';
import 'package:MrCarwash/page/setting/item/item.dart';
import 'package:MrCarwash/page/setting/spot/spot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SpotFrom extends StatelessWidget {
  SpotFrom({Key? key, int? id_spot}) : super(key: key) {
    this.id_spot = id_spot;
  }

  int? id_spot;
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
            MySpotForm(
              id_spot: id_spot,
            ),
          ],
        ),
      ),
    );
  }

  Widget header(context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Handle back button tap
            nav_to(context, SpotList());
          },
          child: Container(
            height: 50,
            alignment: Alignment.topLeft,
            child: Image.asset('assets/back.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Spot Form',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class MySpotForm extends StatefulWidget {
  MySpotForm({Key? key, int? id_spot}) : super(key: key) {
    this.id_spot = id_spot;
  }

  int? id_spot;
  @override
  State<MySpotForm> createState() => _MySpotFormState();
}

class _MySpotFormState extends State<MySpotForm> {
  Req? req;
  TextFieldInput? spot_name;

  dynamic ins_payload = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    req = Req(context);
    await req?.init();

    if (widget.id_spot != null) {
      var req_data_spot = await req?.getSpotById(widget.id_spot);
      dbg(req_data_spot);
      setState(() {
        spot_name = TextFieldInput(
          field_name: "Spot Name",
          initialValue: req_data_spot?['response']['name'],
        );
        spot_name?.value = req_data_spot?['response']['name'];
      });
    } else {
      setState(() {
        spot_name = TextFieldInput(field_name: "Spot Name");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 9,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: spot_name ?? Text("Wait For Field...."),
              )),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    ins_payload['name'] = spot_name?.value;
                  });
                  if (widget.id_spot != null) {
                    var req_update_spot =
                        await req?.updateSpot(widget.id_spot, ins_payload);
                    if (req_update_spot?['status_code'] == 202) {
                      showDialogAndMove(
                          context, "Success", "Update Success", SpotList());
                      // dbg(req_update_spot);
                    } else {
                      show_dialog(context, "Error",
                          req_update_spot?['response'].toString());
                      // dbg(req_update_spot);
                    }
                  } else {
                    var req_insert_spot = await req?.insertSpot(ins_payload);
                    if (req_insert_spot?['status_code'] == 200) {
                      showDialogAndMove(
                          context, "Success", "Insert Success", SpotList());
                    } else {
                      show_dialog(context, "Error",
                          req_insert_spot?['response'].toString());
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Text(
                    "Submit",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
