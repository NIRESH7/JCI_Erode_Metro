import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jci/models/blood_request_model.dart';
import 'package:http/http.dart' as http;

class BloodRequestService {
  Future<Map<String, dynamic>> createBloodRequest(
      {required CreateBloodRequestModel data}) async {
    String u = dotenv.get("URL");

    Uri url = Uri.parse("$u/member/createBloodReq");

    try {
      var _response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );

      var _responseData = json.decode(_response.body);
      return _responseData;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getBloodRequests() async {
    String u = dotenv.get("URL");

    Uri url = Uri.parse("$u/member/getAllRequest");

    try {
      var _response = await http.get(url);

      var _responseData = json.decode(_response.body);
      return _responseData;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getSingleBloodRequest({required String id}) async {
    String u = dotenv.get("URL");

    Uri url = Uri.parse("$u/member/getOneRequest/$id");

    try {
      var _response = await http.get(url);

      var _responseData = json.decode(_response.body);
      return _responseData;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
