import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:get/get.dart';

/// Shared smooth page transitions for the app.
class AppNavigation {
  static const Duration duration = Duration(milliseconds: 240);
  static const Curve curve = Curves.easeOutCubic;
  static const Transition defaultTransition = Transition.cupertino;
  static const Transition modalTransition = Transition.downToUp;
  static const Transition fadeTransition = Transition.fadeIn;
  static const Transition sharedAxisTransition = Transition.noTransition;

  static final CustomTransition sharedAxisHorizontal = _SharedAxisRouteTransition(
    type: SharedAxisTransitionType.horizontal,
  );

  static final CustomTransition sharedAxisVertical = _SharedAxisRouteTransition(
    type: SharedAxisTransitionType.vertical,
  );

  static final CustomTransition fadeThrough = _FadeThroughRouteTransition();

  static Future<T?>? to<T>(
    Widget page, {
    Transition? transition,
  }) {
    return Get.to<T>(
      () => page,
      transition: transition ?? defaultTransition,
      duration: duration,
      curve: curve,
    );
  }

  static GetPage page({
    required String name,
    required GetPageBuilder page,
    Transition? transition,
    CustomTransition? customTransition,
    Duration? transitionDuration,
  }) {
    return GetPage(
      name: name,
      page: page,
      transition: transition ?? defaultTransition,
      customTransition: customTransition,
      transitionDuration: transitionDuration ?? duration,
      curve: curve,
    );
  }
}

class _SharedAxisRouteTransition extends CustomTransition {
  _SharedAxisRouteTransition({required this.type});

  final SharedAxisTransitionType type;

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: type,
      fillColor: Colors.transparent,
      child: child,
    );
  }
}

class _FadeThroughRouteTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      fillColor: Colors.transparent,
      child: child,
    );
  }
}
