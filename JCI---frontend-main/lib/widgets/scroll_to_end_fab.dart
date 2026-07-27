import 'package:flutter/material.dart';
import 'package:jci/referral/widgets/referral_theme.dart';

class ScrollToEndFab extends StatefulWidget {
  const ScrollToEndFab({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<ScrollToEndFab> createState() => _ScrollToEndFabState();
}

class _ScrollToEndFabState extends State<ScrollToEndFab> {
  bool _atBottom = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;
    final max = widget.controller.position.maxScrollExtent;
    final atBottom = max <= 0 || widget.controller.offset >= max - 48;
    if (atBottom != _atBottom) setState(() => _atBottom = atBottom);
  }

  void _onTap() {
    final c = widget.controller;
    if (!c.hasClients) return;
    final target = _atBottom ? 0.0 : c.position.maxScrollExtent;
    c.animateTo(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: ReferralTheme.lightBlue,
      elevation: 3,
      onPressed: _onTap,
      child: Icon(
        _atBottom ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
