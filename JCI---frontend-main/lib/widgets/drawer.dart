import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/widgets/jci_logo.dart';
import 'package:jci/widgets/titles.dart';

var lightBlue = '24B9EC';
var darkBlue = '23346B';
double _svgWidth = 20;

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: Get.width * 0.8,
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: JciLogo(height: 72, alignment: Alignment.centerLeft),
                ),
                Divider(),
                // about
                ListTile(
                  title: _listTile(Titles.about),
                  minLeadingWidth: 1,
                  leading: _about,
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/about");
                  },
                ),
                ListTile(
                  title: _listTile(Titles.privacyPolicy),
                  minLeadingWidth: 1,
                  leading: Icon(Icons.privacy_tip_outlined, color: Color(0xFF24B9EC), size: _svgWidth),
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/privacy-policy");
                  },
                ),
                // events
                ListTile(
                    title: _listTile(Titles.event),
                    minLeadingWidth: 1,
                    leading: _events,
                    dense: true,
                    onTap: () {
                      Get.back();
                      Get.toNamed("/events");
                    }),
                // board member
                ListTile(
                  title: _listTile(Titles.boardMembers),
                  minLeadingWidth: 1,
                  leading: _board_member,
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/members", arguments: ["bm"]);
                  },
                ),
                // past president
                ListTile(
                  title: _listTile(Titles.greenChannel),
                  minLeadingWidth: 1,
                  leading: _dashboard,
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/dashboard", arguments: ["pp"]);
                  },
                ),
                // member
                ListTile(
                  title: _listTile(Titles.members),
                  minLeadingWidth: 1,
                  leading: _members,
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/members", arguments: ['mem']);
                  },
                ),
                // roll of honour
                ListTile(
                  title: _listTile(Titles.roh),
                  minLeadingWidth: 1,
                  leading: _roll_of_honour,
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/roh");
                  },
                ),
                // birthday
                ListTile(
                  title: _listTile(Titles.birthday),
                  minLeadingWidth: 1,
                  leading: _birthday,
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/birthday");
                  },
                ),
                // blood donors
                ListTile(
                  title: _listTile(Titles.bloodDonors),
                  minLeadingWidth: 1,
                  leading: _blood,
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/blood");
                  },
                ),
                ListTile(
                  title: _listTile("Referrals"),
                  minLeadingWidth: 1,
                  leading: Icon(Icons.share_outlined, color: Color(0xFF24B9EC), size: _svgWidth),
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/referral");
                  },
                ),
                ListTile(
                  title: _listTile("Fitness Club"),
                  minLeadingWidth: 1,
                  leading: Icon(Icons.fitness_center, color: Color(0xFF24B9EC), size: _svgWidth),
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/fitness-club");
                  },
                ),
                ListTile(
                  title: _listTile("Logged In Members"),
                  minLeadingWidth: 1,
                  leading: Icon(Icons.people_alt_outlined, color: Color(0xFF24B9EC), size: _svgWidth),
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.toNamed("/logged-in-members");
                  },
                ),
                ListTile(
                  title: _listTile("My Profile"),
                  minLeadingWidth: 1,
                  leading: Icon(Icons.person_outline, color: Color(0xFF24B9EC), size: _svgWidth),
                  dense: true,
                  onTap: () async {
                    Get.back();
                    final loggedIn = await SessionService.isLoggedIn();
                    if (!loggedIn) {
                      Get.toNamed('/member-login');
                      return;
                    }
                    final memberId = await SessionService.getMemberId();
                    if (memberId == null) {
                      Get.toNamed('/member-login');
                      return;
                    }
                    Get.toNamed('/profile', arguments: [memberId]);
                  },
                ),
                ListTile(
                  title: _listTile("Logout"),
                  minLeadingWidth: 1,
                  leading: Icon(Icons.logout, color: Color(0xFF24B9EC), size: _svgWidth),
                  dense: true,
                  onTap: () async {
                    Get.back();
                    await SessionService.clear();
                    Get.offAllNamed('/member-login');
                  },
                )
                ],
              ),
            ),
            Text(
              'Developed by',
              style: TextStyle(
                fontFamily: "pop-med",
                fontSize: 11,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                height: Get.height * 0.05,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 8,
            )
          ],
        ),
      ),
    );
  }

  final Widget _about = SvgPicture.asset(
    'assets/icons/about_colored.svg',
    width: _svgWidth,
  );

  final Widget _birthday = SvgPicture.asset(
    'assets/icons/birthday_colored.svg',
    width: _svgWidth,
  );

  final Widget _blood = SvgPicture.asset(
    'assets/icons/blood_colored.svg',
    width: _svgWidth,
  );

  final Widget _board_member = SvgPicture.asset(
    'assets/icons/board_members.svg',
    width: _svgWidth,
  );

  final Widget _members = SvgPicture.asset(
    'assets/icons/members_colored.svg',
    width: _svgWidth,
  );

  final Widget _dashboard = SvgPicture.asset(
    'assets/icons/dashboard.svg',
    width: _svgWidth,
  );

  final Widget _roll_of_honour = SvgPicture.asset(
    'assets/icons/roll_of_honour_colored.svg',
    width: _svgWidth,
  );

  final Widget _events = SvgPicture.asset(
    "assets/icons/event_colored.svg",
    width: _svgWidth,
  );

  Widget _listTile(String title) {
    return Text(
      title,
      style: TextStyle(fontFamily: 'pop-med'),
    );
  }
}
