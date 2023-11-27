import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/db.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Req {
  final dbHelper = DatabaseHelper();
  String? host;
  String? jwt;
  final BuildContext context;
  final timeout = 5;

  Req(this.context) {}

  Future<void> init() async {
    dynamic data = await dbHelper.getJwtHost();
    host = data['host'];
    jwt = data['jwt'];
    print("this execute");
  }

  Future<String> getHost() async {
    if (host != null) {
      return host!;
    }
    host = await dbHelper.getHost() ?? 'cantgethost';
    print("host init");
    return host!;
  }

  Future<String> getJWT() async {
    if (jwt != null) {
      return jwt!;
    }
    jwt = await dbHelper.getJWT() ?? 'cantgetjwt';
    print("jwt init");

    return jwt!;
  }

  Future<Map<String, dynamic>> login(dynamic paylod) async {
    String apiUrl = '$host/ath/login'; // Replace with your API endpoint
    print("this host $apiUrl");

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

  dynamic fetchMonitoring() async {
    String apiUrl = '$host/order/get-spot'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
      // Replace with your authentication token
    };
    print("this host $apiUrl");
    try {
      final response = await http
          .get(Uri.parse(apiUrl), headers: headers)
          .timeout(Duration(seconds: timeout));

      req_validation(context, response.statusCode);
      if (response.statusCode == 200) {
        return {"status_code": response.statusCode, "response": response.body};
      } else {
        return {
          "status_code": response.statusCode,
          "response": "Failed to load data. Status code"
        };
      }
    } catch (e) {
      request_failed(context, e.toString());
    }
  }
}
