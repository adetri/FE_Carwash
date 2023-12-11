import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> makePutRequest() async {
  const apiUrl = 'YOUR_API_URL'; // Replace with your API URL
  const timeout = 5; // Timeout duration in seconds

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    // Add any other necessary headers
  };

  Map<String, dynamic> reqBody = {
    // Your request body data
  };

  try {
    http.Response response = await http
        .put(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(reqBody),
        )
        .timeout(Duration(seconds: timeout));

    // Check the status code for the response
    if (response.statusCode == 200) {
      // Handle successful response
      print('Request successful');
    } else {
      // Handle other status codes
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    if (e is TimeoutException) {
      // Handle timeout exception
      print('Request timed out');
    } else {
      // Handle other exceptions
      print('Error: $e');
    }
  }
}

void main() {
  makePutRequest();
}
