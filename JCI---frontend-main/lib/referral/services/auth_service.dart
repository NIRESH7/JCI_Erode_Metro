import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jci/referral/services/api_config.dart';
import 'package:jci/referral/services/session_service.dart';

class AuthService {
  static String get _base => ApiConfig.baseUrl;

  static Map<String, String> _headers({String? token}) => {
        'Content-Type': 'application/json',
        if (token != null) 'memberauthtoken': token,
      };

  static dynamic _parse(http.Response res) {
    final raw = res.body.trim();
    if (raw.isEmpty) {
      throw Exception('Empty response from server (${res.statusCode})');
    }
    if (raw.startsWith('<!DOCTYPE') || raw.startsWith('<html')) {
      throw Exception(
        'Server returned HTML instead of JSON (${res.statusCode}). '
        'Restart the backend (npm start in JCI-BackEnd-master) and confirm .env URL is correct.',
      );
    }

    Map<String, dynamic> body;
    try {
      body = json.decode(raw) as Map<String, dynamic>;
    } on FormatException {
      throw Exception(
        'Invalid server response (${res.statusCode}). '
        'Check that the backend is running at $_base.',
      );
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body['response']?['data']?['info'];
    }
    final msg = body['error']?['message'] ??
        body['response']?['message'] ??
        body['Error']?.toString() ??
        'Request failed (${res.statusCode})';
    throw Exception(msg);
  }

  static Future<http.Response> _post(Uri url, {Map<String, String>? headers, Object? body}) async {
    try {
      return await http.post(url, headers: headers, body: body);
    } on SocketException {
      throw Exception(
        'Cannot reach server at $_base. Start the backend (npm start) and fully restart the app (not hot reload).',
      );
    } on http.ClientException {
      throw Exception(
        'Cannot reach server at $_base. If using Android emulator on Windows, set URL in .env to your PC WiFi IP (ipconfig), then restart the app.',
      );
    }
  }

  static Future<http.Response> _multipart(
    Uri url, {
    required Map<String, String> fields,
    File? imageFile,
    String? token,
  }) async {
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields.addAll(fields);
      if (token != null && token.isNotEmpty) {
        request.headers['memberauthtoken'] = token;
      }
      if (imageFile != null) {
        final path = imageFile.path;
        final dot = path.lastIndexOf('.');
        final ext = dot >= 0 ? path.substring(dot).toLowerCase() : '.jpg';
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            path,
            filename: 'profile_${DateTime.now().millisecondsSinceEpoch}$ext',
          ),
        );
      }
      final streamed = await request.send();
      return http.Response.fromStream(streamed);
    } on SocketException {
      throw Exception(
        'Cannot reach server at $_base. Start the backend (npm start) and fully restart the app (not hot reload).',
      );
    } on http.ClientException {
      throw Exception(
        'Cannot reach server at $_base. Check network / .env URL, then restart the app.',
      );
    }
  }

  static Map<String, String> _profileFields({
    required String userName,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String location,
    String? willingToDonate,
    String? companyName,
    String? businessCategory,
    String? designation,
    String? boardMember,
    String? maritalStatus,
    String? jciLocation,
    String? googleId,
    String? googlePhotoUrl,
  }) {
    return {
      'user_name': userName,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'blood_group': bloodGroup,
      'location': location,
      if (willingToDonate != null && willingToDonate.isNotEmpty)
        'willing_to_donate': willingToDonate,
      if (companyName != null && companyName.isNotEmpty) 'office_name': companyName,
      if (businessCategory != null && businessCategory.isNotEmpty)
        'sector': businessCategory,
      if (designation != null && designation.isNotEmpty) 'job': designation,
      if (boardMember != null && boardMember.isNotEmpty) 'board_member': boardMember,
      if (maritalStatus != null && maritalStatus.isNotEmpty)
        'martial_status': maritalStatus,
      if (jciLocation != null && jciLocation.isNotEmpty) 'jci_location': jciLocation,
      if (googleId != null && googleId.isNotEmpty) 'google_id': googleId,
      if (googlePhotoUrl != null && googlePhotoUrl.isNotEmpty)
        'google_photo_url': googlePhotoUrl,
    };
  }

  static Future<Map<String, dynamic>> login({
    required String login,
    required String password,
  }) async {
    final res = await _post(
      Uri.parse('$_base/member/auth/login'),
      headers: _headers(),
      body: json.encode({'login': login, 'password': password}),
    );
    final info = _parse(res) as Map<String, dynamic>;
    await SessionService.saveSession(
      token: info['token'],
      member: Map<String, dynamic>.from(info['member']),
    );
    return info;
  }

  static Future<Map<String, dynamic>> lookupPhone({required String phone}) async {
    final res = await _post(
      Uri.parse('$_base/member/auth/lookup-phone'),
      headers: _headers(),
      body: json.encode({'phone': phone}),
    );
    return _parse(res) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> activateAccount({
    required int memberId,
    required String phone,
    required String password,
  }) async {
    final res = await _multipart(
      Uri.parse('$_base/member/auth/setup'),
      fields: {
        'member_id': memberId.toString(),
        'phone': phone,
        'password': password,
        'batch_activate': 'true',
      },
    );
    final info = _parse(res) as Map<String, dynamic>;
    await SessionService.saveSession(
      token: info['token'],
      member: Map<String, dynamic>.from(info['member']),
    );
    return info;
  }

  static Future<Map<String, dynamic>> setup({
    required String userName,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String location,
    File? profileImage,
    String? googlePhotoUrl,
    String? willingToDonate,
    String? companyName,
    String? businessCategory,
    String? designation,
    String? boardMember,
    String? maritalStatus,
    String? jciLocation,
  }) async {
    final res = await _multipart(
      Uri.parse('$_base/member/auth/setup'),
      fields: _profileFields(
        userName: userName,
        email: email,
        password: password,
        phone: phone,
        gender: gender,
        dob: dob,
        bloodGroup: bloodGroup,
        location: location,
        willingToDonate: willingToDonate,
        companyName: companyName,
        businessCategory: businessCategory,
        designation: designation,
        boardMember: boardMember,
        maritalStatus: maritalStatus,
        jciLocation: jciLocation,
        googlePhotoUrl: googlePhotoUrl,
      ),
      imageFile: profileImage,
    );
    final info = _parse(res) as Map<String, dynamic>;
    await SessionService.saveSession(
      token: info['token'],
      member: Map<String, dynamic>.from(info['member']),
    );
    return info;
  }

  static Future<Map<String, dynamic>> googleSignIn({
    String? idToken,
    String? accessToken,
    String? email,
    String? googleId,
  }) async {
    final res = await _post(
      Uri.parse('$_base/member/auth/google'),
      headers: _headers(),
      body: json.encode({
        if (idToken != null) 'id_token': idToken,
        if (accessToken != null) 'access_token': accessToken,
        if (email != null) 'email': email,
        if (googleId != null) 'google_id': googleId,
      }),
    );
    final info = _parse(res) as Map<String, dynamic>;
    if (info['token'] != null && info['member'] != null) {
      await SessionService.saveSession(
        token: info['token'],
        member: Map<String, dynamic>.from(info['member']),
      );
    }
    return info;
  }

  static Future<Map<String, dynamic>> linkGoogle({
    required String userName,
    required String email,
    required String googleId,
    required String password,
    required String phone,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String location,
    File? profileImage,
    String? googlePhotoUrl,
    String? willingToDonate,
    String? companyName,
    String? businessCategory,
    String? designation,
    String? boardMember,
    String? maritalStatus,
    String? jciLocation,
  }) async {
    final res = await _multipart(
      Uri.parse('$_base/member/auth/link-google'),
      fields: _profileFields(
        userName: userName,
        email: email,
        password: password,
        phone: phone,
        gender: gender,
        dob: dob,
        bloodGroup: bloodGroup,
        location: location,
        willingToDonate: willingToDonate,
        companyName: companyName,
        businessCategory: businessCategory,
        designation: designation,
        boardMember: boardMember,
        maritalStatus: maritalStatus,
        jciLocation: jciLocation,
        googleId: googleId,
        googlePhotoUrl: googlePhotoUrl,
      ),
      imageFile: profileImage,
    );
    final info = _parse(res) as Map<String, dynamic>;
    await SessionService.saveSession(
      token: info['token'],
      member: Map<String, dynamic>.from(info['member']),
    );
    return info;
  }

  static Map<String, String> _updateProfileFields({
    required String userName,
    required String phone,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String location,
    String? membershipId,
    String? willingToDonate,
    String? companyName,
    String? businessCategory,
    String? designation,
    String? boardMember,
    String? maritalStatus,
    String? jciLocation,
  }) {
    return {
      'user_name': userName,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'blood_group': bloodGroup,
      'location': location,
      if (membershipId != null) 'membership_id': membershipId,
      if (willingToDonate != null && willingToDonate.isNotEmpty)
        'willing_to_donate': willingToDonate,
      if (companyName != null && companyName.isNotEmpty) 'office_name': companyName,
      if (businessCategory != null && businessCategory.isNotEmpty)
        'sector': businessCategory,
      if (designation != null && designation.isNotEmpty) 'job': designation,
      if (boardMember != null && boardMember.isNotEmpty) 'board_member': boardMember,
      if (maritalStatus != null && maritalStatus.isNotEmpty)
        'martial_status': maritalStatus,
      if (jciLocation != null && jciLocation.isNotEmpty) 'jci_location': jciLocation,
    };
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String userName,
    required String phone,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String location,
    String? membershipId,
    String? willingToDonate,
    String? companyName,
    String? businessCategory,
    String? designation,
    String? boardMember,
    String? maritalStatus,
    String? jciLocation,
    File? profileImage,
  }) async {
    final token = await SessionService.getToken();
    if (token == null) throw Exception('Not logged in');
    final res = await _multipart(
      Uri.parse('$_base/member/auth/profile'),
      fields: _updateProfileFields(
        userName: userName,
        phone: phone,
        gender: gender,
        dob: dob,
        bloodGroup: bloodGroup,
        location: location,
        membershipId: membershipId,
        willingToDonate: willingToDonate,
        companyName: companyName,
        businessCategory: businessCategory,
        designation: designation,
        boardMember: boardMember,
        maritalStatus: maritalStatus,
        jciLocation: jciLocation,
      ),
      imageFile: profileImage,
      token: token,
    );
    final info = _parse(res) as Map<String, dynamic>;
    await SessionService.saveSession(
      token: (info['token'] ?? token).toString(),
      member: Map<String, dynamic>.from(info['member']),
    );
    return info;
  }

  static Future<String> forgotPassword(String email) async {
    final res = await _post(
      Uri.parse('$_base/member/auth/forgot-password'),
      headers: _headers(),
      body: json.encode({'email': email}),
    );
    final info = _parse(res) as Map<String, dynamic>;
    return info['message'] ?? 'Check your email';
  }

  static Future<Map<String, dynamic>> verifyIdentity({
    required String phone,
    required String userName,
    required String dob,
  }) async {
    final res = await _post(
      Uri.parse('$_base/member/auth/verify-identity'),
      headers: _headers(),
      body: json.encode({
        'phone': phone,
        'user_name': userName,
        'dob': dob,
      }),
    );
    return _parse(res) as Map<String, dynamic>;
  }

  static Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    final res = await _post(
      Uri.parse('$_base/member/auth/reset-password'),
      headers: _headers(),
      body: json.encode({
        'email': email.trim().toLowerCase(),
        'reset_token': resetToken,
        'new_password': newPassword,
      }),
    );
    final info = _parse(res) as Map<String, dynamic>;
    await SessionService.saveSession(
      token: info['token'],
      member: Map<String, dynamic>.from(info['member']),
    );
  }

  /// Pull latest member profile (incl. app_access) so admin grant/revoke applies without re-login.
  static Future<Map<String, dynamic>?> refreshSession() =>
      SessionService.refreshProfile();

  static Future<void> registerFcmToken(String fcmToken) async {
    final token = await SessionService.getToken();
    if (token == null) return;
    await http.post(
      Uri.parse('$_base/member/session/register-token'),
      headers: _headers(token: token),
      body: json.encode({'fcm_token': fcmToken}),
    );
  }
}
