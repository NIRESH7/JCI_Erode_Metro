import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:jci/models/membersModel.dart';
import 'package:jci/referral/services/api_config.dart';
import 'package:jci/referral/services/referral_service.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/referral/widgets/fade_slide_in.dart';
import 'package:jci/referral/widgets/referral_theme.dart';
import 'package:permission_handler/permission_handler.dart';

class ReferralWizardScreen extends StatefulWidget {
  const ReferralWizardScreen({super.key});

  @override
  State<ReferralWizardScreen> createState() => _ReferralWizardScreenState();
}

class _ReferralWizardScreenState extends State<ReferralWizardScreen> {
  final _pageCtrl = PageController();
  int _step = 0;
  MembersModel? _linkedMember;
  String _type = 'jci_member';
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  List<MembersModel> _members = [];
  bool _loading = false;
  bool _loadingMembers = true;
  String? _membersError;
  int _emptyFieldSnackCount = 0;
  static const int _maxEmptyFieldSnacks = 3;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_resetEmptyFieldSnackCount);
    _phoneCtrl.addListener(_resetEmptyFieldSnackCount);
    _loadMembers();
  }

  void _resetEmptyFieldSnackCount() {
    if (_emptyFieldSnackCount > 0) {
      _emptyFieldSnackCount = 0;
    }
  }

  Future<void> _loadMembers() async {
    setState(() {
      _loadingMembers = true;
      _membersError = null;
    });
    try {
      final myId = await SessionService.getMemberId();
      final url = Uri.parse('${ApiConfig.baseUrl}/member/allmembers?app_access=full');
      final res = await http.get(url);
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception('Could not load members (${res.statusCode})');
      }
      final data = json.decode(res.body);
      final list = data['response']?['data']?['info'];
      if (list is List && list != 'Not Found') {
        final all = list.map((e) => MembersModel.fromJson(e)).toList();
        final myIdStr = myId?.toString();
        setState(() {
          _members = myIdStr == null
              ? all
              : all.where((m) => m.id?.toString() != myIdStr).toList();
          _loadingMembers = false;
        });
      } else {
        setState(() {
          _members = [];
          _loadingMembers = false;
          _membersError = 'No members found';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _members = [];
        _loadingMembers = false;
        _membersError = '$e';
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _remarkCtrl.dispose();
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  String _memberImageUrl(String? pic) {
    if (pic == null || pic.isEmpty) return '';
    final lower = pic.toLowerCase();
    if (lower.contains('placeholder') ||
        lower.contains('default') ||
        lower.contains('user.png') ||
        lower.contains('profile.png') ||
        lower.contains('avatar')) {
      return '';
    }
    return ApiConfig.resolveMediaUrl(pic);
  }

  String _memberInitials(MembersModel m) {
    final name = (m.userName ?? '').trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  List<MembersModel> _filterMembers(String filter) {
    if (filter.isEmpty) return _members;
    final f = filter.toLowerCase();
    return _members.where((m) {
      final name = (m.userName ?? '').toLowerCase();
      final phone = (m.contact ?? '').toLowerCase();
      return name.contains(f) || phone.contains(f);
    }).toList();
  }

  Future<void> _importContact() async {
    final status = await Permission.contacts.request();
    if (!status.isGranted) return;
    final contact = await FlutterContacts.openExternalPick();
    if (contact == null) return;
    final full = await FlutterContacts.getContact(contact.id);
    if (full == null) return;
    setState(() {
      _nameCtrl.text = full.displayName;
      if (full.phones.isNotEmpty) {
        final normalized = _normalizePhone10(full.phones.first.number);
        _phoneCtrl.text = normalized ?? full.phones.first.number;
      }
    });
  }

  void _next() {
    if (_step == 0 && _linkedMember == null) {
      _snack('Select a member');
      return;
    }
    if (_step == 2) {
      _submit();
      return;
    }
    if (_step == 1) {
      _prepareStep3();
    }
    setState(() => _step++);
    _pageCtrl.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    Navigator.pop(context);
  }

  Future<void> _prepareStep3() async {
    if (_type != 'self') return;
    final member = await SessionService.getMember();
    if (member == null || !mounted) return;
    setState(() {
      _nameCtrl.text = member['user_name']?.toString() ?? '';
      final phone = member['contact']?.toString() ?? '';
      _phoneCtrl.text = _normalizePhone10(phone) ?? phone;
    });
  }

  String? _normalizePhone10(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return digits;
    if (digits.length == 12 && digits.startsWith('91')) return digits.substring(2);
    if (digits.length == 11 && digits.startsWith('0')) return digits.substring(1);
    return null;
  }

  String _contactHelper() {
    final to = _linkedMember?.userName ?? 'member';
    switch (_type) {
      case 'self':
        return 'Fill YOUR name and phone. You are introducing yourself to $to.';
      case 'jci_member':
        return 'Fill the other JCI member\'s name and phone — the person you want to introduce to $to.';
      case 'non_jci_member':
        return 'Fill the outside person\'s name and phone — someone you want to introduce to $to.';
      default:
        return 'Fill the contact person\'s name and phone.';
    }
  }

  String get _nameLabel {
    switch (_type) {
      case 'self':
        return 'Your name';
      case 'jci_member':
        return 'JCI member name';
      case 'non_jci_member':
        return 'Person\'s name';
      default:
        return 'Name';
    }
  }

  String get _phoneLabel {
    switch (_type) {
      case 'self':
        return 'Your phone number';
      case 'jci_member':
        return 'Their phone number';
      case 'non_jci_member':
        return 'Their phone number';
      default:
        return 'Phone number';
    }
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final phoneRaw = _phoneCtrl.text.trim();
    if (name.isEmpty || phoneRaw.isEmpty) {
      if (_emptyFieldSnackCount < _maxEmptyFieldSnacks) {
        _emptyFieldSnackCount++;
        _snack('Name and phone required');
      }
      return;
    }
    final phone = _normalizePhone10(phoneRaw);
    if (phone == null) {
      _snack('Enter a valid 10-digit phone number');
      return;
    }
    setState(() => _loading = true);
    try {
      await ReferralApiService.create(
        linkedMemberId: _linkedMember!.id!,
        referralType: _type,
        referredName: name,
        referredPhone: phone,
        remark: _remarkCtrl.text.trim().isEmpty ? null : _remarkCtrl.text.trim(),
      );
      if (mounted) {
        _snack('Referral sent! Notification delivered if they have the app.');
        Navigator.pop(context);
      }
    } catch (e) {
      _snack('$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String m) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step > 0) _back();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFBFC),
        appBar: AppBar(
          backgroundColor: ReferralTheme.darkBlue,
          elevation: 0,
          leading: IconButton(
            onPressed: _back,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
          ),
          title: const Text('Give Referral',
              style: TextStyle(fontFamily: 'pop-semibold', color: Colors.white, fontSize: 17)),
        ),
        body: Column(
          children: [
            _buildStepHeader(),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _step1(),
                  _step2(),
                  _step3(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader() {
    const labels = ['Select', 'Type', 'Details'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final active = i == _step;
          final done = i < _step;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: done || active
                        ? ReferralTheme.lightBlue
                        : const Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: done
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontFamily: 'pop-semibold',
                            fontSize: 12,
                            color: active ? Colors.white : const Color(0xFF9CA3AF),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: active ? 'pop-semibold' : 'pop-reg',
                      fontSize: 12,
                      color: active || done ? ReferralTheme.darkBlue : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
                if (i < 2)
                  Container(
                    width: 12,
                    height: 1,
                    margin: const EdgeInsets.only(right: 8),
                    color: done ? ReferralTheme.lightBlue : const Color(0xFFE5E7EB),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _loading ? null : _next,
            style: ElevatedButton.styleFrom(
              backgroundColor: ReferralTheme.lightBlue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: ReferralTheme.lightBlue.withOpacity(0.4),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    _step == 2 ? 'Submit referral' : 'Continue',
                    style: const TextStyle(fontFamily: 'pop-semibold', fontSize: 15),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: ReferralTheme.darkBlue.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontFamily: 'pop-reg', fontSize: 15, color: ReferralTheme.darkBlue),
        decoration: InputDecoration(
          hintText: 'Search by name or phone',
          hintStyle: TextStyle(fontFamily: 'pop-reg', color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search_rounded, color: ReferralTheme.lightBlue, size: 22),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() {});
                  },
                  icon: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade500),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  String _displayName(String? name) {
    if (name == null || name.isEmpty) return '';
    return name.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }

  Widget _step1() {
    final visible = _filterMembers(_searchCtrl.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who gets this connection?',
                style: TextStyle(
                  fontFamily: 'pop-semibold',
                  fontSize: 18,
                  color: ReferralTheme.darkBlue,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap a member to select them',
                style: TextStyle(fontFamily: 'pop-reg', fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              _searchBar(),
              if (!_loadingMembers && _members.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '${visible.length} of ${_members.length} members',
                  style: TextStyle(
                    fontFamily: 'pop-med',
                    fontSize: 12,
                    color: ReferralTheme.lightBlue.withOpacity(0.9),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_linkedMember != null) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ReferralTheme.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ReferralTheme.lightBlue.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  _memberAvatar(_linkedMember!, selected: true, compact: true),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected',
                          style: TextStyle(
                            fontFamily: 'pop-reg',
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          _displayName(_linkedMember!.userName),
                          style: const TextStyle(
                            fontFamily: 'pop-semibold',
                            fontSize: 14,
                            color: ReferralTheme.darkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _linkedMember = null),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: ReferralTheme.darkBlue,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Expanded(
          child: _loadingMembers
              ? const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue))
              : _membersError != null
                  ? _step1Error()
                  : _members.isEmpty
                      ? _step1Empty('No other members available to refer.')
                      : visible.isEmpty
                          ? _step1Empty('No members match your search.')
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1.45,
                              ),
                              itemCount: visible.length,
                              itemBuilder: (context, index) {
                                final member = visible[index];
                                final selected = _linkedMember?.id == member.id;
                                return ScaleTap(
                                  onTap: () => setState(() => _linkedMember = member),
                                  child: _memberGridCard(member, selected: selected),
                                );
                              },
                            ),
        ),
      ],
    );
  }

  Widget _step1Empty(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline_rounded, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'pop-reg', fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _step1Error() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              _membersError!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'pop-reg', color: Colors.red),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _loadMembers,
              icon: const Icon(Icons.refresh_rounded, color: ReferralTheme.lightBlue),
              label: const Text('Try again', style: TextStyle(color: ReferralTheme.lightBlue)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberGridCard(MembersModel member, {required bool selected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: selected ? ReferralTheme.lightBlue.withOpacity(0.07) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? ReferralTheme.lightBlue : const Color(0xFFE5E7EB),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ReferralTheme.darkBlue.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _memberAvatar(member, selected: selected, grid: true),
          const SizedBox(height: 4),
          Text(
            _displayName(member.userName),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'pop-semibold',
              fontSize: 11,
              color: selected ? ReferralTheme.darkBlue : const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberAvatar(MembersModel member, {required bool selected, bool compact = false, bool grid = false}) {
    final url = _memberImageUrl(member.profilePic);
    final radius = grid ? 18.0 : (compact ? 18.0 : 28.0);
    final fontSize = grid ? 11.0 : (compact ? 13.0 : 16.0);
    final showBadge = selected && (grid || compact);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: ReferralTheme.lightBlue.withOpacity(0.15),
          backgroundImage: url.isNotEmpty ? CachedNetworkImageProvider(url) : null,
          child: url.isEmpty
              ? Text(
                  _memberInitials(member),
                  style: TextStyle(
                    fontFamily: 'pop-semibold',
                    fontSize: fontSize,
                    color: ReferralTheme.darkBlue,
                  ),
                )
              : null,
        ),
        if (showBadge)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: ReferralTheme.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 10),
            ),
          ),
      ],
    );
  }

  Widget _step2() {
    final types = [
      {
        'id': 'self',
        'label': 'Self',
        'icon': Icons.person,
        'desc': 'Introduce yourself to the selected member',
      },
      {
        'id': 'jci_member',
        'label': 'JCI Member',
        'icon': Icons.groups,
        'desc': 'Introduce another JCI member to them',
      },
      {
        'id': 'non_jci_member',
        'label': 'Non JCI Member',
        'icon': Icons.person_add_alt_1,
        'desc': 'Introduce someone outside JCI to them',
      },
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const Text('Step 2 — Referral type',
            style: TextStyle(fontFamily: 'pop-bold', fontSize: 18, color: ReferralTheme.darkBlue)),
        const SizedBox(height: 12),
        ...types.asMap().entries.map((e) {
          final t = e.value;
          final selected = _type == t['id'];
          return FadeSlideIn(
            delay: Duration(milliseconds: 80 * e.key),
            child: ScaleTap(
              onTap: () {
                final newType = t['id'] as String;
                if (newType != _type) {
                  _nameCtrl.clear();
                  _phoneCtrl.clear();
                  _remarkCtrl.clear();
                }
                setState(() => _type = newType);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? ReferralTheme.lightBlue.withOpacity(0.12) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? ReferralTheme.lightBlue : Colors.grey.shade200,
                    width: selected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ReferralTheme.darkBlue.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(t['icon'] as IconData,
                        size: 22, color: selected ? ReferralTheme.lightBlue : Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t['label'] as String,
                              style: TextStyle(
                                  fontFamily: 'pop-semibold',
                                  fontSize: 14,
                                  color: selected ? ReferralTheme.darkBlue : Colors.black87)),
                          const SizedBox(height: 1),
                          Text(
                            t['desc'] as String,
                            style: TextStyle(
                              fontFamily: 'pop-reg',
                              fontSize: 11,
                              color: selected ? ReferralTheme.darkBlue.withOpacity(0.7) : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _step3() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const Text('Step 3 — Contact details',
            style: TextStyle(fontFamily: 'pop-bold', fontSize: 18, color: ReferralTheme.darkBlue)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: ReferralTheme.lightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ReferralTheme.lightBlue.withOpacity(0.35)),
          ),
          child: Text(
            _contactHelper(),
            style: const TextStyle(
                fontFamily: 'pop-reg', fontSize: 13, color: ReferralTheme.darkBlue, height: 1.35),
          ),
        ),
        if (_linkedMember != null) ...[
          const SizedBox(height: 8),
          Text(
            'Connection goes to: ${_linkedMember!.userName ?? 'member'}',
            style: TextStyle(fontFamily: 'pop-semibold', fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
        const SizedBox(height: 12),
        _field(_nameCtrl, _nameLabel),
        _field(
          _phoneCtrl,
          _phoneLabel,
          keyboard: TextInputType.phone,
          hint: '10-digit mobile number',
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffix: IconButton(
            onPressed: _importContact,
            icon: const Icon(Icons.contacts_outlined, color: ReferralTheme.lightBlue, size: 22),
            tooltip: 'Import from contacts',
          ),
        ),
        _field(
          _remarkCtrl,
          'Remark (optional)',
          hint: 'Any extra details about this referral',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? keyboard,
    Widget? suffix,
    String? hint,
    int? maxLength,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: ReferralTheme.darkBlue.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        maxLength: maxLength,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontFamily: 'pop-reg', fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(fontFamily: 'pop-reg', fontSize: 13, color: Colors.grey.shade600),
          hintStyle: TextStyle(fontFamily: 'pop-reg', fontSize: 13, color: Colors.grey.shade400),
          counterText: maxLength != null ? '' : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
