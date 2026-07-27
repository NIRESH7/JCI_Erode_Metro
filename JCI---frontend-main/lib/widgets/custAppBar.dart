import 'package:flutter/material.dart';
import 'package:jci/widgets/jci_logo.dart';

class CustAppBar {
  String appBarTitle;
  PreferredSizeWidget? bottom;

  CustAppBar(this.appBarTitle, {this.bottom});

  AppBar initAppBar() {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Text(
              appBarTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, fontFamily: "pop-semibold", color: Colors.black),
            ),
          ),
          SizedBox(width: 8),
          JciLogo(height: 48, alignment: Alignment.centerRight),
        ],
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleSpacing: 8,
      bottom: bottom,
    );
  }

  AppBar loadingAppBar() {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Text(
              appBarTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, fontFamily: "pop-semibold", color: Colors.black),
            ),
          ),
          SizedBox(width: 8),
          JciLogo(height: 48, alignment: Alignment.centerRight),
        ],
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }
}
