import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/services/homeService.dart';
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
  bool _routeWasCurrent = true;
  bool _refreshingConnectTotal = false;
  Future<List<String>> _bannersFuture = HomeService.getPastEventImages();

  @override
  void initState() {
    super.initState();

    getSponsorData();
    _loadConnectTotal();
    SessionService.refreshProfile();
  }

  void _loadBanners() {
    setState(() {
      _bannersFuture = HomeService.getPastEventImages();
    });
  }

  Future<void> _refreshHome() async {
    _loadBanners();
    await Future.wait([
      _bannersFuture.catchError((_) => <String>[]),
      _loadConnectTotal(),
    ]);
    await getSponsorData();
  }

  Future<void> _loadConnectTotal() async {
    try {
      if (_refreshingConnectTotal) return;
      _refreshingConnectTotal = true;
      final total = await ReferralApiService.getTotalConnectAmount();
      if (mounted) setState(() => _connectTotal = total);
    } catch (_) {}
    finally {
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

  @override
  Widget build(BuildContext context) {
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
    // Refresh home data when coming back to this screen.
    if (isCurrent && !_routeWasCurrent) {
      _routeWasCurrent = true;
      SessionService.refreshProfile();
      _loadConnectTotal();
      _loadBanners();
    } else if (!isCurrent && _routeWasCurrent) {
      _routeWasCurrent = false;
    }
    return isLoading ? _loading() : _home(context);
  }

  Scaffold _home(BuildContext context) {
    final carouselHeight = Responsive.carouselHeight(context);
    return Scaffold(
      appBar: CustAppBar(Titles.home).initAppBar(),
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
            // event images
            FutureBuilder<List<String>>(
              future: _bannersFuture,
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.data == null && snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: carouselHeight,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
                  return SizedBox.shrink();
                } else {
                  final banners = snapshot.data ?? [];
                  return banners.isEmpty
                      ? Container()
                      : CarouselSlider.builder(
                          itemCount: banners.length,
                          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
                            onTap: () => Get.toNamed("/imgView", arguments: [banners[itemIndex]]),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                              decoration:
                                  BoxDecoration(boxShadow: [BoxShadow(color: Color(0xff1A000000), blurRadius: 4, offset: Offset(0, 0))]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  banners[itemIndex],
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: carouselHeight,
                                  errorBuilder: (_, obj, err) => Container(),
                                ),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            height: carouselHeight,
                            enlargeCenterPage: true,
                            initialPage: 0,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                          ),
                        );
                }
              },
            ),
            _space(10),
            // Event button
            EventButton(),
            _space(16),
            _connectTotalCard(),
            _space(16),
            GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.4,
              ),
              children: [
                InkWell(
                  onTap: () => Get.toNamed("/about"),
                  child: _homeGridItem(
                    icon: SvgPicture.asset("assets/icons/about_colored.svg", width: 30, height: 30),
                    label: "About",
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.toNamed("/members", arguments: ["bm"]);
                  },
                  child: _homeGridItem(
                    icon: SvgPicture.asset("assets/icons/board_members.svg", width: 30, height: 30),
                    label: "Members",
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.toNamed("/dashboard");
                  },
                  child: _homeGridItem(
                    icon: SvgPicture.asset("assets/icons/dashboard.svg", width: 30, height: 30),
                    label: "Green Channel",
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     Get.back();
                //     Get.toNamed("/members", arguments: ['mem']);
                //   },
                //   child: Container(
                //     child: Column(
                //       children: [
                //         SvgPicture.asset("assets/icons/members_colored.svg",
                //             width: 30, height: 30),
                //         _space(10),
                //         _title("Members")
                //       ],
                //     ),
                //   ),
                // ),
                InkWell(
                  onTap: () => Get.toNamed("/roh"),
                  child: _homeGridItem(
                    icon: SvgPicture.asset("assets/icons/roll_of_honour_colored.svg", width: 30, height: 30),
                    label: "Roll of honour",
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed("/birthday"),
                  child: _homeGridItem(
                    icon: SvgPicture.asset("assets/icons/birthday_colored.svg", width: 30, height: 30),
                    label: "Birthday",
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed("/blood"),
                  child: _homeGridItem(
                    icon: SvgPicture.asset("assets/icons/blood_colored.svg", width: 30, height: 30),
                    label: "Blood Donors",
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed("/referral"),
                  child: _homeGridItem(
                    icon: SvgPicture.asset("assets/icons/members_colored.svg", width: 30, height: 30),
                    label: "Referrals",
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed("/fitness-club"),
                  child: _homeGridItem(
                    icon: SvgPicture.asset("assets/icons/heart.svg", width: 30, height: 30),
                    label: "Fitness Club",
                  ),
                ),
                //     InkWell(
                //       onTap: () => Get.toNamed("blood-request-list"),
                //       child: Container(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           crossAxisAlignment: CrossAxisAlignment.stretch,
                //           children: [
                //             SvgPicture.asset(
                //               "assets/icons/blood_colored.svg",
                //               width: 30,
                //               height: 30,
                //             ),
                //             _title("Create Blood Request")
                //           ],
                //         ),
                //       ),
                //     ),
                //     InkWell(
                //       onTap: () => Get.toNamed("blood-request-list"),
                //       child: Container(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           crossAxisAlignment: CrossAxisAlignment.stretch,
                //           children: [
                //             SvgPicture.asset(
                //               "assets/icons/blood_colored.svg",
                //               width: 30,
                //               height: 30,
                //             ),
                //             _title("Blood Request List")
                //           ],
                //         ),
                //       ),
                //     )
              ],
            ),
            _space(10),
            Visibility(visible: controller.getMainSponsorVisiblity(), child: SponsorData.sponserTitle("${JciString.powered_by}")),
            _space(10),
            SponsorData.mainSponsor(context),
            // _space(10),
            // Visibility(
            //     visible: controller.getVisible(),
            //     child: SponsorData.sponserTitle('${JciString.co_powered_by}')),
            // SponsorData.otherSponsor(context),
            _space(20)
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
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: Center(child: icon),
        ),
        _space(10),
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
