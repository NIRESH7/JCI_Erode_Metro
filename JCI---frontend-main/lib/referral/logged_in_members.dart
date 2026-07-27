import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jci/referral/services/api_config.dart';
import 'package:jci/referral/services/referral_service.dart';
import 'package:jci/referral/widgets/fade_slide_in.dart';
import 'package:jci/referral/widgets/referral_theme.dart';

class LoggedInMembersScreen extends StatefulWidget {
  const LoggedInMembersScreen({super.key});

  @override
  State<LoggedInMembersScreen> createState() => _LoggedInMembersScreenState();
}

class _LoggedInMembersScreenState extends State<LoggedInMembersScreen> {
  List<dynamic> _members = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await ReferralApiService.getActiveMembers();
      setState(() {
        _members = list;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReferralTheme.softBg,
      appBar: AppBar(
        backgroundColor: ReferralTheme.darkBlue,
        title: const Text('Logged In Members',
            style: TextStyle(fontFamily: 'pop-semibold', color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue))
          : _members.isEmpty
              ? Center(
                  child: Text('No active sessions yet',
                      style: TextStyle(fontFamily: 'pop-med', color: Colors.grey.shade600)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _members.length,
                  itemBuilder: (context, i) {
                    final m = _members[i];
                    final pic = ApiConfig.resolveMediaUrl(m['profile_pic']?.toString());
                    return FadeSlideIn(
                      delay: Duration(milliseconds: 60 * i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: ReferralTheme.cardDecoration,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: ReferralTheme.lightBlue.withOpacity(0.15),
                              backgroundImage: pic.isNotEmpty
                                  ? CachedNetworkImageProvider(pic)
                                  : null,
                              child: pic.isEmpty
                                  ? const Icon(Icons.person, color: ReferralTheme.lightBlue)
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m['user_name'] ?? '',
                                      style: const TextStyle(fontFamily: 'pop-semibold', fontSize: 16)),
                                  Text(m['contact'] ?? '',
                                      style: TextStyle(fontFamily: 'pop-reg', color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Online',
                                  style: TextStyle(
                                      fontFamily: 'pop-med',
                                      fontSize: 12,
                                      color: Colors.green.shade700)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
