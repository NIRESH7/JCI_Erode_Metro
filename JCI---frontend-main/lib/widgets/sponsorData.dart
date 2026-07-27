import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/services/sponser_service.dart';
import 'package:jci/widgets/common.dart';

class SponsorData {
  static var visibleController = Get.put(SponsorController());

  static Widget sponserTitle(String title) {
    return Text(
      "$title",
      style: TextStyle(
        color: Utils.darkBlue,
        fontFamily: "pop-med",
        fontSize: 20,
      ),
    );
  }

  static Widget otherSponsor(BuildContext context) {
    return FutureBuilder(
        future: SponsorService.getOurSponserData(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError || snapshot.data.length == 0) {
            visibleController.setVisible(false);
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffffffff),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "",
                style: TextStyle(fontSize: 14, fontFamily: "pop-med"),
              ),
            );
          } else {
            visibleController.setVisible(true);
            return CarouselSlider.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                  GestureDetector(
                onTap: () {
                  _viewButton('our_sponser', '${snapshot.data[itemIndex].id}');
                },
                child: Container(
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    '${snapshot.data[itemIndex].logo}',
                    // height: 40,
                    // width: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, obj, err) {
                      return ImageNotFound();
                    },
                  ),
                ),
              ),
              options: CarouselOptions(
                height: 180,
                initialPage: 0,
                autoPlay: true,
              ),
            );
          }
        });
  }

  static Widget mainSponsor(BuildContext context) {
    return FutureBuilder(
        future: SponsorService.getSponserData(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null && snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError ||
              (snapshot.data == null && snapshot.connectionState == ConnectionState.done) ||
              snapshot.data.length == 0) {
            visibleController.setMainSponsorVisible(false);
            return SizedBox(
                // margin: EdgeInsets.all(10),
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     color: Colors.transparent,
                //     width: 1,
                //   ),
                //   borderRadius: BorderRadius.circular(10),
                // ),
                // child: Text(
                //   "",
                //   style: TextStyle(fontSize: 14, fontFamily: "pop-med"),
                // ),
                );
          } else {
            visibleController.setMainSponsorVisible(true);

            return CarouselSlider.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () => {
                    _viewButton('main_sponser', '${snapshot.data[index].id}'),
                  },
                  child: Container(
                    width: 150,
                    height: 75,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      '${snapshot.data[index].logo}',
                      errorBuilder: (_, obj, err) {
                        return ImageNotFound();
                      },
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 150,
                initialPage: 0,
                autoPlay: true,
              ),
            );
          }
        });
  }
}

Widget _space(double h) {
  return SizedBox(height: h);
}

_viewButton(var sponser, var id) {
  Get.toNamed('/sponsor', arguments: [sponser, id]);
}
