import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/referral/models/referral_model.dart';
import 'package:jci/referral/referral_detail.dart';
import 'package:jci/referral/referral_wizard.dart';
import 'package:jci/referral/services/referral_service.dart';
import 'package:jci/utils/app_navigation.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/referral/widgets/fade_slide_in.dart';
import 'package:jci/referral/widgets/referral_theme.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  List<ReferralModel> _given = [];
  List<ReferralModel> _received = [];
  bool _loading = true;
  bool _hasFullAccess = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final memberId = await SessionService.getMemberId();
      final fullAccess = await SessionService.hasFullAccess();
      if (memberId == null) return;
      final given = await ReferralApiService.getGiven(memberId);
      final received = await ReferralApiService.getReceived();
      setState(() {
        _given = given;
        _received = received;
        _hasFullAccess = fullAccess;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _snackViewOnly() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View only — ask admin for access')),
    );
  }

  Future<void> _openGiveReferral() async {
    final allowed = await SessionService.hasFullAccess();
    if (!mounted) return;
    setState(() => _hasFullAccess = allowed);
    if (!allowed) {
      _snackViewOnly();
      return;
    }
    await AppNavigation.to(const ReferralWizardScreen());
    _load();
  }

  Color _statusColor(ReferralModel r) {
    if (r.status == 'accepted' && r.connectionType == 'completed') {
      return Colors.green;
    }
    if (r.status == 'accepted' && r.connectionType == 'non_closed_connect') {
      return Colors.orange;
    }
    if (r.status == 'rejected') {
      return Colors.orange;
    }
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReferralTheme.softBg,
      appBar: AppBar(
        backgroundColor: ReferralTheme.darkBlue,
        title: const Text('Referrals',
            style: TextStyle(fontFamily: 'pop-semibold', color: Colors.white)),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: ReferralTheme.lightBlue,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Given'),
            Tab(text: 'Received'),
          ],
        ),
      ),
      floatingActionButton: ScaleTap(
        onTap: _openGiveReferral,
        child: FloatingActionButton(
          backgroundColor: _hasFullAccess
              ? ReferralTheme.lightBlue
              : Colors.grey.shade400,
          onPressed: _openGiveReferral,
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue))
          : Responsive.body(
              context,
              TabBarView(
                controller: _tab,
                children: [
                  _list(_given, empty: 'No referrals given yet', isGiven: true),
                  _list(_received, empty: 'No referrals received yet', isGiven: false),
                ],
              ),
            ),
    );
  }

  Widget _list(List<ReferralModel> items, {required String empty, required bool isGiven}) {
    if (items.isEmpty) {
      return Center(
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(empty, style: TextStyle(fontFamily: 'pop-med', color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      color: ReferralTheme.lightBlue,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final r = items[i];
          return FadeSlideIn(
            delay: Duration(milliseconds: 50 * i),
            child: ScaleTap(
              onTap: () async {
                await AppNavigation.to(ReferralDetailScreen(referralId: r.id));
                _load();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: ReferralTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(r.referredName,
                              style: const TextStyle(fontFamily: 'pop-semibold', fontSize: 17)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(r).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(r.statusLabel,
                              style: TextStyle(
                                  fontFamily: 'pop-med',
                                  fontSize: 12,
                                  color: _statusColor(r))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(r.referredPhone,
                        style: TextStyle(fontFamily: 'pop-reg', color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _chip(r.typeLabel, ReferralTheme.lightBlue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isGiven
                                ? 'To ${r.linkedMemberName ?? 'member'}'
                                : 'From ${r.referrerName ?? 'member'}',
                            style: TextStyle(
                              fontFamily: 'pop-reg',
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontFamily: 'pop-med', fontSize: 11, color: color)),
    );
  }
}
