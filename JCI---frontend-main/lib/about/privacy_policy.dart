import 'package:flutter/material.dart';
import 'package:jci/utils/app_config.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/titles.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _titleStyle = TextStyle(
    fontFamily: 'pop-bold',
    fontSize: 16,
    color: Color(0xFF23346B),
  );

  static final _bodyStyle = TextStyle(
    fontFamily: 'pop-reg',
    fontSize: 14,
    height: 1.55,
    color: Colors.grey.shade800,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(Titles.privacyPolicy).initAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last updated: July 2026', style: _bodyStyle.copyWith(fontSize: 12)),
            const SizedBox(height: 16),
            Text(
              '${AppConfig.appName} ("we", "our", or "us") operates the mobile application '
              'for members of JCI Erode Greencity. This policy explains what information we collect, '
              'how we use it, and your choices.',
              style: _bodyStyle,
            ),
            const SizedBox(height: 20),
            const Text('Information we collect', style: _titleStyle),
            const SizedBox(height: 8),
            Text(
              '• Account details you provide: name, phone, email, business information, and profile photo.\n'
              '• Contacts (only when you choose to pick a contact for referrals).\n'
              '• Device identifiers for push notifications (Firebase Cloud Messaging).\n'
              '• Usage data needed to operate features such as events, referrals, blood requests, and fitness club stories.',
              style: _bodyStyle,
            ),
            const SizedBox(height: 20),
            const Text('How we use information', style: _titleStyle),
            const SizedBox(height: 8),
            Text(
              'We use your information to authenticate members, manage referrals, send event and '
              'notification updates, display member directories, and improve app functionality. '
              'We do not sell your personal data.',
              style: _bodyStyle,
            ),
            const SizedBox(height: 20),
            const Text('Data sharing', style: _titleStyle),
            const SizedBox(height: 8),
            Text(
              'Data is shared only with authorized JCI Erode Greencity administrators and service '
              'providers required to run the app (hosting, Firebase/Google for sign-in and notifications).',
              style: _bodyStyle,
            ),
            const SizedBox(height: 20),
            const Text('Data retention & security', style: _titleStyle),
            const SizedBox(height: 8),
            Text(
              'We retain account data while your membership is active. We use HTTPS for API '
              'communication and secure storage for login tokens on your device.',
              style: _bodyStyle,
            ),
            const SizedBox(height: 20),
            const Text('Your choices', style: _titleStyle),
            const SizedBox(height: 8),
            Text(
              'You may update your profile, log out, or request account deletion by contacting us. '
              'You can deny contact permission; referral contact picking will not be available.',
              style: _bodyStyle,
            ),
            const SizedBox(height: 20),
            const Text('Contact', style: _titleStyle),
            const SizedBox(height: 8),
            Text(
              'Questions about this policy: ${AppConfig.supportEmail}',
              style: _bodyStyle,
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse(AppConfig.privacyPolicyUrl),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text(
                  'View online',
                  style: TextStyle(fontFamily: 'pop-med'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
