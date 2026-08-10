import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/models/rohModel.dart';
import 'package:jci/services/roh_service.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class RohDetails extends StatefulWidget {
  @override
  _RohDetailsState createState() => _RohDetailsState();
}

class _RohDetailsState extends State<RohDetails> {
  static const _bg = Color(0xFFF5F7FA);
  static const _text = Color(0xFF1F2937);
  static const _muted = Color(0xFF6B7280);
  static const _blue = Color(0xFF23346B);
  static const _accent = Color(0xFF24B9EC);

  final _getYear = Get.arguments;
  final controller = Get.put(SponsorController());
  late final Future<List<RohModel>> _future;

  @override
  void initState() {
    super.initState();
    final year = (_getYear is List && _getYear.isNotEmpty) ? _getYear[0] : _getYear;
    _future = RohService.getROHData(year);
  }

  String get _yearLabel {
    final year = (_getYear is List && _getYear.isNotEmpty) ? _getYear[0] : _getYear;
    return '$year';
  }

  String _caps(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return '';
    return v
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  String _display(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return '—';
    return _caps(v);
  }

  Future<void> _call(String? phone) async {
    final raw = (phone ?? '').replaceAll(RegExp(r'[^\d+]'), '');
    if (raw.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: raw);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _email(String? email) async {
    final address = (email ?? '').trim();
    if (address.isEmpty) return;
    final uri = Uri(scheme: 'mailto', path: address);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: CustAppBar(
        '${Titles.roh} · $_yearLabel',
        showBack: true,
        onBack: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else if (Get.key.currentState?.canPop() ?? false) {
            Get.back();
          } else {
            Get.offAllNamed('/home');
          }
        },
      ).initAppBar(),
      body: Responsive.body(
        context,
        FutureBuilder<List<RohModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: _accent));
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return Center(
                child: Lottie.asset('assets/lottie/no_data.json', height: 180),
              );
            }
            return ListView.builder(
              padding: Responsive.listPadding(context, bottom: 28),
              itemCount: list.length + 1,
              itemBuilder: (context, index) {
                if (index == list.length) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      Visibility(
                        visible: controller.getMainSponsorVisiblity(),
                        child: SponsorData.sponserTitle('${JciString.powered_by}'),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: controller.getMainSponsorVisiblity(),
                        child: SponsorData.mainSponsor(context),
                      ),
                    ],
                  );
                }
                return _memberCard(list[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _memberCard(RohModel m) {
    final imageUrl = m.img;
    final title = m.designationName.trim().isNotEmpty ? m.designationName : (m.role ?? '');
    final year = m.designationYear.trim();
    final hasPhone = m.contact?.isNotEmpty == true;
    final hasEmail = m.email?.isNotEmpty == true;

    final professional = <Map<String, dynamic>>[];
    if ((m.officeName ?? '').isNotEmpty) {
      professional.add({
        'icon': Icons.business_outlined,
        'label': 'Company',
        'value': _display(m.officeName),
      });
    }
    if ((m.job ?? '').isNotEmpty) {
      professional.add({
        'icon': Icons.work_outline_rounded,
        'label': 'Job',
        'value': _display(m.job),
      });
    }
    if ((m.sector ?? '').isNotEmpty) {
      professional.add({
        'icon': Icons.category_outlined,
        'label': 'Sector',
        'value': _display(m.sector),
      });
    }
    if ((m.jciLocation ?? '').isNotEmpty) {
      professional.add({
        'icon': Icons.place_outlined,
        'label': 'JCI location',
        'value': _display(m.jciLocation),
      });
    }
    if ((m.location ?? '').isNotEmpty) {
      professional.add({
        'icon': Icons.location_on_outlined,
        'label': 'Location',
        'value': _display(m.location),
      });
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EEF4)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: imageUrl.isNotEmpty
                ? () => Get.toNamed('/imgView', arguments: [imageUrl])
                : null,
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD7F0FA), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: const Color(0xFFEAF7FD),
                backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                child: imageUrl.isEmpty
                    ? Text(
                        _initials(m.name),
                        style: const TextStyle(
                          fontFamily: 'pop-semibold',
                          fontSize: 28,
                          color: _blue,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _caps(m.name),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'pop-semibold',
              fontSize: 22,
              color: _text,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (title.isNotEmpty) _chip(title, filled: true),
              if (year.isNotEmpty) _chip(year),
            ],
          ),
          if (hasPhone || hasEmail) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                if (hasPhone)
                  Expanded(
                    child: _actionButton(
                      icon: Icons.phone_outlined,
                      label: 'Call',
                      onTap: () => _call(m.contact),
                    ),
                  ),
                if (hasPhone && hasEmail) const SizedBox(width: 10),
                if (hasEmail)
                  Expanded(
                    child: _actionButton(
                      icon: Icons.mail_outline_rounded,
                      label: 'Email',
                      onTap: () => _email(m.email),
                    ),
                  ),
              ],
            ),
            if (hasPhone)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  m.contact!,
                  style: const TextStyle(
                    fontFamily: 'pop-med',
                    fontSize: 13,
                    color: _muted,
                  ),
                ),
              ),
            if (hasEmail)
              Padding(
                padding: EdgeInsets.only(top: hasPhone ? 2 : 10),
                child: Text(
                  m.email!,
                  style: const TextStyle(
                    fontFamily: 'pop-med',
                    fontSize: 13,
                    color: _muted,
                  ),
                ),
              ),
          ],
          if (professional.isNotEmpty) ...[
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFD),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < professional.length; i++) ...[
                    _compactRow(
                      professional[i]['icon'] as IconData,
                      professional[i]['label'] as String,
                      professional[i]['value'] as String,
                    ),
                    if (i != professional.length - 1)
                      const Divider(height: 1, color: Color(0xFFE8EEF4)),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFEAF7FD),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: _accent),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'pop-semibold',
                  fontSize: 14,
                  color: _blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _compactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'pop-med',
                fontSize: 13,
                color: _muted,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'pop-semibold',
                fontSize: 14,
                color: _text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, {bool filled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFEAF7FD) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: filled ? const Color(0xFFBFE8F7) : const Color(0xFFD1D5DB),
        ),
      ),
      child: Text(
        _caps(text),
        style: TextStyle(
          fontFamily: 'pop-med',
          fontSize: 13,
          color: filled ? _accent : _blue,
        ),
      ),
    );
  }

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }
}
