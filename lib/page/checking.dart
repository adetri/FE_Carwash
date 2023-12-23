import 'package:MrCarwash/inc/db.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/login.dart';
import 'package:MrCarwash/page/main_menu.dart';
import 'package:flutter/material.dart';

class CheckingPage extends StatefulWidget {
  const CheckingPage({super.key});

  @override
  State<CheckingPage> createState() => _CheckingPageState();
}

MyConfrimDialog dialog = MyConfrimDialog();

class _CheckingPageState extends State<CheckingPage> {
  final dbHelper = DatabaseHelper();
  Req? req;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    dbHelper.checkvalid();
    await dbHelper.updateHost();

    req = Req(context); // Create an instance of 'Req' using the context
    await req?.init();
    var try_auth = await req?.tyrAuth();

    if (try_auth?['status_code'] == 200) {
      nav_to(context, Mainmenu());
    } else if (try_auth?['status_code'] == 401) {
      nav_to(context, Login());
    } else {
      dbg(try_auth);
      logic_dialog(context,
          title: "Error",
          content: "Error fetching data from server",
          logic: closeApp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
