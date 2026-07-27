import 'package:flutter/material.dart';

/// JCI Erode Greencity branding logo.
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
    double factor = 0.72,
    double min = 220,
    double max = 320,
  }) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    return (shortest * factor).clamp(min, max);
  }

  /// Flutter splash — largest hero logo (width only; height follows aspect ratio).
  static double splashWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.92).clamp(300.0, 780.0);
  }

  /// Login hero logo — phones unchanged; smaller on tablets so the form fits.
  static double loginWidth(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.shortestSide < 600) {
      return (size.width * 0.72).clamp(280.0, 480.0);
    }

    const aspect = 380 / 170;
    final byWidth = size.width * 0.42;
    final maxByHeight = size.height * 0.14 * aspect;
    return byWidth.clamp(260.0, 320.0).clamp(0.0, maxByHeight);
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
