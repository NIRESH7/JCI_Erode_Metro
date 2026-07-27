import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jci/referral/services/api_config.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/referral/widgets/referral_theme.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/businessModel.dart';
import '../models/familyModel.dart';
import '../models/personalModel.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  final _appTitle = 'Profile';
  Future<List<PersonalModel>> personalDetails = Future.value([]);
  Future<List<FamilyModel>> familyDetails = Future.value([]);

  int? _memberId;

  String profileName = 'N/A';
  String profileRole = 'N/A';
  String? profilePhone;
  String? profilePic;
  bool _isOwnProfile = false;

  late TabController _tabController;

  static const _bg = Color(0xFFF7F9FC);
  static const _muted = Color(0xFF6B7280);
  static const _textBlack = Color(0xFF111827);
  static const _skyBlue = Color(0xFF24B9EC);
  static const _divider = Color(0xFFEEF2F7);

  String u = dotenv.get('URL');

  Future<List<FamilyModel>> _getFamilyList() async {
    final memberId = _memberId;
    if (memberId == null) return [];

    final url = Uri.parse('$u/member/family');
    final famResp = await http.post(
      url,
      headers: const {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'id': memberId}),
    );

    if (famResp.statusCode != 200) return [];

    final decoded = json.decode(famResp.body);
    final info = decoded['response']?['data']?['info'];
    if (info is! List) return [];

    final list = <FamilyModel>[];
    for (final famMem in info) {
      if (famMem is! Map) continue;
      list.add(
        FamilyModel(
          name: '${famMem['name'] ?? ''}',
          dob: '${famMem['dob'] ?? ''}',
          relationship: '${famMem['relationship'] ?? ''}',
          bloodGroup: '${famMem['blood_group'] ?? ''}',
          anniversary: '${famMem['anniversary'] ?? ''}',
        ),
      );
    }
    return list;
  }

  Future<List<BusinessModel>> _getBusinessList() async {
    final memberId = _memberId;
    if (memberId == null) return [];

    final bUrl = Uri.parse('$u/member/member');

    final bresp = await http.post(
      bUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': memberId}),
    );

    var _brespData = json.decode(bresp.body);

    List<BusinessModel> _businessList = [];

    var _mem = _brespData['response']['data']['info'];
    BusinessModel bm = BusinessModel(
        role: (_mem['role']?.toString().trim().isNotEmpty == true)
            ? _mem['role'].toString().trim()
            : 'Not assigned',
        job: _mem['job'] ?? '',
        companyName: _mem['office_name'] ?? 'Company Name Not Found',
        sector: _mem['sector'] ?? 'Business Sector');
    _businessList.add(bm);

    return _businessList;
  }

  Future<List<PersonalModel>> _getPersonalList() async {
    final memberId = _memberId;
    if (memberId == null) return [];

    final bUrl = Uri.parse('$u/member/member');

    final bresp = await http.post(
      bUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': memberId}),
    );

    var _prespData = json.decode(bresp.body);
    List<PersonalModel> _personalList = [];

    var _mem = _prespData['response']['data']['info'];
    profileName = _mem['user_name'] ?? 'N/A';
    profilePic = _mem['profile_pic'];
    profileRole = (_mem['role']?.toString().trim().isNotEmpty == true)
        ? _mem['role'].toString().trim()
        : '';
    profilePhone = '${_mem['contact']}';

    PersonalModel pm = PersonalModel(
        location: '${_mem['location']}',
        email: '${_mem['email']}',
        dob: '${_mem['dob']}',
        blood: '${_mem['blood_group']}',
        phoneno: '${_mem['contact']}');

    _personalList.add(pm);
    if (mounted) setState(() {});
    return _personalList;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _bootstrapProfile();
  }

  Future<void> _bootstrapProfile() async {
    final arg = Get.arguments;
    if (arg is List && arg.isNotEmpty) {
      _memberId = int.tryParse('${arg.first}');
    }
    _memberId ??= await SessionService.getMemberId();
    if (!mounted) return;
    setState(() {
      personalDetails = _getPersonalList();
      familyDetails = _getFamilyList();
    });
    _checkOwnProfile();
  }

  void _refreshProfileData() {
    setState(() {
      personalDetails = _getPersonalList();
      familyDetails = _getFamilyList();
    });
  }

  Future<void> _checkOwnProfile() async {
    final myId = await SessionService.getMemberId();
    if (!mounted) return;
    setState(() {
      _isOwnProfile = myId != null && _memberId != null && myId == _memberId;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _imageUrl(String? pic) => ApiConfig.resolveMediaUrl(pic);

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed == 'N/A') return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: CustAppBar(_appTitle).initAppBar(),
      body: Responsive.body(
        context,
        Column(
          children: [
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: FutureBuilder(
                        future: personalDetails,
                        builder: (context, snapshot) {
                          final loading =
                              snapshot.connectionState == ConnectionState.waiting;
                          return _buildProfileHeader(loading: loading);
                        },
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _PinnedTabBarDelegate(
                        tabBar: _buildTabBar(),
                        backgroundColor: _bg,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _personalTab(),
                    _businessTab(),
                    _familyTab(),
                  ],
                ),
              ),
            ),
            _buildCallBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader({bool loading = false}) {
    final imageUrl = _imageUrl(profilePic);
    final name = loading ? 'Loading...' : caps(profileName);
    final role = loading ? '' : caps(profileRole);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.horizontalPadding(context),
        20,
        Responsive.horizontalPadding(context),
        8,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: imageUrl.isNotEmpty
                ? () => Get.toNamed('/imgView', arguments: [imageUrl])
                : null,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEFF6FC),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: ReferralTheme.darkBlue.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl.isEmpty
                  ? Center(
                      child: Text(
                        _initials(profileName),
                        style: const TextStyle(
                          fontFamily: 'pop-semibold',
                          fontSize: 28,
                          color: _textBlack,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'pop-semibold',
              fontSize: 24,
              color: _textBlack,
              height: 1.2,
            ),
          ),
          if (role.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              role,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'pop-med',
                fontSize: 14,
                color: _muted.withValues(alpha: 0.95),
              ),
            ),
          ],
          if (_isOwnProfile) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () async {
                final updated = await Get.toNamed('/my-profile', arguments: {'edit': true});
                if (updated == true && mounted) {
                  _refreshProfileData();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: ReferralTheme.darkBlue,
                side: const BorderSide(color: ReferralTheme.lightBlue),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text(
                'Update profile',
                style: TextStyle(fontFamily: 'pop-semibold', fontSize: 14),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Responsive.horizontalPadding(context),
        4,
        Responsive.horizontalPadding(context),
        8,
      ),
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEF5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: ReferralTheme.darkBlue.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(3),
        dividerColor: Colors.transparent,
        labelColor: ReferralTheme.darkBlue,
        unselectedLabelColor: _muted,
        labelStyle: const TextStyle(fontFamily: 'pop-semibold', fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontFamily: 'pop-med', fontSize: 13),
        tabs: const [
          Tab(text: 'Personal'),
          Tab(text: 'Business'),
          Tab(text: 'Family'),
        ],
      ),
    );
  }

  Widget _personalTab() {
    return FutureBuilder(
      future: personalDetails,
      builder: (BuildContext ctx, AsyncSnapshot<List<PersonalModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue));
        }
        final data = snapshot.data?.isNotEmpty == true
            ? snapshot.data!.first
            : PersonalModel(location: 'n/a', email: 'n/a', dob: 'n/a', blood: 'n/a', phoneno: 'n/a');
        return _infoList([
          _InfoItem('Location', data.location, Icons.location_on_outlined),
          _InfoItem('Email', data.email, Icons.mail_outline_rounded),
          _InfoItem('Date of birth', data.dob, Icons.cake_outlined),
          _InfoItem('Blood group', data.blood, Icons.water_drop_outlined),
          _InfoItem('Phone', data.phoneno, Icons.phone_outlined),
        ]);
      },
    );
  }

  Widget _businessTab() {
    return FutureBuilder(
      future: _getBusinessList(),
      builder: (BuildContext ctx, AsyncSnapshot<List<BusinessModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue));
        }
        final data = snapshot.data?.isNotEmpty == true
            ? snapshot.data!.first
            : BusinessModel(role: 'n/a', job: 'n/a', companyName: 'n/a', sector: 'n/a');
        return _infoList([
          _InfoItem('Role', data.role, Icons.badge_outlined),
          _InfoItem('Job', data.job, Icons.work_outline_rounded),
          _InfoItem('Sector', data.sector, Icons.category_outlined),
          _InfoItem('Company', data.companyName, Icons.business_outlined),
        ]);
      },
    );
  }

  Widget _familyTab() {
    return FutureBuilder(
      future: familyDetails,
      builder: (BuildContext ctx, AsyncSnapshot<List<FamilyModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return _emptyState('No family members added');
        }
        return ListView.separated(
          padding: Responsive.listPadding(context, bottom: 20),
          itemCount: snapshot.data!.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final member = snapshot.data![index];
            final blood = member.bloodGroup.trim();
            final anniversary = member.anniversary.trim();
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caps(member.name),
                    style: const TextStyle(
                      fontFamily: 'pop-semibold',
                      fontSize: 16,
                      color: _textBlack,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _familyDetailRow('Relationship', caps(member.relationship)),
                  const SizedBox(height: 6),
                  _familyDetailRow('Date of birth', member.dob),
                  if (blood.isNotEmpty && blood != 'null') ...[
                    const SizedBox(height: 6),
                    _familyDetailRow('Blood group', blood),
                  ],
                  if (anniversary.isNotEmpty && anniversary != 'null') ...[
                    const SizedBox(height: 6),
                    _familyDetailRow('Anniversary', anniversary),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoList(List<_InfoItem> items) {
    return ListView(
      padding: Responsive.listPadding(context, bottom: 20),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _infoTile(items[i]),
                if (i < items.length - 1)
                  const Divider(height: 1, thickness: 1, color: _divider, indent: 62),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTile(_InfoItem item) {
    final value = caps(item.value);
    final display =
        value.isEmpty || value == 'Null' || value == 'N/a' ? 'Not available' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _skyBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 18, color: ReferralTheme.darkBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontFamily: 'pop-med',
                    fontSize: 12,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  display,
                  style: const TextStyle(
                    fontFamily: 'pop-semibold',
                    fontSize: 15,
                    color: _textBlack,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _familyDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontFamily: 'pop-med', fontSize: 12, color: _muted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontFamily: 'pop-reg', fontSize: 14, color: _textBlack),
          ),
        ),
      ],
    );
  }

  Widget _emptyState(String message) {
    return ListView(
      children: [
        SizedBox(
          height: 180,
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'pop-med', fontSize: 14, color: _muted),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCallBar() {
    if (profilePhone == null || profilePhone!.isEmpty || profilePhone == 'null') {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        Responsive.horizontalPadding(context),
        12,
        Responsive.horizontalPadding(context),
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ReferralTheme.darkBlue.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => launchUrl(Uri.parse('tel://$profilePhone')),
            style: ElevatedButton.styleFrom(
              backgroundColor: ReferralTheme.lightBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.phone_rounded, size: 20),
            label: const Text(
              'Call now',
              style: TextStyle(fontFamily: 'pop-semibold', fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class _PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  _PinnedTabBarDelegate({
    required this.tabBar,
    required this.backgroundColor,
  });

  final Widget tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

class _InfoItem {
  final String label;
  final String value;
  final IconData icon;

  _InfoItem(this.label, this.value, this.icon);
}
