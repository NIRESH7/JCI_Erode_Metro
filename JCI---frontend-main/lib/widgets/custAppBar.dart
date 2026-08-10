import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/referral/services/session_service.dart';

class CustAppBar {
  String appBarTitle;
  PreferredSizeWidget? bottom;
  List<Widget>? actions;
  bool showNotificationBell;
  bool showBack;
  int unreadCount;
  VoidCallback? onNotificationTap;
  VoidCallback? onBack;

  CustAppBar(
    this.appBarTitle, {
    this.bottom,
    this.actions,
    this.showNotificationBell = false,
    this.showBack = false,
    this.unreadCount = 0,
    this.onNotificationTap,
    this.onBack,
  });

  Widget _notificationBell() {
    return IconButton(
      tooltip: 'Notifications',
      onPressed: onNotificationTap ??
          () async {
            final loggedIn = await SessionService.isLoggedIn();
            if (!loggedIn) {
              Get.toNamed('/member-login');
              return;
            }
            Get.toNamed('/notifications');
          },
      icon: Badge(
        isLabelVisible: unreadCount > 0,
        label: Text(
          unreadCount > 99 ? '99+' : '$unreadCount',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFE11D48),
        child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1F2937), size: 26),
      ),
    );
  }

  void _handleBack() {
    if (onBack != null) {
      onBack!();
      return;
    }
    final nav = Get.key.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return;
    }
    // Web / deep-link: no stack to pop — go home.
    Get.offAllNamed('/home');
  }

  AppBar initAppBar() {
    return AppBar(
      leading: showBack
          ? IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: _handleBack,
            )
          : null,
      automaticallyImplyLeading: !showBack,
      title: Text(
        appBarTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18, fontFamily: "pop-semibold", color: Colors.black),
      ),
      actions: [
        if (showNotificationBell) _notificationBell(),
        ...?actions,
      ],
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      titleSpacing: 8,
      bottom: bottom,
    );
  }

  AppBar loadingAppBar() {
    return AppBar(
      title: Text(
        appBarTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18, fontFamily: "pop-semibold", color: Colors.black),
      ),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}
