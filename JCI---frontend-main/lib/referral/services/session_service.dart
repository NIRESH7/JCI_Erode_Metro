import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jci/referral/services/api_config.dart';

class SessionService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'member_token';
  static const _memberKey = 'member_profile';

  static Future<void> saveSession({
    required String token,
    required Map<String, dynamic> member,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _memberKey, value: json.encode(member));
  }

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<Map<String, dynamic>?> getMember() async {
    final raw = await _storage.read(key: _memberKey);
    if (raw == null) return null;
    return json.decode(raw) as Map<String, dynamic>;
  }

  static Future<int?> getMemberId() async {
    final m = await getMember();
    return m?['id'] is int ? m!['id'] as int : int.tryParse('${m?['id']}');
  }

  /// `full` = can give/respond referrals and post stories; otherwise view-only.
  static Future<String> getAppAccess() async {
    final m = await getMember();
    final access = m?['app_access']?.toString().trim().toLowerCase();
    if (access == 'full') return 'full';
    return 'view';
  }

  /// Pull latest member (incl. app_access) so admin grant/revoke applies without re-login.
  static Future<Map<String, dynamic>?> refreshProfile() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;
    try {
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/member/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'memberauthtoken': token,
        },
      );
      if (res.statusCode < 200 || res.statusCode >= 300) {
        return await getMember();
      }
      final body = json.decode(res.body) as Map<String, dynamic>;
      final info = body['response']?['data']?['info'];
      if (info is! Map) return await getMember();
      final member = Map<String, dynamic>.from(info['member'] as Map);
      await saveSession(
        token: (info['token'] ?? token).toString(),
        member: member,
      );
      return member;
    } catch (_) {
      return await getMember();
    }
  }

  /// Refreshes from server by default so Give/Revoke Access is live.
  static Future<bool> hasFullAccess({bool refresh = true}) async {
    if (refresh) {
      await refreshProfile();
    }
    return (await getAppAccess()) == 'full';
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _memberKey);
  }
}
