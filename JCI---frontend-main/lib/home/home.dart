import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/services/homeService.dart';
import 'package:jci/services/notification_service.dart';
import 'package:jci/referral/services/referral_service.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/common.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/drawer.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';

import '../services/sponser_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var controller = Get.put(SponsorController());

  var isLoading = true;
  double _connectTotal = 0;
  bool _refreshingConnectTotal = false;
  int _unreadNotifications = 0;
  List<String> _banners = [];
  bool _bannersLoading = true;
  bool _routeWasCurrent = true;

  @override
  void initState() {
    super.initState();
    getSponsorData();
    _loadConnectTotal();
    _loadUnreadNotifications();
    _loadBanners();
    SessionService.refreshProfile();
  }

  Future<void> _loadBanners() async {
    try {
      final next = await HomeService.getPastEventImages();
      if (!mounted) return;
      setState(() {
        _banners = next;
        _bannersLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _bannersLoading = false);
    }
  }

  Future<void> _loadUnreadNotifications() async {
    try {
      final count = await NotificationApiService.unreadCount();
      if (mounted) setState(() => _unreadNotifications = count);
    } catch (_) {}
  }

  Future<void> _openNotifications() async {
    final loggedIn = await SessionService.isLoggedIn();
    if (!loggedIn) {
      Get.toNamed('/member-login');
      return;
    }
    await Get.toNamed('/notifications');
    if (mounted) _loadUnreadNotifications();
  }

  Future<void> _refreshHome() async {
    await Future.wait([
      _loadBanners(),
      _loadConnectTotal(),
      _loadUnreadNotifications(),
      getSponsorData(),
    ]);
  }

  Future<void> _loadConnectTotal() async {
    try {
      if (_refreshingConnectTotal) return;
      _refreshingConnectTotal = true;
      final total = await ReferralApiService.getTotalConnectAmount();
      if (mounted) setState(() => _connectTotal = total);
    } catch (_) {
    } finally {
      _refreshingConnectTotal = false;
    }
  }

  Future<void> getSponsorData() async {
    try {
      final coSponsor = await SponsorService.getOurSponserData();
      final poweredBy = await SponsorService.getSponserData();

      controller.setVisible(coSponsor.isNotEmpty);
      controller.setMainSponsorVisible(poweredBy.isNotEmpty);
    } catch (_) {
      controller.setVisible(false);
      controller.setMainSponsorVisible(false);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _onRouteVisibilityChanged(bool isCurrent) {
    if (isCurrent && !_routeWasCurrent) {
      _routeWasCurrent = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        SessionService.refreshProfile();
        _loadConnectTotal();
        _loadUnreadNotifications();
        _loadBanners();
      });
    } else if (!isCurrent && _routeWasCurrent) {
      _routeWasCurrent = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
    if (isCurrent != _routeWasCurrent) {
      _onRouteVisibilityChanged(isCurrent);
    }
    return isLoading ? _loading() : _home(context);
  }

  Widget _bannerSection(double carouselHeight) {
    if (_bannersLoading && _banners.isEmpty) {
      return SizedBox(
        height: carouselHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_banners.isEmpty) {
      return const SizedBox.shrink();
    }
    return CarouselSlider.builder(
      itemCount: _banners.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          GestureDetector(
        onTap: () => Get.toNamed("/imgView", arguments: [_banners[itemIndex]]),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(color: Color(0xff1A000000), blurRadius: 4, offset: Offset(0, 0)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _banners[itemIndex],
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: carouselHeight,
              errorBuilder: (_, obj, err) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
      options: CarouselOptions(
        height: carouselHeight,
        enlargeCenterPage: true,
        initialPage: 0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }

  Widget _gridTap({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }

  Scaffold _home(BuildContext context) {
    final carouselHeight = Responsive.carouselHeight(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustAppBar(
        Titles.home,
        showNotificationBell: true,
        unreadCount: _unreadNotifications,
        onNotificationTap: _openNotifications,
      ).initAppBar(),
      body: Responsive.body(
        context,
        RefreshIndicator(
          onRefresh: _refreshHome,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _space(5),
                _bannerSection(carouselHeight),
                _space(10),
                EventButton(),
                _space(16),
                _connectTotalCard(),
                _space(16),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.4,
                  ),
                  children: [
                    _gridTap(
                      onTap: () => Get.toNamed("/about"),
                      child: _homeGridItem(
                        icon: SvgPicture.asset("assets/icons/about_colored.svg", width: 30, height: 30),
                        label: "About",
                      ),
                    ),
                    _gridTap(
                      onTap: () => Get.toNamed("/members", arguments: ["mem"]),
                      child: _homeGridItem(
                        icon: SvgPicture.asset("assets/icons/board_members.svg", width: 30, height: 30),
                        label: "Members",
                      ),
                    ),
                    _gridTap(
                      onTap: () => Get.toNamed("/dashboard"),
                      child: _homeGridItem(
                        icon: SvgPicture.asset("assets/icons/dashboard.svg", width: 30, height: 30),
                        label: "Green Channel",
                      ),
                    ),
                    _gridTap(
                      onTap: () => Get.toNamed("/roh"),
                      child: _homeGridItem(
                        icon: SvgPicture.asset("assets/icons/roll_of_honour_colored.svg", width: 30, height: 30),
                        label: "Roll of honour",
                      ),
                    ),
                    _gridTap(
                      onTap: () => Get.toNamed("/birthday"),
                      child: _homeGridItem(
                        icon: SvgPicture.asset("assets/icons/birthday_colored.svg", width: 30, height: 30),
                        label: "Birthday",
                      ),
                    ),
                    _gridTap(
                      onTap: () => Get.toNamed("/blood"),
                      child: _homeGridItem(
                        icon: SvgPicture.asset("assets/icons/blood_colored.svg", width: 30, height: 30),
                        label: "Blood Donors",
                      ),
                    ),
                    _gridTap(
                      onTap: () => Get.toNamed("/referral"),
                      child: _homeGridItem(
                        icon: SvgPicture.asset("assets/icons/members_colored.svg", width: 30, height: 30),
                        label: "Referrals",
                      ),
                    ),
                    _gridTap(
                      onTap: () => Get.toNamed("/fitness-club"),
                      child: _homeGridItem(
                        icon: Icon(Icons.favorite_border, size: 30, color: Color(0xFF24356F)),
                        label: "Fitness Club",
                      ),
                    ),
                  ],
                ),
                _space(10),
                Visibility(
                  visible: controller.getMainSponsorVisiblity(),
                  child: SponsorData.sponserTitle("${JciString.powered_by}"),
                ),
                _space(10),
                SponsorData.mainSponsor(context),
                _space(20),
              ],
            ),
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 13, fontFamily: "pop-med"),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _homeGridItem({required Widget icon, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: Center(child: icon),
        ),
        _space(8),
        _title(label),
      ],
    );
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }

  Widget _connectTotalCard() {
    final formatted = _formatIndianCurrency(_connectTotal);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCEAF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF23346B).withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF24B9EC),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.currency_rupee, color: Color(0xFF23346B), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Connect Amount',
                  style: TextStyle(
                    fontFamily: 'pop-med',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatted,
                  style: const TextStyle(
                    fontFamily: 'pop-bold',
                    fontSize: 24,
                    color: Color(0xFF23346B),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Completed',
              style: TextStyle(
                fontFamily: 'pop-med',
                fontSize: 10,
                color: Color(0xFF24B9EC),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatIndianCurrency(double amount) {
    final whole = amount.floor();
    final decimals = ((amount - whole) * 100).round().toString().padLeft(2, '0');
    final s = whole.toString();
    if (s.length <= 3) return '₹$s.$decimals';
    final last3 = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    return '₹${parts.join(',')},$last3.$decimals';
  }

}

Scaffold _loading() {
  return Scaffold(
    appBar: CustAppBar(Titles.home).loadingAppBar(),
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
