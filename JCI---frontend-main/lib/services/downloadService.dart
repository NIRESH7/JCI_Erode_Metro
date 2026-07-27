import 'dart:convert';
import 'package:jci/models/pdfDownloadModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class pdfDownloadService {

  static Future<List<pdfDownload>> getPdfList() async {
    String u = dotenv.get("URL");
    Uri url = Uri.parse("$u/member/greenChannel");
    var response = await http.get(url);
    var responseData = json.decode(response.body);

    List<pdfDownload> downloadList = [];

    for (var d in responseData['response']['data']['info']) {
      pdfDownload pdf = pdfDownload(
          id: d['id'],
          url: d['pdf_url'],
          name: d['pdf_name'],
          time: d['createdAt']
      );
      downloadList.add(pdf);
    }
    return downloadList;
  }
}
