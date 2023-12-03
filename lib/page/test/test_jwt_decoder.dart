import 'package:MrCarwash/inc/method.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TestJwtDecoder extends StatefulWidget {
  const TestJwtDecoder({super.key});

  @override
  State<TestJwtDecoder> createState() => _TestJwtDecoderState();
}

class _TestJwtDecoderState extends State<TestJwtDecoder> {
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzAxNjM3Nzk1LCJpYXQiOjE3MDE2MTk3OTUsImp0aSI6ImJjOTI4MjI0ZjNmZDRjMmZhNjVlMzE5ZjU0ZWI2ODM3IiwidXNlcl9pZCI6MX0.vDo5Z4C0jEk1bAtFW2mJkcVgSe_NgK5z-Gu29k_8rk0";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ElevatedButton(
            onPressed: () {
              Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
              bool isTokenExpired = JwtDecoder.isExpired(token);
              print(decodedToken["user_id"]);
              if (!isTokenExpired) {
                // The user should authenticate
              }

              DateTime expirationDate = JwtDecoder.getExpirationDate(token);

              // 2025-01-13 13:04:18.000
              print(expirationDate);

              /* getTokenTime() - You can use this method to know how old your token is */
              Duration tokenTime = JwtDecoder.getTokenTime(token);

              // 15
              print(tokenTime.inDays);
            },
            child: Text(" Push this ")),
      ),
    );
  }
}
