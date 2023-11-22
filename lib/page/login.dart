import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                onChanged: (num) {
                  setState(() {
                    // nominal = int.parse(num);

                    // print(nominal);
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
                  // Handle the password input
                  // For example, you can store it in a variable or perform validation
                  print(password);
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
}
