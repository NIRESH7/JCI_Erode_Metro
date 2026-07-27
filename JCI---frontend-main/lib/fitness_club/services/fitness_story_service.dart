import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jci/fitness_club/models/fitness_story_model.dart';
import 'package:jci/referral/services/api_config.dart';
import 'package:jci/referral/services/session_service.dart';

class FitnessStoryService {
  static String get _base => ApiConfig.baseUrl;

  static Future<Map<String, String>> _headers() async {
    final token = await SessionService.getToken();
    return {
      if (token != null) 'memberauthtoken': token,
    };
  }

  static String _uploadFileName(String filePath) {
    final dot = filePath.lastIndexOf('.');
    final ext = dot >= 0 ? filePath.substring(dot).toLowerCase() : '.jpg';
    return 'story_${DateTime.now().millisecondsSinceEpoch}$ext';
  }

  static String _errorMessage(http.Response res) {
    final raw = res.body.trim();
    if (raw.isEmpty) return 'Failed to upload story (${res.statusCode})';
    try {
      final body = json.decode(raw);
      if (body is Map) {
        return body['error']?['message'] ??
            body['response']?['message'] ??
            body['Error']?.toString() ??
            body['error']?.toString() ??
            'Failed to upload story (${res.statusCode})';
      }
    } catch (_) {}
    return 'Failed to upload story (${res.statusCode})';
  }

  static Future<List<MemberStoryGroup>> getStories() async {
    final res = await http.get(
      Uri.parse('$_base/member/fitness/stories'),
      headers: await _headers(),
    );
    final body = json.decode(res.body);
    final info = body['response']?['data']?['info'];
    if (info is List) {
      return info.map((e) => MemberStoryGroup.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> uploadStory(File imageFile) async {
    final token = await SessionService.getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_base/member/fitness/story'),
    );
    if (token != null) request.headers['memberauthtoken'] = token;
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: _uploadFileName(imageFile.path),
      ),
    );
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_errorMessage(res));
    }
  }

  static Future<int> uploadStories(List<File> imageFiles) async {
    var uploaded = 0;
    for (final file in imageFiles) {
      await uploadStory(file);
      uploaded++;
    }
    return uploaded;
  }

  static Future<void> deleteStory(int id) async {
    final res = await http.delete(
      Uri.parse('$_base/member/fitness/story/$id'),
      headers: await _headers(),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to delete story');
    }
  }
}
