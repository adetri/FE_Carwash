import 'package:flutter/material.dart';
import 'package:MrCarwash/env.dart';
import 'package:MrCarwash/inc/db.dart';
import 'package:MrCarwash/inc/method.dart';
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

    dbg("this req body  $reqBody");

    try {
      var response;
      if (req_type == "get") {
        response = await http
            .get(
              Uri.parse(apiUrl),
              headers: headers,
            )
            .timeout(Duration(seconds: timeout));
      } else if (req_type == "put") {
        response = await http.put(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(reqBody),
        );
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

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return {
          "status_code": response.statusCode,
          "response": json.decode(response.body),
        };
      } else {
        return {
          "status_code": response.statusCode,
          "response":
              "Failed to load data. Status msg:${response.body}  code: ${response.statusCode}",
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

  Future<Map<String, dynamic>> callPreogresOrder(id_order) async {
    String url = apiUrl + '/order/preogres-order/$id_order';
    dynamic req = await get_req(url);

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> payOrder(order_id, payload) async {
    String url = apiUrl + '/order/pay-order/$order_id';
    dynamic req = await get_req(url, req_type: 'post', reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> cancleOrder(order_id) async {
    String url = apiUrl + '/order/cancle-order/$order_id';
    dynamic req = await get_req(url, req_type: 'put');
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> orderReporting(payload) async {
    String url = apiUrl + '/order/order-report';
    dynamic req = await get_req(url, req_type: 'post', reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> addMoreItem(id_order, payload) async {
    String url = apiUrl + '/order/add-item-order/$id_order';
    dynamic req = await get_req(url, req_type: 'post', reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> addQtyServiceList(payload) async {
    String url = apiUrl + '/order/edit-at-order';
    dynamic req = await get_req(url, req_type: 'put', reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> fetchCategory2() async {
    String url = apiUrl + '/item/fatch-all-category';
    dynamic req = await get_req(url);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> insertCategory(payload) async {
    String url = apiUrl + '/item/create-category';
    dynamic req = await get_req(url, req_type: "post", reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> getCategory(id_category) async {
    id_category = id_category.toString();
    String url = apiUrl + '/item/get-category/$id_category';
    dynamic req = await get_req(url);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> updateCategory(id_category, payload) async {
    id_category = id_category.toString();
    String url = apiUrl + '/item/edit-category/$id_category';
    dynamic req = await get_req(url, req_type: "put", reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> fetchAllItem(payload) async {
    String url = apiUrl + '/item/fatch-all-mainitem';
    dynamic req = await get_req(url, req_type: "post", reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> insertItem(payload) async {
    String url = apiUrl + '/item/create-mainitem';
    dynamic req = await get_req(url, req_type: "post", reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> updateItem(id_item, payload) async {
    String url = apiUrl + ' /item/edit-mainitem/$id_item';
    dynamic req = await get_req(url, req_type: "put", reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> getItem(id_item) async {
    String url = apiUrl + '/item/get-mainitem/$id_item';
    dynamic req = await get_req(url);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> fetchSpot() async {
    String url = apiUrl + '/order/get-spot';
    dynamic req = await get_req(url);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> insertSpot(payload) async {
    String url = apiUrl + '/order/insert-spot';
    dynamic req = await get_req(url, req_type: 'post', reqBody: payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> getSpotById(id_spot) async {
    String url = apiUrl + '/order/get-spot-id/$id_spot';
    dynamic req = await get_req(url);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }

  Future<Map<String, dynamic>> updateSpot(id_spot, Payload) async {
    String url = apiUrl + '/order/update-spot/$id_spot';
    dynamic req = await get_req(url, req_type: 'put', reqBody: Payload);
    return {
      "status_code":
          req['status_code'], // You can set a custom status code for failure
      "response": req['response'],
    };
  }
}
