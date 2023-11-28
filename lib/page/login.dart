import 'package:flutter/material.dart';
import 'package:flutter_application_1/env.dart';
import 'package:flutter_application_1/inc/db.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:flutter_application_1/inc/req.dart';
import 'package:flutter_application_1/page/main_menu.dart';

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
    await dbHelper.updateHost();
    req = Req(context); // Create an instance of 'Req' using the context
    await req?.init();

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
                  String accessToken =
                      json.decode(send_req['response'])['access'];

                  if (send_req['status_code'] == 200) {
                    dbg(send_req['status_code']);
                    JWT = accessToken;

                    int rowsAffected = await dbHelper.updateJWT(accessToken);
                    print('Rows affected: $rowsAffected');

                    to_main_menu(context);
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
