import 'package:flutter/material.dart';

/// Helpers for layouts that adapt across phone sizes and foldables.
class Responsive {
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Side padding that scales but stays within sensible bounds.
  static double horizontalPadding(BuildContext context) =>
      (screenWidth(context) * 0.04).clamp(8.0, 16.0);

  /// Carousel / banner height based on screen height.
  static double carouselHeight(BuildContext context) =>
      (screenHeight(context) * 0.22).clamp(150.0, 220.0);

  /// Max content width on tablets / unfolded foldables.
  static const double maxContentWidth = 720;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  /// Centers content and caps width on very wide screens.
  static Widget body(BuildContext context, Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }

  static EdgeInsets listPadding(BuildContext context, {double bottom = 12}) {
    final side = horizontalPadding(context);
    return EdgeInsets.fromLTRB(side, 0, side, bottom);
  }
}
