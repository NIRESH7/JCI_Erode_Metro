import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/referral/services/auth_service.dart';
import 'package:jci/referral/widgets/referral_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  bool _loading = false;
  bool _codeSent = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _codeCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _snack('Enter your registered email');
      return;
    }
    setState(() => _loading = true);
    try {
      final msg = await AuthService.forgotPassword(email);
      setState(() => _codeSent = true);
      _snack(msg);
    } catch (e) {
      _snack(_cleanError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailCtrl.text.trim();
    final code = _codeCtrl.text.trim();
    final password = _newPassCtrl.text;

    if (email.isEmpty) {
      _snack('Enter your email');
      return;
    }
    if (code.isEmpty) {
      _snack('Enter the reset code from your email');
      return;
    }
    if (password.length < 6) {
      _snack('New password min 6 characters');
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.resetPassword(
        email: email,
        resetToken: code.toUpperCase(),
        newPassword: password,
      );
      Get.offAllNamed('/');
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
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
          'Reset password',
          style: TextStyle(fontFamily: 'pop-semibold', fontSize: 17, color: ReferralTheme.darkBlue),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE5E7EB)),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _codeSent
                        ? 'Enter the code from your email and choose a new password'
                        : 'We will send a reset code to your registered email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'pop-reg',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _field(
                    controller: _emailCtrl,
                    label: 'Email',
                    hint: 'your@email.com',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: _loading ? null : _sendCode,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ReferralTheme.lightBlue,
                        side: const BorderSide(color: ReferralTheme.lightBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Send reset code',
                        style: TextStyle(fontFamily: 'pop-semibold', fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _field(
                    controller: _codeCtrl,
                    label: 'Reset code',
                    hint: 'Code from email',
                    icon: Icons.pin_outlined,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    controller: _newPassCtrl,
                    label: 'New password',
                    hint: 'Minimum 6 characters',
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
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _resetPassword,
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
                              'Set new password',
                              style: TextStyle(fontFamily: 'pop-semibold', fontSize: 15),
                            ),
                    ),
                  ),
                ],
              ),
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
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? suffix,
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
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
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
          ),
        ),
      ],
    );
  }
}
