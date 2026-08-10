import 'package:flutter/material.dart';

/// JCI Erode Metro branding logo.
class JciLogo extends StatelessWidget {
  const JciLogo({
    super.key,
    this.height,
    this.width,
    this.alignment = Alignment.center,
  });

  final double? height;
  final double? width;
  final Alignment alignment;

  static const _asset = 'assets/images/jci_logo.png';
  static const assetPath = _asset;

  /// Keeps the logo proportional on phones, tablets, and foldables.
  static double responsiveWidth(
    BuildContext context, {
    double factor = 0.42,
    double min = 140,
    double max = 200,
  }) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    return (shortest * factor).clamp(min, max);
  }

  /// Flutter splash — hero logo (kept moderate so it does not dominate).
  static double splashWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.55).clamp(180.0, 280.0);
  }

  /// Login hero logo — compact so the form stays above the fold.
  static double loginWidth(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.shortestSide < 600) {
      return (size.width * 0.42).clamp(140.0, 180.0);
    }

    const aspect = 380 / 170;
    final byWidth = size.width * 0.28;
    final maxByHeight = size.height * 0.10 * aspect;
    return byWidth.clamp(160.0, 200.0).clamp(0.0, maxByHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Image.asset(
        _asset,
        height: height,
        width: width,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
