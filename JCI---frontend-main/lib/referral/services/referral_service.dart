import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jci/referral/models/referral_model.dart';
import 'package:jci/referral/services/session_service.dart';

class ReferralApiService {
  static String get _base => dotenv.get('URL');

  static Future<Map<String, String>> _headers() async {
    final token = await SessionService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'memberauthtoken': token,
    };
  }

  static List<ReferralModel> _list(dynamic info) {
    if (info == null) return [];
    if (info is List) {
      return info.map((e) => ReferralModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<ReferralModel> create({
    required int linkedMemberId,
    required String referralType,
    required String referredName,
    required String referredPhone,
    String? remark,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/member/referral/create'),
      headers: await _headers(),
      body: json.encode({
        'linked_member_id': linkedMemberId,
        'referral_type': referralType,
        'referred_name': referredName,
        'referred_phone': referredPhone,
        if (remark != null && remark.isNotEmpty) 'remark': remark,
      }),
    );
    final body = json.decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ReferralModel.fromJson(body['response']['data']['info']);
    }
    throw Exception(body['response']?['message'] ?? 'Failed to create referral');
  }

  static Future<List<ReferralModel>> getGiven(int memberId) async {
    final res = await http.get(
      Uri.parse('$_base/member/referral/given/$memberId'),
      headers: await _headers(),
    );
    final body = json.decode(res.body);
    return _list(body['response']?['data']?['info']);
  }

  static Future<List<ReferralModel>> getReceived() async {
    final res = await http.get(
      Uri.parse('$_base/member/referral/received'),
      headers: await _headers(),
    );
    final body = json.decode(res.body);
    return _list(body['response']?['data']?['info']);
  }

  static Future<ReferralModel> getOne(int id) async {
    final res = await http.get(
      Uri.parse('$_base/member/referral/$id'),
      headers: await _headers(),
    );
    final body = json.decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ReferralModel.fromJson(body['response']['data']['info']);
    }
    throw Exception('Referral not found');
  }

  static Future<ReferralModel> respond({
    required int referralId,
    required String action,
    String? connectionType,
    double? connectAmount,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/member/referral/respond'),
      headers: await _headers(),
      body: json.encode({
        'referral_id': referralId,
        'action': action,
        if (connectionType != null) 'connection_type': connectionType,
        if (connectAmount != null) 'connect_amount': connectAmount,
      }),
    );
    final body = json.decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ReferralModel.fromJson(body['response']['data']['info']);
    }
    throw Exception(body['response']?['message'] ?? 'Failed to respond');
  }

  static Future<List<dynamic>> getActiveMembers() async {
    final res = await http.get(
      Uri.parse('$_base/member/session/active-members'),
      headers: await _headers(),
    );
    final body = json.decode(res.body);
    return body['response']?['data']?['info'] ?? [];
  }

  static Future<double> getTotalConnectAmount() async {
    final res = await http.get(
      Uri.parse('$_base/member/referral/total-connect-amount'),
      headers: await _headers(),
    );
    final body = json.decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final total = body['response']?['data']?['info']?['total'];
      return double.tryParse('$total') ?? 0;
    }
    return 0;
  }
}
