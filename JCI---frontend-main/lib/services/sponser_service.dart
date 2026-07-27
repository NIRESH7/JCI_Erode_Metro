import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jci/home/SponsorModel.dart';

class SponsorService {
  static String _u = dotenv.get("URL");

  static Future<List<SponsorModel>> getSponserData() async {
    Uri url = Uri.parse("$_u/member/main_sponser");
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': '',
        }));
    var responseData = json.decode(response.body);

    List<SponsorModel> sponserList = [];

    for (var sponsers in responseData['response']['data']['info']) {
      SponsorModel sponser = SponsorModel(
          id: "${sponsers['id']}",
          companyName: sponsers['sponser_name'],
          logo: sponsers['sponser_image']);
      sponserList.add(sponser);
    }
    return sponserList;
  }

  static Future<List<SponsorModel>> getOurSponserData() async {
    Uri url = Uri.parse("$_u/member/our_sponser");
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': '',
        }));
    var responseData = json.decode(response.body);

    List<SponsorModel> sponserList = [];

    for (var sponsers in responseData['response']['data']['info']) {
      SponsorModel sponser = SponsorModel(
          id: "${sponsers['id']}",
          companyName: sponsers['sponser_name'],
          logo: sponsers['sponser_image']);
      sponserList.add(sponser);
    }
    return sponserList;
  }
}
