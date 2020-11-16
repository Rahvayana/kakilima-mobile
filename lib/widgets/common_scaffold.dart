import 'package:aplikasi_pertama/widgets/custom_float.dart';
import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final appTitle;
  final Widget bodyData;
  final showFAB;
  final showDrawer;
  final backGroundColor;
  final actionFirstIcon;
  final scaffoldKey;
  final showBottomNav;
  final floatingIcon;
  final centerDocked;
  final elevation;

  CommonScaffold(
      {this.appTitle,
      this.bodyData,
      this.showFAB = false,
      this.showDrawer = false,
      this.backGroundColor,
      this.actionFirstIcon = Icons.search,
      this.scaffoldKey,
      this.showBottomNav = false,
      this.centerDocked = false,
      this.floatingIcon,
      this.elevation = 4.0});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey != null ? scaffoldKey : null,
        backgroundColor: backGroundColor != null ? backGroundColor : null,
        body: bodyData,
        floatingActionButton: showFAB
            ? CustomFloat(
                builder: centerDocked
                    ? Text(
                        "5",
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      )
                    : null,
                icon: floatingIcon,
                qrCallback: () {},
              )
            : null,
        floatingActionButtonLocation: centerDocked
            ? FloatingActionButtonLocation.centerDocked
            : FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
