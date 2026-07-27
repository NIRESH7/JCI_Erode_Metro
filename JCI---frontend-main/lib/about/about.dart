import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:get/get.dart';

class About extends StatelessWidget {
  final controller = Get.put(SponsorController());

  static const _titleStyle = TextStyle(
    fontFamily: 'pop-bold',
    fontSize: 18,
    color: Color(0xFF111827),
  );

  static final _bodyStyle = TextStyle(
    fontFamily: 'pop-reg',
    fontSize: 14,
    height: 1.55,
    color: Colors.grey.shade800,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(Titles.about).initAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/images/about_img.svg",
              width: MediaQuery.of(context).size.width,
            ),
            _space(12),
            const Text("About JCI", style: _titleStyle),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Text(
                "Junior Chamber International (JCI) is a worldwide federation of young leaders and entrepreneurs with nearly five lakh active members and millions of alumni spread across more than 115 countries. Each JCI member shares the belief that in order to create lasting positive change, we must improve ourselves and the world around us. JCI offers meetings, dynamic training sessions and projects that provide opportunities to learn, achieve and inspire active citizenship, while building their experience as leaders. The origin of Junior Chamber International (JCI) can be traced as far as almost a century ago in 1915 to the city of St. Louis, Missouri, USA, where a young man named Henry Giessenbier together with 32 other young men, established the Young Men's Progressive Civic Association (YMPCA), JCI's first local organization. YMPCA grew to a membership of 750 in less than five months. The association went on to dedicate itself to bringing about civic improvements and giving young people a constructive approach to civic problems.",
                style: _bodyStyle,
                textAlign: TextAlign.justify,
              ),
            ),
            const Text("JCI Mission", style: _titleStyle),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text(
                "To provide development opportunities that empower young people to create positive change.",
                style: _bodyStyle.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const Text("JCI Vision", style: _titleStyle),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(
                "To be the leading global network of young active citizens",
                style: _bodyStyle.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            _space(20),
            Visibility(
                visible: controller.getMainSponsorVisiblity(),
                child: SponsorData.sponserTitle("${JciString.powered_by}")),
            _space(10),
            SponsorData.mainSponsor(context),
            _space(20)
          ],
        ),
      ),
    );
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }
}
