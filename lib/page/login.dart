import 'package:flutter/material.dart';
import 'package:MrCarwash/env.dart';
import 'package:MrCarwash/inc/db.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/main_menu.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'dart:convert';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final dbHelper = DatabaseHelper();

  String? Username;
  String? Password;
  dynamic paylod = {"username": "", "password": ""};

  Req? req;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateHostAndCreateReq();
  }

  Future<void> updateHostAndCreateReq() async {
    dbHelper.checkvalid();
    await dbHelper.updateHost();

    req = Req(context); // Create an instance of 'Req' using the context
    await req?.init();

    dbg(req?.host);

    var try_auth = await req?.tyrAuth();
    dbg(try_auth);
    if (try_auth?['status_code'] == 200) {
      dbg("this execute");
      to_main_menu(context);
    }

    // Use 'req' instance as needed
  }

  void checkhost() async {
    List<Map<String, dynamic>> tasks = await dbHelper.getTasksById(1);
    if (tasks.isNotEmpty) {
      // Handle retrieved tasks here...
      print('Task with ID 1: ${tasks.first}');
    } else {
      print('Task not found for ID: 1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: 400,
              height: 400,
              alignment: Alignment.center,
              child: Image.asset('assets/logo.png'),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                onChanged: (usr) {
                  setState(() {
                    // nominal = int.parse(num);
                    Username = usr;
                    print(Username);
                  });
                },
                // keyboardType: TextInputType.number,
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.digitsOnly,
                //   // You can add more formatters if needed, for instance, to limit the length
                //   // LengthLimitingTextInputFormatter(5), // Allows only 5 characters
                // ],
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Username',
                  border: OutlineInputBorder(),
                ),
                // Additional properties and handlers for the TextField
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                onChanged: (password) {
                  setState(() {
                    // nominal = int.parse(num);
                    Password = password;
                    print(Password);
                  });
                },
                obscureText: true, // Set this to true for a password field
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() async {
                  if (Username == null) {
                    MyDialogHelper.title = 'Username Require';
                    MyDialogHelper.content = 'Username Cant Empty';
                    MyDialogHelper.showDialogMethod(context);
                    return;
                  }
                  if (Password == null) {
                    MyDialogHelper.title = 'Password Require';
                    MyDialogHelper.content = 'Password Cant Empty';
                    MyDialogHelper.showDialogMethod(context);
                    return;
                  }

                  paylod['username'] = Username;
                  paylod['password'] = Password;

                  Map<String, dynamic> send_req = await req!.login(paylod);

                  String accessToken = send_req['response']['access'];

                  if (send_req['status_code'] == 200) {
                    dbg(send_req['status_code']);
                    JWT = accessToken;

                    Map<String, dynamic> decodedToken =
                        JwtDecoder.decode(accessToken);

                    var req_get_user =
                        await req?.getUser(decodedToken["user_id"]);
                    dbg(req_get_user);
                    int id_karyawan =
                        req_get_user?['response']['user']['karyawan']['id'];
                    dbg(id_karyawan);

                    int id_role =
                        req_get_user?['response']['user']['karyawan']['role'];
                    dbg(id_role);

                    String nama_karyawan =
                        req_get_user?['response']['user']['karyawan']['name'];
                    dbg(nama_karyawan);

                    int rowsAffected = await dbHelper.updateSeason(
                        accessToken, nama_karyawan, id_karyawan, id_role);
                    print('Rows affected: $rowsAffected');
                    var get_t = await dbHelper.getSeason();
                    dbg(get_t);
                    to_main_menu(context);
                  } else {
                    show_dialog(
                        context, "Failed", "Username or Password Invalid");
                  }
                });
                // Add your button press logic here
                print('ElevatedButton pressed');
                //  Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => Monitoring(),
                //           ),
                //         );
              },
              child: Container(
                width: 200,
                child: Text(
                  'Submit',
                  textAlign: TextAlign.center,
                ),
              ), // Text displayed on the button
            )
          ],
        ),
      ),
    );
  }

  void to_main_menu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Mainmenu()),
    );
  }
}
