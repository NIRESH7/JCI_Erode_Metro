import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jci/referral/services/api_config.dart';

class HomeService {
  static Future<List<String>> getPastEventImages() async {
    try {
      final u = ApiConfig.baseUrl;
      final eventImages = Uri.parse("$u/member/getbanners");
      final response = await http.get(eventImages);
      if (response.statusCode != 200) return [];

      final responseData = json.decode(response.body);
      final info = responseData?['response']?['data']?['info'];
      if (info is! List) return [];

      final imageList = <String>[];
      for (final imgs in info) {
        if (imgs is! Map) continue;
        final url = ApiConfig.resolveMediaUrl(imgs['banner_image']?.toString());
        if (url.isNotEmpty) imageList.add(url);
      }
      return imageList;
    } catch (_) {
      return [];
    }
  }
}
