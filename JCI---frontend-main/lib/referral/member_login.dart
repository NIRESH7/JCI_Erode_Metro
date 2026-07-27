import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/referral/services/auth_service.dart';
import 'package:jci/referral/widgets/referral_theme.dart';
import 'package:jci/widgets/jci_logo.dart';

class MemberLoginScreen extends StatefulWidget {
  const MemberLoginScreen({super.key});

  @override
  State<MemberLoginScreen> createState() => _MemberLoginScreenState();
}

class _MemberLoginScreenState extends State<MemberLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['phone'] != null) {
      _loginCtrl.text = args['phone'].toString();
    }
  }

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService.login(
        login: _loginCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      Get.offAllNamed('/');
    } catch (e) {
      _snack('$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _createAccount() {
    Get.toNamed('/member-setup');
  }

  void _snack(String msg) {
    final text = msg.startsWith('Exception: ') ? msg.substring(11) : msg;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTabletLandscape =
        size.shortestSide >= 600 && size.width > size.height;
    final vPad = isTabletLandscape ? 12.0 : 28.0;
    final logoGap = isTabletLandscape ? 12.0 : 28.0;
    final sectionGap = isTabletLandscape ? 16.0 : 28.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: vPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                JciLogo(width: JciLogo.loginWidth(context)),
                SizedBox(height: logoGap),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    const Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'pop-bold',
                        fontSize: 26,
                        color: ReferralTheme.darkBlue,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to give and receive referrals',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'pop-reg',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: sectionGap),
                    _field(
                      controller: _loginCtrl,
                      label: 'Phone or email',
                      hint: 'Enter phone or email',
                      icon: Icons.person_outline_rounded,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _passwordCtrl,
                      label: 'Password',
                      hint: 'Min 6 characters',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 20,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () => Get.toNamed('/forgot-password'),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(fontFamily: 'pop-med', color: ReferralTheme.lightBlue),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ReferralTheme.lightBlue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: ReferralTheme.lightBlue.withOpacity(0.4),
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
                                'Sign in',
                                style: TextStyle(fontFamily: 'pop-semibold', fontSize: 15),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(
                              fontFamily: 'pop-reg',
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _loading ? null : _createAccount,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ReferralTheme.darkBlue,
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          'Create an account',
                          style: TextStyle(fontFamily: 'pop-semibold', fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'pop-med',
            fontSize: 13,
            color: ReferralTheme.darkBlue,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          style: const TextStyle(fontFamily: 'pop-reg', fontSize: 15, color: ReferralTheme.darkBlue),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'pop-reg', color: Color(0xFF9CA3AF)),
            prefixIcon: Icon(icon, color: ReferralTheme.lightBlue, size: 20),
            suffixIcon: suffix,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: ReferralTheme.lightBlue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
