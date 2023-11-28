import 'package:flutter/material.dart';
import 'package:flutter_application_1/env.dart';
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
  final debug = true;

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

  dynamic fetchCategory() async {
    String apiUrl =
        '$host/item/fatch-all-category'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer  $jwt', // Replace with your authentication token
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      req_validation(context, response.statusCode);

      if (response.statusCode == 200) {
        return {
          "status_code": response.statusCode,
          "response": json.decode(response.body)
        };
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

  Future<Map<String, dynamic>> itemData(Map<String, dynamic> requestBody,
      Map<String, String> customHeaders) async {
    String apiUrl =
        '$host/item/fatch-all-mainitem'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
      ...?customHeaders, // Include any custom headers passed as a parameter
    };
    if (DEBUG == true) {
      // print(jwt);
    }
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      req_validation(context, response.statusCode);

      if (response.statusCode == 200) {
        return {
          "status_code": response.statusCode,
          "response": json.decode(response.body),
        };
      } else {
        return {
          "status_code": response.statusCode,
          "response":
              "Failed to load data. Status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      request_failed(context, e.toString());
      return {
        "status_code": -1, // You can set a custom status code for failure
        "response": "Error occurred: $e",
      };
    }
  }

  Future<Map<String, dynamic>> dataDetaiItem(id_item) async {
    String apiUrl =
        '$host/item/get-mainitem/$id_item'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    dbg(id_item);

    dbg(apiUrl);
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      req_validation(context, response.statusCode);

      if (response.statusCode == 200) {
        return {
          "status_code": response.statusCode,
          "response": json.decode(response.body),
        };
      } else {
        return {
          "status_code": response.statusCode,
          "response":
              "Failed to load data. Status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      request_failed(context, e.toString());
      return {
        "status_code": -1, // You can set a custom status code for failure
        "response": "Error occurred: $e",
      };
    }
    // if (response.statusCode == 200) {
    //   setState(() {
    //     item = json.decode(response.body);
    //   });
    //   print(item);
    //   print("Success with item");
    // } else {
    //   print(
    //       'Failed to load data item. Status code: ${response.statusCode} ${response.body}');
    // }
  }
}
