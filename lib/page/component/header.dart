import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/login.dart';
import 'package:flutter/material.dart';

class MyHeader extends StatefulWidget {
  var prev_page;
  var title;
  MyHeader({this.prev_page, this.title});
  @override
  State<MyHeader> createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  @override
  Req? r;
  String? karyawan_name;

  void initState() {
    // TODO: implement initState
    super.initState();
    startup();
  }

  void startup() async {
    r = Req(context);
    await r?.init();
    var check_auth = await r?.tyrAuth();
    if (check_auth?['status_code'] != 200) {
      dbg("you're not auth");
      showDialogAndMove(context, "", "Season End", Login());
    } else {
      dbg("still auth");
    }

    setState(() {
      karyawan_name = r?.karyawan_name;
      dbg(karyawan_name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Handle back button tap
            nav_to(context, widget.prev_page);
          },
          child: Container(
            height: 50,
            alignment: Alignment.topLeft,
            child: Image.asset('assets/back.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          widget.title.toString(),
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            karyawan_name.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
