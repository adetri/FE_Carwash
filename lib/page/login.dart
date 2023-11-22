import 'package:flutter/material.dart';
import 'package:flutter_application_1/env.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:flutter_application_1/page/main_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? Username;
  String? Password;
  dynamic paylod = {"username": "", "password": ""};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Map<String, dynamic>> login() async {
    String apiUrl = '$APIHOST/ath/login'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(paylod),
    );

    return {"status_code": response.statusCode, "response": response.body};
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

                  Map<String, dynamic> send_req = await login();
                  String accessToken =
                      json.decode(send_req['response'])['access'];

                  if (send_req['status_code'] == 200) {
                    JWT = accessToken;
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
