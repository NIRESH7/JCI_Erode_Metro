import 'package:flutter/material.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/titles.dart';

class RollOfHonour extends StatelessWidget {
  final _count = (DateTime.now().year - 1985) + 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(Titles.roh).initAppBar(),
      body: SafeArea(
        child: Responsive.body(
          context,
          Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.horizontalPadding(context),
            0,
            Responsive.horizontalPadding(context),
            20,
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (ctx, idx) {
              return _gridCard(ctx, DateTime.now().year - idx);
            },
            itemCount: _count,
          ),
        ),
        ),
      ),
    );
  }

  _gridCard(BuildContext context, var year) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/roh_details', arguments: [year]);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xff1A000000),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0xffffffff),
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ]),
        child: Center(
          child: Text(
            "$year",
            style: TextStyle(
              fontFamily: 'pop-med',
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
