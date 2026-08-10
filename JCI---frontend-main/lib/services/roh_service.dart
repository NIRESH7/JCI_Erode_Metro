import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jci/models/rohModel.dart';
import 'package:jci/referral/services/api_config.dart';

class RohService {
  static String _str(dynamic v) {
    if (v == null) return '';
    final s = '$v'.trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return '';
    return s;
  }

  static Future<List<RohModel>> getROHData(year) async {
    final u = dotenv.get('URL');
    final url = Uri.parse('$u/member/roh');
    final resp = await http.post(
      url,
      headers: const {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'year': '$year'}),
    );
    final responseData = json.decode(resp.body);
    final info = responseData['response']?['data']?['info'];
    if (info is! List) return [];

    final memberList = <RohModel>[];
    for (final entry in info) {
      if (entry is! Map) continue;
      final member = entry['Member'];
      final m = member is Map ? Map<String, dynamic>.from(member) : <String, dynamic>{};

      memberList.add(
        RohModel(
          id: entry['id'] is int ? entry['id'] as int : int.tryParse('${entry['id']}'),
          memberId: m['id'] is int ? m['id'] as int : int.tryParse('${m['id']}'),
          img: ApiConfig.resolveMediaUrl(m['profile_pic']?.toString()),
          name: _str(m['user_name']),
          designationName: _str(entry['designation_name']).isNotEmpty
              ? _str(entry['designation_name'])
              : _str(m['role']),
          designationYear: _str(entry['designation_year']),
          email: _str(m['email']),
          contact: _str(m['contact']),
          gender: _str(m['gender']),
          dob: _str(m['dob']),
          location: _str(m['location']),
          bloodGroup: _str(m['blood_group']),
          willingToDonate: _str(m['willing_to_donate']),
          officeName: _str(m['office_name']),
          job: _str(m['job']),
          sector: _str(m['sector']),
          martialStatus: _str(m['martial_status']),
          role: _str(m['role']),
          jciLocation: _str(m['jci_location']),
          membershipId: _str(m['membership_id']),
          type: _str(m['type']),
          status: _str(m['status']),
        ),
      );
    }

    return memberList;
  }
}
