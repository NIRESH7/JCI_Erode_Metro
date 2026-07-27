import 'package:flutter/material.dart';
import 'package:jci/referral/models/referral_model.dart';
import 'package:jci/referral/services/referral_service.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/referral/widgets/fade_slide_in.dart';
import 'package:jci/referral/widgets/referral_theme.dart';

class ReferralDetailScreen extends StatefulWidget {
  const ReferralDetailScreen({super.key, required this.referralId});

  final int referralId;

  @override
  State<ReferralDetailScreen> createState() => _ReferralDetailScreenState();
}

class _ReferralDetailScreenState extends State<ReferralDetailScreen> {
  ReferralModel? _referral;
  int? _myId;
  bool _loading = true;
  bool _hasFullAccess = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _myId = await SessionService.getMemberId();
    _hasFullAccess = await SessionService.hasFullAccess();
    try {
      final r = await ReferralApiService.getOne(widget.referralId);
      setState(() {
        _referral = r;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _snack('$e');
    }
  }

  bool get _canRespond =>
      _hasFullAccess &&
      _referral != null &&
      _myId != null &&
      _referral!.linkedMemberId == _myId &&
      _referral!.status == 'pending';

  Future<void> _respond(String action, {String? connectionType, double? connectAmount}) async {
    try {
      await ReferralApiService.respond(
        referralId: widget.referralId,
        action: action,
        connectionType: connectionType,
        connectAmount: connectAmount,
      );
      if (action == 'accept' && connectionType == 'completed') {
        _snack('Marked as completed');
      } else if (action == 'accept' && connectionType == 'non_closed_connect') {
        _snack('Marked as non closed connection');
      } else if (action == 'reject') {
        _snack('Referral rejected');
      } else {
        _snack('Referral updated');
      }
      _load();
    } catch (e) {
      _snack('$e');
    }
  }

  void _showAcceptOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Accept Referral',
              style: TextStyle(fontFamily: 'pop-bold', fontSize: 18, color: ReferralTheme.darkBlue),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to accept this referral',
              style: TextStyle(fontFamily: 'pop-reg', color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ReferralTheme.primaryButton,
              onPressed: () {
                Navigator.pop(ctx);
                _showAmountDialog();
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Completed'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: ReferralTheme.outlineButton,
              onPressed: () {
                Navigator.pop(ctx);
                _respond('accept', connectionType: 'non_closed_connect');
              },
              icon: const Icon(Icons.link),
              label: const Text('Non Closed Connect'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAmountDialog() {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Connect Amount', style: TextStyle(fontFamily: 'pop-semibold')),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              final amount = double.tryParse(v?.trim() ?? '');
              if (amount == null || amount <= 0) return 'Enter a valid amount';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ReferralTheme.primaryButton,
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final amount = double.parse(controller.text.trim());
              Navigator.pop(ctx);
              _respond('accept', connectionType: 'completed', connectAmount: amount);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReferralTheme.softBg,
      appBar: AppBar(
        backgroundColor: ReferralTheme.darkBlue,
        title: const Text('Referral Details',
            style: TextStyle(fontFamily: 'pop-semibold', color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue))
          : _referral == null
              ? const Center(child: Text('Not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: FadeSlideIn(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: ReferralTheme.cardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_referral!.referredName,
                                  style: const TextStyle(
                                      fontFamily: 'pop-bold', fontSize: 24, color: ReferralTheme.darkBlue)),
                              const SizedBox(height: 8),
                              Text(_referral!.referredPhone,
                                  style: TextStyle(fontFamily: 'pop-reg', color: Colors.grey.shade600)),
                              const Divider(height: 28),
                              _row('Type', _referral!.typeLabel),
                              _row('Status', _referral!.statusLabel),
                              if (_referral!.remark != null && _referral!.remark!.trim().isNotEmpty)
                                _row('Remark', _referral!.remark!),
                              if (_referral!.connectAmount != null)
                                _row('Connect Amount', '₹${_referral!.connectAmount!.toStringAsFixed(2)}'),
                              if (_referral!.referrerName != null)
                                _row('From', _referral!.referrerName!),
                              if (_referral!.linkedMemberName != null)
                                _row('Connection for', _referral!.linkedMemberName!),
                            ],
                          ),
                        ),
                        if (_canRespond) ...[
                          const SizedBox(height: 24),
                          ScaleTap(
                            onTap: _showAcceptOptions,
                            child: ElevatedButton.icon(
                              style: ReferralTheme.primaryButton,
                              onPressed: _showAcceptOptions,
                              icon: const Icon(Icons.check),
                              label: const Text('Accept'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ScaleTap(
                            onTap: () => _respond('reject'),
                            child: OutlinedButton.icon(
                              style: ReferralTheme.outlineButton,
                              onPressed: () => _respond('reject'),
                              icon: const Icon(Icons.close),
                              label: const Text('Reject'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: TextStyle(fontFamily: 'pop-med', color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontFamily: 'pop-semibold')),
          ),
        ],
      ),
    );
  }
}
