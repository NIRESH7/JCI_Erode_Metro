import 'package:flutter/material.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/services/roh_service.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';

class RohDetails extends StatefulWidget {
  @override
  _RohDetailsState createState() => _RohDetailsState();
}

class _RohDetailsState extends State<RohDetails> {
  var _getYear = Get.arguments;

  var controller = Get.put(SponsorController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustAppBar(Titles.roh).initAppBar(),
        body: FutureBuilder(
            future: RohService.getROHData(_getYear[0]),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.data == null &&
                  snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Lottie.asset("assets/lottie/no_data.json"),
                );
              } else {
                if (snapshot.data.length == 0) {
                  return Center(
                    child: Lottie.asset("assets/lottie/no_data.json"),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, idx) {
                      if (idx == snapshot.data.length - 1) {
                        return Column(
                          children: [
                            _rohCard(
                                snapshot.data[idx].img,
                                snapshot.data[idx].name,
                                snapshot.data[idx].role),
                            _space(20),
                            Visibility(
                                visible: controller.getMainSponsorVisiblity(),
                                child: SponsorData.sponserTitle(
                                    "${JciString.powered_by}")),
                            _space(10),
                            Visibility(
                                visible: controller.getMainSponsorVisiblity(),
                                child: SponsorData.mainSponsor(context)),
                            // _space(10),
                            // Visibility(
                            //   visible: controller.getVisible(),
                            //   child: SponsorData.sponserTitle(
                            //       '${JciString.co_powered_by}'),
                            // ),
                            // SponsorData.otherSponsor(context),
                            _space(20)
                          ],
                        );
                      } else {
                        return _rohCard(snapshot.data[idx].img,
                            snapshot.data[idx].name, snapshot.data[idx].role);
                      }
                    });
              }
            }));
  }

  _rohCard(String img, String name, String role) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(img),
          ),
          SizedBox(height: 10),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "pop-semibold",
              fontSize: 18,
            ),
          ),
          Text(
            role,
            style: TextStyle(
              fontFamily: "pop-semibold",
              fontSize: 16,
              color: Color(0xff23346B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }
}
