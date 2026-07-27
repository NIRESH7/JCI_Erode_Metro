import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jci/referral/services/api_config.dart';
import 'package:jci/referral/services/auth_service.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/referral/widgets/referral_theme.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/widgets/jci_logo.dart';
import 'package:jci/utils/String.dart';
import 'package:permission_handler/permission_handler.dart';

enum _CreateStep { phoneEntry, batchConfirm, manualForm }

class MemberSetupScreen extends StatefulWidget {
  const MemberSetupScreen({super.key});

  @override
  State<MemberSetupScreen> createState() => _MemberSetupScreenState();
}

class _MemberSetupScreenState extends State<MemberSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _membershipIdCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _businessCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _maritalCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _jciLocationCtrl = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _optionalExpanded = false;
  bool _phoneLocked = false;
  _CreateStep _createStep = _CreateStep.phoneEntry;
  int? _linkedMemberId;
  Map<String, dynamic>? _batchMemberData;
  String? _googleId;
  String? _googlePhotoUrl;
  bool _editMode = false;
  bool _loadingProfile = false;
  String? _profilePic;
  File? _pickedImage;

  String? _gender;
  String? _bloodGroup;
  String? _willingToDonate;
  String? _boardMember;
  DateTime? _dob;

  bool get _fromGoogle => _googleId != null && !_editMode;
  bool get _emailLocked => _fromGoogle || _editMode;

  static const _border = Color(0xFFE5E7EB);
  static const _muted = Color(0xFF6B7280);
  static const _hint = Color(0xFF9CA3AF);
  static const _bg = Color(0xFFFAFBFC);

  static const _genders = ['male', 'female', 'others'];
  static const _bloodGroups = [
    'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-',
    'A1+', 'A2+', 'A1B+', 'A1B-', 'A2B+', 'HH',
  ];
  static const _yesNo = ['yes', 'no'];

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(() => setState(() {}));
    _loadArgs();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _membershipIdCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _addressCtrl.dispose();
    _companyCtrl.dispose();
    _businessCtrl.dispose();
    _designationCtrl.dispose();
    _maritalCtrl.dispose();
    _roleCtrl.dispose();
    _jciLocationCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadArgs() async {
    final args = Get.arguments;
    if (args is Map && args['edit'] == true) {
      final loggedIn = await SessionService.isLoggedIn();
      if (!loggedIn) {
        Get.offNamed('/member-login');
        return;
      }
      final memberId = await SessionService.getMemberId();
      if (memberId == null) {
        Get.offNamed('/member-login');
        return;
      }
      if (!mounted) return;
      setState(() {
        _editMode = true;
        _loadingProfile = true;
      });
      await _loadFullMemberFromApi(memberId);
      if (!mounted) return;
      if (_nameCtrl.text.isEmpty) {
        await SessionService.refreshProfile();
        _populateFromMember(await SessionService.getMember());
      }
      if (mounted) setState(() => _loadingProfile = false);
      return;
    }
    if (args is Map) {
      _googleId = args['google_id']?.toString();
      _emailCtrl.text = args['email']?.toString() ?? '';
      final nameArg = args['user_name']?.toString();
      final name = nameArg?.trim();
      if (name != null && name.isNotEmpty) _nameCtrl.text = name;
      _googlePhotoUrl = args['photo_url']?.toString();
      setState(() => _createStep = _CreateStep.manualForm);
      return;
    }
  }

  Future<void> _lookupPhone() async {
    final phone = _normalizePhone10(_phoneCtrl.text.trim());
    if (phone == null) {
      _snack('Enter a valid 10-digit phone number');
      return;
    }

    setState(() => _loading = true);
    try {
      final result = await AuthService.lookupPhone(phone: phone);
      if (!mounted) return;

      if (result['found'] != true) {
        setState(() {
          _createStep = _CreateStep.manualForm;
          _phoneLocked = true;
          _loading = false;
        });
        return;
      }

      if (result['has_auth'] == true) {
        _snack('Account already exists. Please sign in.');
        Get.offNamed('/member-login', arguments: {'phone': phone});
        return;
      }

      final member = Map<String, dynamic>.from(result['member'] as Map);
      setState(() {
        _linkedMemberId = int.tryParse('${member['id']}');
        _batchMemberData = member;
        _profilePic = member['profile_pic']?.toString();
        _createStep = _CreateStep.batchConfirm;
        _loading = false;
      });
    } catch (e) {
      _snack(_cleanError(e));
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitBatchActivate() async {
    if (_passwordCtrl.text.length < 6) {
      _snack('Password must be at least 6 characters');
      return;
    }
    final phone = _normalizePhone10(_phoneCtrl.text.trim());
    final memberId = _linkedMemberId;
    if (phone == null || memberId == null) {
      _snack('Invalid member session. Please start again.');
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.activateAccount(
        memberId: memberId,
        phone: phone,
        password: _passwordCtrl.text,
      );
      Get.offAllNamed('/');
    } catch (e) {
      _snack(_cleanError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _batchValue(String key) {
    final value = _batchMemberData?[key];
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;
    return text;
  }

  String _displayGender(String? gender) {
    if (gender == null) return '';
    switch (gender.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'others':
        return 'Others';
      default:
        return gender;
    }
  }

  DateTime? _parseDob(String? raw) {
    if (raw == null || raw.isEmpty || raw == 'null') return null;
    final parts = raw.split('-');
    if (parts.length != 3) return null;
    final a = int.tryParse(parts[0]);
    final b = int.tryParse(parts[1]);
    final c = int.tryParse(parts[2]);
    if (a == null || b == null || c == null) return null;
    if (a > 31) return DateTime(a, b, c);
    return DateTime(c, b, a);
  }

  String _textOrEmpty(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text == 'null') return '';
    return text;
  }

  String? _matchDropdown(String? raw, List<String> items) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty || text == 'null') return null;
    for (final item in items) {
      if (item.toLowerCase() == text.toLowerCase()) return item;
    }
    return null;
  }

  Future<void> _loadFullMemberFromApi(int memberId) async {
    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/member/member'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': memberId}),
      );
      if (res.statusCode < 200 || res.statusCode >= 300) return;
      final body = json.decode(res.body) as Map<String, dynamic>;
      final info = body['response']?['data']?['info'];
      if (!mounted || info is! Map) return;
      final member = Map<String, dynamic>.from(info);
      _populateFromMember(member);
      final token = await SessionService.getToken();
      if (token != null) {
        await SessionService.saveSession(token: token, member: member);
      }
    } catch (_) {}
  }

  void _populateFromMember(Map<String, dynamic>? mem) {
    if (mem == null) return;
    final phone = _textOrEmpty(mem['contact']);
    final memberType = _textOrEmpty(mem['type']);
    setState(() {
      _profilePic = _textOrEmpty(mem['profile_pic']);
      _nameCtrl.text = _textOrEmpty(mem['user_name']);
      _membershipIdCtrl.text = _textOrEmpty(mem['membership_id']);
      _emailCtrl.text = _textOrEmpty(mem['email']);
      _phoneCtrl.text = _normalizePhone10(phone) ?? phone;
      _gender = _matchDropdown(mem['gender']?.toString(), _genders);
      _bloodGroup = _matchDropdown(mem['blood_group']?.toString(), _bloodGroups);
      _willingToDonate = _matchDropdown(mem['willing_to_donate']?.toString(), _yesNo);
      _addressCtrl.text = _textOrEmpty(mem['location']);
      _companyCtrl.text = _textOrEmpty(mem['office_name']);
      _businessCtrl.text = _textOrEmpty(mem['sector']);
      _designationCtrl.text = _textOrEmpty(mem['job']);
      _maritalCtrl.text = _textOrEmpty(mem['martial_status']);
      _roleCtrl.text = _textOrEmpty(mem['role']).isEmpty
          ? 'Not assigned'
          : _textOrEmpty(mem['role']);
      _jciLocationCtrl.text = _textOrEmpty(mem['jci_location']);
      _boardMember = memberType == 'boardmember'
          ? 'yes'
          : (memberType == 'member' ? 'no' : _boardMember);
      _dob = _parseDob(mem['dob']?.toString());
    });
  }

  String? _normalizePhone10(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return digits;
    if (digits.length == 12 && digits.startsWith('91')) return digits.substring(2);
    if (digits.length == 11 && digits.startsWith('0')) return digits.substring(1);
    return null;
  }

  String _initials() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  String _memberImageUrl(String? pic) => ApiConfig.resolveMediaUrl(pic);

  String _formatDob(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd-$mm-${d.year}';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: ReferralTheme.lightBlue),
                title: const Text('Choose from gallery', style: TextStyle(fontFamily: 'pop-med')),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined, color: ReferralTheme.lightBlue),
                title: const Text('Take a photo', style: TextStyle(fontFamily: 'pop-med')),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    final picked = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 1200);
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 12, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ReferralTheme.lightBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ReferralTheme.darkBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _importContact() async {
    final status = await Permission.contacts.request();
    if (!status.isGranted) return;
    final contact = await FlutterContacts.openExternalPick();
    if (contact == null) return;
    final full = await FlutterContacts.getContact(contact.id);
    if (full == null) return;
    setState(() {
      if (full.displayName.isNotEmpty) _nameCtrl.text = full.displayName;
      if (full.phones.isNotEmpty) {
        final normalized = _normalizePhone10(full.phones.first.number);
        _phoneCtrl.text = normalized ?? full.phones.first.number;
      }
    });
  }

  Future<void> _submit() async {
    if (_editMode) {
      await _submitEdit();
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_pickedImage == null && (_googlePhotoUrl == null || _googlePhotoUrl!.isEmpty)) {
      _snack('Please add a profile picture');
      return;
    }
    if (_gender == null) {
      _snack('Please select gender');
      return;
    }
    if (_dob == null) {
      _snack('Please select date of birth');
      return;
    }
    if (_bloodGroup == null) {
      _snack('Please select blood group');
      return;
    }
    if (_addressCtrl.text.trim().isEmpty) {
      _snack('Please enter communication address');
      return;
    }
    if (_passwordCtrl.text.length < 6) {
      _snack('Password must be at least 6 characters');
      return;
    }

    final phone = _normalizePhone10(_phoneCtrl.text.trim());
    if (phone == null) {
      _snack('Enter a valid 10-digit phone number');
      return;
    }

    setState(() => _loading = true);
    try {
      final userName = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final password = _passwordCtrl.text;
      final gender = _gender!;
      final dob = _formatDob(_dob!);
      final bloodGroup = _bloodGroup!;
      final location = _addressCtrl.text.trim();
      final googlePhotoUrl = _pickedImage == null ? _googlePhotoUrl : null;
      final willingToDonate = _willingToDonate;
      final companyName =
          _companyCtrl.text.trim().isEmpty ? null : _companyCtrl.text.trim();
      final businessCategory =
          _businessCtrl.text.trim().isEmpty ? null : _businessCtrl.text.trim();
      final designation =
          _designationCtrl.text.trim().isEmpty ? null : _designationCtrl.text.trim();
      final boardMember = _boardMember;
      final maritalStatus =
          _maritalCtrl.text.trim().isEmpty ? null : _maritalCtrl.text.trim();
      final jciLocation =
          _jciLocationCtrl.text.trim().isEmpty ? null : _jciLocationCtrl.text.trim();

      if (_fromGoogle) {
        await AuthService.linkGoogle(
          userName: userName,
          email: email,
          googleId: _googleId!,
          password: password,
          phone: phone,
          gender: gender,
          dob: dob,
          bloodGroup: bloodGroup,
          location: location,
          profileImage: _pickedImage,
          googlePhotoUrl: googlePhotoUrl,
          willingToDonate: willingToDonate,
          companyName: companyName,
          businessCategory: businessCategory,
          designation: designation,
          boardMember: boardMember,
          maritalStatus: maritalStatus,
          jciLocation: jciLocation,
        );
      } else {
        await AuthService.setup(
          userName: userName,
          email: email,
          password: password,
          phone: phone,
          gender: gender,
          dob: dob,
          bloodGroup: bloodGroup,
          location: location,
          profileImage: _pickedImage,
          googlePhotoUrl: googlePhotoUrl,
          willingToDonate: willingToDonate,
          companyName: companyName,
          businessCategory: businessCategory,
          designation: designation,
          boardMember: boardMember,
          maritalStatus: maritalStatus,
          jciLocation: jciLocation,
        );
      }
      Get.offAllNamed('/');
    } catch (e) {
      _snack(_cleanError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitEdit() async {
    final name = _nameCtrl.text.trim();
    final phoneRaw = _phoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    if (name.isEmpty) {
      _snack('Please enter your name');
      return;
    }
    if (phoneRaw.isEmpty || _normalizePhone10(phoneRaw) == null) {
      _snack('Enter a valid 10-digit phone number');
      return;
    }
    if (_gender == null || _gender!.isEmpty) {
      _snack('Please select gender');
      return;
    }
    if (_dob == null) {
      _snack('Please select date of birth');
      return;
    }
    if (_bloodGroup == null || _bloodGroup!.isEmpty) {
      _snack('Please select blood group');
      return;
    }
    if (address.isEmpty) {
      _snack('Please enter communication address');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.updateProfile(
        userName: name,
        phone: _normalizePhone10(phoneRaw)!,
        gender: _gender!,
        dob: _formatDob(_dob!),
        bloodGroup: _bloodGroup!,
        location: address,
        membershipId: _membershipIdCtrl.text.trim(),
        willingToDonate: _willingToDonate,
        companyName: _companyCtrl.text.trim(),
        businessCategory: _businessCtrl.text.trim(),
        designation: _designationCtrl.text.trim(),
        boardMember: _boardMember,
        maritalStatus: _maritalCtrl.text.trim(),
        jciLocation: _jciLocationCtrl.text.trim(),
        profileImage: _pickedImage,
      );
      if (mounted) {
        _snack('Profile updated');
        Get.back(result: true);
      }
    } catch (e) {
      _snack(_cleanError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _cleanError(Object e) {
    final msg = '$e';
    return msg.startsWith('Exception: ') ? msg.substring(11) : msg;
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    if (_editMode) return _buildEditScaffold();
    if (_fromGoogle) return _buildCreateScaffold();
    switch (_createStep) {
      case _CreateStep.phoneEntry:
        return _buildPhoneEntryScaffold();
      case _CreateStep.batchConfirm:
        return _buildBatchConfirmScaffold();
      case _CreateStep.manualForm:
        return _buildCreateScaffold();
    }
  }

  // ─── Create / Google complete profile ─────────────────────────────────────

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
    bool readOnly = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'pop-reg', color: _hint, fontSize: 13),
      prefixIcon: Icon(icon, color: ReferralTheme.lightBlue, size: 20),
      suffixIcon: suffix,
      counterText: '',
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: readOnly ? const Color(0xFFF3F4F6) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ReferralTheme.lightBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }

  Widget _buildPhoneEntryScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: ReferralTheme.darkBlue),
                  ),
                  const Spacer(),
                  const JciLogo(height: 28),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Create your account',
                            style: TextStyle(
                              fontFamily: 'pop-bold',
                              fontSize: 24,
                              color: ReferralTheme.darkBlue,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Enter your mobile number to get started',
                            style: TextStyle(
                              fontFamily: 'pop-reg',
                              fontSize: 13,
                              color: _muted,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _field(
                            controller: _phoneCtrl,
                            label: 'Mobile number',
                            hint: '10-digit mobile',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            suffix: IconButton(
                              onPressed: _importContact,
                              icon: const Icon(Icons.contacts_outlined, size: 20, color: ReferralTheme.lightBlue),
                              splashRadius: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => Get.offNamed('/member-login'),
                            child: const Text(
                              'Already have an account? Sign in',
                              style: TextStyle(
                                fontFamily: 'pop-med',
                                fontSize: 13,
                                color: ReferralTheme.lightBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: () => Get.toNamed('/privacy-policy'),
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontFamily: 'pop-reg',
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _lookupPhone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ReferralTheme.lightBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: ReferralTheme.lightBlue.withValues(alpha: 0.45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(fontFamily: 'pop-semibold', fontSize: 15),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchSummaryRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'pop-med', fontSize: 13, color: _muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'pop-reg', fontSize: 14, color: ReferralTheme.darkBlue, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchConfirmScaffold() {
    final pic = _profilePic;
    final imageUrl = pic != null && pic.isNotEmpty ? _memberImageUrl(pic) : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _loading
                        ? null
                        : () => setState(() {
                              _createStep = _CreateStep.phoneEntry;
                              _linkedMemberId = null;
                              _batchMemberData = null;
                              _passwordCtrl.clear();
                            }),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: ReferralTheme.darkBlue),
                  ),
                  const Spacer(),
                  const JciLogo(height: 28),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Confirm your details',
                            style: TextStyle(
                              fontFamily: 'pop-bold',
                              fontSize: 24,
                              color: ReferralTheme.darkBlue,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Your details are from JCI records. You can update them later in Profile.',
                            style: TextStyle(
                              fontFamily: 'pop-reg',
                              fontSize: 13,
                              color: _muted,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 22),
                          if (imageUrl != null)
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(48),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 88,
                                  height: 88,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => CircleAvatar(
                                    radius: 44,
                                    backgroundColor: const Color(0xFFEEF6FB),
                                    child: Text(
                                      _initialsFromName(_batchValue('user_name')),
                                      style: const TextStyle(
                                        fontFamily: 'pop-bold',
                                        fontSize: 24,
                                        color: ReferralTheme.lightBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            Center(
                              child: CircleAvatar(
                                radius: 44,
                                backgroundColor: const Color(0xFFEEF6FB),
                                child: Text(
                                  _initialsFromName(_batchValue('user_name')),
                                  style: const TextStyle(
                                    fontFamily: 'pop-bold',
                                    fontSize: 24,
                                    color: ReferralTheme.lightBlue,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFBFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildBatchSummaryRow('Name', _batchValue('user_name')),
                                _buildBatchSummaryRow('Mobile', _normalizePhone10(_phoneCtrl.text.trim()) ?? _phoneCtrl.text.trim()),
                                _buildBatchSummaryRow('Email', _batchValue('email')),
                                _buildBatchSummaryRow('Gender', _displayGender(_batchValue('gender'))),
                                _buildBatchSummaryRow('Blood group', _batchValue('blood_group')),
                                _buildBatchSummaryRow('Date of birth', _batchValue('dob')),
                                _buildBatchSummaryRow('Address', _batchValue('location')),
                                _buildBatchSummaryRow('Company', _batchValue('office_name')),
                                _buildBatchSummaryRow('Designation', _batchValue('job')),
                                _buildBatchSummaryRow('JCI location', _batchValue('jci_location')),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _field(
                            controller: _passwordCtrl,
                            label: 'Password',
                            hint: 'Minimum 6 characters',
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscurePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: _hint,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submitBatchActivate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ReferralTheme.lightBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: ReferralTheme.lightBlue.withValues(alpha: 0.45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Create account',
                            style: TextStyle(fontFamily: 'pop-semibold', fontSize: 15),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initialsFromName(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  Widget _buildCreateScaffold() {
    final title = _fromGoogle ? 'Complete your profile' : 'Create your account';
    final subtitle = _fromGoogle
        ? 'Email is from Google. Fill the required details to continue.'
        : _phoneLocked
            ? 'Complete your profile to join the member network'
            : 'Enter your details to join the member network';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_phoneLocked && !_fromGoogle) {
                        setState(() {
                          _createStep = _CreateStep.phoneEntry;
                          _phoneLocked = false;
                        });
                      } else {
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: ReferralTheme.darkBlue),
                  ),
                  const Spacer(),
                  const JciLogo(height: 28),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'pop-bold',
                                fontSize: 24,
                                color: ReferralTheme.darkBlue,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontFamily: 'pop-reg',
                                fontSize: 13,
                                color: _muted,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _buildAvatarPicker(),
                            const SizedBox(height: 8),
                            const Text(
                              'Add profile photo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'pop-med',
                                fontSize: 12,
                                color: ReferralTheme.lightBlue,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _sectionHeader('Required details'),
                            const SizedBox(height: 12),
                            if (!_fromGoogle) ...[
                              _field(
                                controller: _phoneCtrl,
                                label: 'Mobile number',
                                hint: '10-digit mobile',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                readOnly: _phoneLocked,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                suffix: _phoneLocked
                                    ? null
                                    : IconButton(
                                        onPressed: _importContact,
                                        icon: const Icon(Icons.contacts_outlined, size: 20, color: ReferralTheme.lightBlue),
                                        splashRadius: 18,
                                      ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Required';
                                  if (_normalizePhone10(v) == null) return '10 digits required';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                            _field(
                              controller: _nameCtrl,
                              label: 'Username',
                              hint: 'Your full name',
                              icon: Icons.person_outline_rounded,
                              textCapitalization: TextCapitalization.words,
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 12),
                            _field(
                              controller: _emailCtrl,
                              label: 'Email',
                              hint: 'name@email.com',
                              icon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              readOnly: _emailLocked,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Required';
                                if (!v.contains('@')) return 'Enter a valid email';
                                return null;
                              },
                            ),
                            if (_fromGoogle) ...[
                              const SizedBox(height: 12),
                              _field(
                                controller: _phoneCtrl,
                                label: 'Contact',
                                hint: '10-digit mobile',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                suffix: IconButton(
                                  onPressed: _importContact,
                                  icon: const Icon(Icons.contacts_outlined, size: 20, color: ReferralTheme.lightBlue),
                                  splashRadius: 18,
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Required';
                                  if (_normalizePhone10(v) == null) return '10 digits required';
                                  return null;
                                },
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _dropdown(
                                    label: 'Gender',
                                    value: _gender,
                                    items: _genders,
                                    icon: Icons.wc_outlined,
                                    onChanged: (v) => setState(() => _gender = v),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _dropdown(
                                    label: 'Blood Group',
                                    value: _bloodGroup,
                                    items: _bloodGroups,
                                    icon: Icons.bloodtype_outlined,
                                    onChanged: (v) => setState(() => _bloodGroup = v),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _dobField(),
                            const SizedBox(height: 12),
                            _field(
                              controller: _addressCtrl,
                              label: 'Communication Address',
                              hint: 'Full address',
                              icon: Icons.location_on_outlined,
                              maxLines: 2,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 12),
                            _field(
                              controller: _passwordCtrl,
                              label: 'Password',
                              hint: 'Minimum 6 characters',
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscurePassword,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: _hint,
                                ),
                                onPressed: () =>
                                    setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              validator: (v) =>
                                  v == null || v.length < 6 ? 'Min 6 characters' : null,
                            ),
                            const SizedBox(height: 20),
                            _optionalToggle(),
                            if (_optionalExpanded) ...[
                              const SizedBox(height: 14),
                              _sectionHeader('Optional details'),
                              const SizedBox(height: 12),
                              _dropdown(
                                label: 'Willing to Donate',
                                value: _willingToDonate,
                                items: _yesNo,
                                icon: Icons.volunteer_activism_outlined,
                                onChanged: (v) => setState(() => _willingToDonate = v),
                                optional: true,
                              ),
                              const SizedBox(height: 12),
                              _field(
                                controller: _companyCtrl,
                                label: 'Company Name',
                                hint: 'Optional',
                                icon: Icons.business_outlined,
                                optional: true,
                              ),
                              const SizedBox(height: 12),
                              _field(
                                controller: _businessCtrl,
                                label: 'Business Category',
                                hint: 'Optional',
                                icon: Icons.category_outlined,
                                optional: true,
                              ),
                              const SizedBox(height: 12),
                              _field(
                                controller: _designationCtrl,
                                label: 'Designation',
                                hint: 'Optional',
                                icon: Icons.badge_outlined,
                                optional: true,
                              ),
                              const SizedBox(height: 12),
                              _dropdown(
                                label: 'Board Member',
                                value: _boardMember,
                                items: _yesNo,
                                icon: Icons.groups_outlined,
                                onChanged: (v) => setState(() => _boardMember = v),
                                optional: true,
                              ),
                              const SizedBox(height: 12),
                              _field(
                                controller: _maritalCtrl,
                                label: 'Marital Status',
                                hint: 'Optional',
                                icon: Icons.favorite_outline,
                                optional: true,
                              ),
                              const SizedBox(height: 12),
                              _field(
                                controller: _jciLocationCtrl,
                                label: 'JCI location',
                                hint: 'Chapter / location',
                                icon: Icons.map_outlined,
                                optional: true,
                              ),
                            ],
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Get.offNamed('/member-login'),
                              child: const Text(
                                'Already have an account? Sign in',
                                style: TextStyle(
                                  fontFamily: 'pop-med',
                                  fontSize: 13,
                                  color: ReferralTheme.lightBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ReferralTheme.lightBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: ReferralTheme.lightBlue.withValues(alpha: 0.45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Create account',
                            style: TextStyle(fontFamily: 'pop-semibold', fontSize: 15),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    ImageProvider? image;
    if (_pickedImage != null) {
      image = FileImage(_pickedImage!);
    } else if (_googlePhotoUrl != null && _googlePhotoUrl!.isNotEmpty) {
      image = CachedNetworkImageProvider(_googlePhotoUrl!);
    }

    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEEF6FB),
                border: Border.all(color: const Color(0xFFD7ECF7), width: 3),
                image: image != null ? DecorationImage(image: image, fit: BoxFit.cover) : null,
              ),
              child: image == null
                  ? Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: ReferralTheme.lightBlue.withValues(alpha: 0.7),
                      ),
                    )
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: ReferralTheme.lightBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: ReferralTheme.lightBlue.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: ReferralTheme.lightBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'pop-semibold',
            fontSize: 13,
            color: ReferralTheme.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _optionalToggle() {
    return Material(
      color: const Color(0xFFF7FAFC),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => setState(() => _optionalExpanded = !_optionalExpanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Icon(
                _optionalExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                size: 20,
                color: ReferralTheme.lightBlue,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Optional details',
                  style: TextStyle(
                    fontFamily: 'pop-semibold',
                    fontSize: 14,
                    color: ReferralTheme.darkBlue,
                  ),
                ),
              ),
              Text(
                _optionalExpanded ? 'Hide' : 'Show',
                style: const TextStyle(
                  fontFamily: 'pop-med',
                  fontSize: 13,
                  color: ReferralTheme.lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool readOnly = false,
    bool optional = false,
    Widget? suffix,
    TextInputType? keyboardType,
    int? maxLength,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'pop-med',
                fontSize: 13,
                color: ReferralTheme.darkBlue,
              ),
            ),
            if (optional)
              const Text(
                '  · optional',
                style: TextStyle(fontFamily: 'pop-reg', fontSize: 11, color: _hint),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          validator: validator,
          style: TextStyle(
            fontFamily: 'pop-reg',
            fontSize: 15,
            color: readOnly ? _muted : ReferralTheme.darkBlue,
          ),
          decoration: _inputDecoration(
            hint: hint,
            icon: icon,
            suffix: suffix,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'pop-med',
                fontSize: 13,
                color: ReferralTheme.darkBlue,
              ),
            ),
            if (optional)
              const Text(
                '  · optional',
                style: TextStyle(fontFamily: 'pop-reg', fontSize: 11, color: _hint),
              ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: (value != null && items.contains(value)) ? value : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _hint),
          decoration: _inputDecoration(hint: '', icon: icon),
          hint: Text(
            optional ? 'Optional' : 'Select',
            style: const TextStyle(fontFamily: 'pop-reg', fontSize: 13, color: _hint),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'pop-reg',
                      fontSize: 14,
                      color: ReferralTheme.darkBlue,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _dobField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of birth',
          style: TextStyle(
            fontFamily: 'pop-med',
            fontSize: 13,
            color: ReferralTheme.darkBlue,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickDob,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: _inputDecoration(
              hint: 'Select date of birth',
              icon: Icons.calendar_today_outlined,
            ),
            child: Text(
              _dob == null ? 'Select date of birth' : _formatDob(_dob!),
              style: TextStyle(
                fontFamily: 'pop-reg',
                fontSize: 15,
                color: _dob == null ? _hint : ReferralTheme.darkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Edit profile (existing) ──────────────────────────────────────────────

  Widget _buildEditScaffold() {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: ReferralTheme.darkBlue),
        ),
        title: const Text(
          'Update profile',
          style: TextStyle(fontFamily: 'pop-semibold', fontSize: 18, color: ReferralTheme.darkBlue),
        ),
      ),
      body: _loadingProfile
          ? const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue))
          : Column(
        children: [
          Expanded(
            child: Responsive.body(
              context,
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileHero(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          Responsive.horizontalPadding(context),
                          12,
                          Responsive.horizontalPadding(context),
                          16,
                        ),
                        child: Column(
                          children: [
                            _buildEditFormCard(),
                            const SizedBox(height: 12),
                            _buildSecurityCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProfileHero() {
    final imageUrl = _pickedImage != null ? null : _memberImageUrl(_profilePic);
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final displayName = name.isNotEmpty ? caps(name) : 'Your profile';
    ImageProvider? avatarImage;
    if (_pickedImage != null) {
      avatarImage = FileImage(_pickedImage!);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      avatarImage = CachedNetworkImageProvider(imageUrl);
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: const Color(0xFFEEF6FB),
                  backgroundImage: avatarImage,
                  child: avatarImage == null
                      ? Text(
                          name.isNotEmpty ? _initials() : '?',
                          style: const TextStyle(
                            fontFamily: 'pop-semibold',
                            fontSize: 22,
                            color: ReferralTheme.darkBlue,
                          ),
                        )
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ReferralTheme.lightBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'pop-semibold',
              fontSize: 20,
              color: ReferralTheme.darkBlue,
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'pop-reg', fontSize: 13, color: _muted),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1, color: _border),
        ],
      ),
    );
  }

  Widget _buildEditFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _editSectionTitle('Personal information'),
          _editField(
            label: 'Username',
            controller: _nameCtrl,
            hint: 'Your full name',
            icon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: _border),
          _editField(
            label: 'Membership ID',
            controller: _membershipIdCtrl,
            hint: 'JCI membership number',
            icon: Icons.badge_outlined,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: _border),
          _editField(
            label: 'Email address',
            controller: _emailCtrl,
            hint: 'Email cannot be changed',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: _border),
          _editField(
            label: 'Contact',
            controller: _phoneCtrl,
            hint: '10-digit mobile number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            trailing: IconButton(
              onPressed: _importContact,
              icon: const Icon(Icons.contacts_outlined, size: 18, color: ReferralTheme.lightBlue),
              splashRadius: 18,
              tooltip: 'Import from contacts',
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: _border),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: 'Gender',
                    value: _gender,
                    items: _genders,
                    icon: Icons.wc_outlined,
                    onChanged: (v) => setState(() => _gender = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _dropdown(
                    label: 'Blood Group',
                    value: _bloodGroup,
                    items: _bloodGroups,
                    icon: Icons.bloodtype_outlined,
                    onChanged: (v) => setState(() => _bloodGroup = v),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: _border),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: _dobField(),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: _border),
          _editField(
            label: 'Communication Address',
            controller: _addressCtrl,
            hint: 'Full address',
            icon: Icons.location_on_outlined,
            textCapitalization: TextCapitalization.sentences,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: _border),
          _editSectionTitle('Work & other details'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _dropdown(
              label: 'Willing to Donate',
              value: _willingToDonate,
              items: _yesNo,
              icon: Icons.volunteer_activism_outlined,
              onChanged: (v) => setState(() => _willingToDonate = v),
              optional: true,
            ),
          ),
          _editField(
            label: 'Company Name',
            controller: _companyCtrl,
            hint: 'Optional',
            icon: Icons.business_outlined,
          ),
          _editField(
            label: 'Business Category',
            controller: _businessCtrl,
            hint: 'Optional',
            icon: Icons.category_outlined,
          ),
          _editField(
            label: 'Designation',
            controller: _designationCtrl,
            hint: 'Optional',
            icon: Icons.work_outline_rounded,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _dropdown(
              label: 'Board Member',
              value: _boardMember,
              items: _yesNo,
              icon: Icons.groups_outlined,
              onChanged: (v) => setState(() => _boardMember = v),
              optional: true,
            ),
          ),
          _editField(
            label: 'Marital Status',
            controller: _maritalCtrl,
            hint: 'e.g. married, unmarried',
            icon: Icons.favorite_outline,
          ),
          _editField(
            label: 'Role',
            controller: _roleCtrl,
            hint: 'Assigned by admin',
            icon: Icons.workspace_premium_outlined,
            readOnly: true,
          ),
          _editField(
            label: 'JCI location',
            controller: _jciLocationCtrl,
            hint: 'Chapter / location',
            icon: Icons.map_outlined,
          ),
        ],
      ),
    );
  }

  Widget _editSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'pop-semibold',
          fontSize: 11,
          color: _muted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _editField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscure = false,
    bool readOnly = false,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(
              label,
              style: const TextStyle(fontFamily: 'pop-med', fontSize: 12, color: _muted),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Icon(icon, size: 18, color: ReferralTheme.lightBlue),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  inputFormatters: inputFormatters,
                  textCapitalization: textCapitalization,
                  style: const TextStyle(
                    fontFamily: 'pop-reg',
                    fontSize: 15,
                    color: ReferralTheme.darkBlue,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(fontFamily: 'pop-reg', fontSize: 14, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Get.toNamed('/forgot-password'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF6FB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_outline_rounded, size: 20, color: ReferralTheme.lightBlue),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change password',
                      style: TextStyle(
                        fontFamily: 'pop-semibold',
                        fontSize: 15,
                        color: ReferralTheme.darkBlue,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Reset via email verification code',
                      style: TextStyle(fontFamily: 'pop-reg', fontSize: 12, color: _muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Responsive.horizontalPadding(context),
        12,
        Responsive.horizontalPadding(context),
        16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ReferralTheme.lightBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: ReferralTheme.lightBlue.withValues(alpha: 0.45),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Save changes',
                        style: TextStyle(fontFamily: 'pop-semibold', fontSize: 15),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
