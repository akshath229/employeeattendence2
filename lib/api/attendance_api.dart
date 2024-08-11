import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendenceAPI {
  static const String url = 'http://122.176.114.77/UTSHR_Attend/api/values';

  Future<String> sendPostRequest(Map<String, dynamic> requestBody) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print('POST Response: $responseBody'); // Print response body
      return responseBody;
    } else {
      throw Exception('Failed to send request: ${response.reasonPhrase}');
    }
  }

  Future<String> sendGetRequest(Map<String, dynamic> requestBody) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed to send request: ${response.reasonPhrase}');
    }
  }
}
