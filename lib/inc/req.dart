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
  int? status_cido;
  Map<String, String>? headers;
  String apiUrl = "";
  Req(this.context) {}

  Future<void> init() async {
    dynamic data = await dbHelper.getJwtHost();
    host = data['host'];
    jwt = data['jwt'];
    apiUrl = host!;
    headers = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    dbg("init req execute");
  }

  Future<Map<String, dynamic>> get_req(apiUrl,
      {dynamic? reqBody, String req_type = "get"}) async {
    dbg("apiurl is : $apiUrl");
    // dbg("headers is : $headers");

    if (req_type == "post" && reqBody == null) {
      show_dialog(context, "POST req", "type req post. reqbody cant be null");
      return {
        "status_code": -1, // You can set a custom status code for failure
        "response": "Error occurred: type req post. reqbody cant be null",
      };
    }

    try {
      var response;
      if (req_type == "get") {
        response = await http
            .get(
              Uri.parse(apiUrl),
              headers: headers,
            )
            .timeout(Duration(seconds: timeout));
      } else {
        response = await http
            .post(
              Uri.parse(apiUrl),
              headers: headers,
              body: jsonEncode(reqBody),
            )
            .timeout(Duration(seconds: timeout));
      }

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

  Future<String> getHost() async {
    if (host != null) {
      return host!;
    }
    host = await dbHelper.getHost() ?? 'cantgethost';
    dbg("host init");
    return host!;
  }

  Future<String> getJWT() async {
    if (jwt != null) {
      return jwt!;
    }
    jwt = await dbHelper.getJWT() ?? 'cantgetjwt';
    dbg("jwt init");

    return jwt!;
  }

  Future<Map<String, dynamic>> login(dynamic paylod) async {
    String apiUrl = '$host/ath/login'; // Replace with your API endpoint
    dbg("this host $apiUrl");

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: headers,
            body: jsonEncode(paylod),
          )
          .timeout(Duration(seconds: timeout));
      return {"status_code": response.statusCode, "response": response.body};
    } catch (e) {
      request_failed(context, e.toString());
      return {"status_code": -1, "response": "Request Error ${e.toString()}"};
    }
  }

  dynamic fetchMonitoring() async {
    String apiUrl = '$host/order/get-spot'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
      // Replace with your authentication token
    };
    dbg("this host $apiUrl");
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
      // dbg(jwt);
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
    String url = apiUrl + '/item/get-mainitem/$id_item';
    dynamic req = await get_req(url);

    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> call_wash() async {
    String url = apiUrl + '/pegawai/get-washer-pegawai';
    dynamic req = await get_req(url);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> addOrder(paylod, spot_id) async {
    String url = apiUrl + '/order/create-order/$spot_id';
    dynamic req = await get_req(url, req_type: 'post', reqBody: paylod);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }
}
