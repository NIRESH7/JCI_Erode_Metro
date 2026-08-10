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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustAppBar(
        Titles.roh,
        showBack: true,
        onBack: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else if (Get.key.currentState?.canPop() ?? false) {
            Get.back();
          } else {
            Get.offAllNamed('/home');
          }
        },
      ).initAppBar(),
      body: SafeArea(
        child: Responsive.body(
          context,
          Padding(
            padding: EdgeInsets.fromLTRB(
              Responsive.horizontalPadding(context),
              8,
              Responsive.horizontalPadding(context),
              20,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (ctx, idx) {
                return _gridCard(DateTime.now().year - idx);
              },
              itemCount: _count,
            ),
          ),
        ),
      ),
    );
  }

  Widget _gridCard(int year) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed('/roh_details', arguments: [year]),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8EEF4)),
          ),
          child: Center(
            child: Text(
              '$year',
              style: const TextStyle(
                fontFamily: 'pop-semibold',
                fontSize: 17,
                color: Color(0xFF23346B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
