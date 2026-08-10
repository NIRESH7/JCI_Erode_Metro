import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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

  static String _uploadFileName(String? name) {
    final source = (name ?? '').trim();
    final dot = source.lastIndexOf('.');
    final ext = dot >= 0 ? source.substring(dot).toLowerCase() : '.jpg';
    final safeExt = (ext == '.png' || ext == '.jpeg' || ext == '.jpg' || ext == '.webp')
        ? ext
        : '.jpg';
    return 'story_${DateTime.now().millisecondsSinceEpoch}$safeExt';
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

  /// Works on web and mobile — uses bytes instead of dart:io File paths.
  static Future<void> uploadStoryBytes(
    Uint8List bytes, {
    String? fileName,
  }) async {
    if (bytes.isEmpty) {
      throw Exception('Selected image is empty');
    }
    final token = await SessionService.getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_base/member/fitness/story'),
    );
    if (token != null) request.headers['memberauthtoken'] = token;
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: _uploadFileName(fileName),
      ),
    );
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_errorMessage(res));
    }
  }

  static Future<int> uploadStoriesFromXFiles(List<XFile> images) async {
    var uploaded = 0;
    for (final image in images) {
      final bytes = await image.readAsBytes();
      await uploadStoryBytes(bytes, fileName: image.name);
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
