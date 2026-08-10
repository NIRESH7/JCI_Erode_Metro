import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jci/referral/services/api_config.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/services/notification_model.dart';

class NotificationApiService {
  static Future<Map<String, String>> _headers() async {
    final token = await SessionService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'memberauthtoken': token,
    };
  }

  static Future<int> unreadCount() async {
    final loggedIn = await SessionService.isLoggedIn();
    if (!loggedIn) return 0;
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/member/notifications/unread-count'),
      headers: await _headers(),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) return 0;
    final body = json.decode(res.body);
    final count = body['response']?['data']?['info']?['count'];
    if (count is int) return count;
    return int.tryParse('$count') ?? 0;
  }

  static Future<List<AppNotification>> list() async {
    final loggedIn = await SessionService.isLoggedIn();
    if (!loggedIn) return [];
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/member/notifications'),
      headers: await _headers(),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) return [];
    final body = json.decode(res.body);
    final info = body['response']?['data']?['info'];
    if (info is! List) return [];
    return info
        .whereType<Map>()
        .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<int> markRead({List<int>? ids}) async {
    final loggedIn = await SessionService.isLoggedIn();
    if (!loggedIn) return 0;
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/member/notifications/mark-read'),
      headers: await _headers(),
      body: json.encode({
        if (ids != null && ids.isNotEmpty) 'ids': ids,
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) return 0;
    final body = json.decode(res.body);
    final count = body['response']?['data']?['info']?['count'];
    if (count is int) return count;
    return int.tryParse('$count') ?? 0;
  }
}
