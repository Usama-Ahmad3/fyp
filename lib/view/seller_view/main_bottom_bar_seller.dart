import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/popup.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/view/home_screens/account_screen/account_screen.dart';
import 'package:maintenance/view/seller_view/home.dart';

import 'sell_screen/sell_screen/sell_screen.dart';

// ignore: must_be_immutable
class MainBottomBarSeller extends StatefulWidget {
  int index;
  final String status;
  MainBottomBarSeller({
    super.key,
    this.index = 0,
    this.status = "active",
  });

  @override
  State<MainBottomBarSeller> createState() => _MainBottomBarSellerState();
}

class _MainBottomBarSellerState extends State<MainBottomBarSeller> {
  popupDialog(
      {required BuildContext context,
      required String text,
      required String buttonText}) {
    popup(
        context: context,
        text: text,
        onTap: () {
          exit(1);
        },
        buttonText: buttonText);
  }

  @override
  void initState() {
    _initialIndex = widget.index;
    super.initState();
  }

  int _initialIndex = 0;
  final page = [
    const Home(
      status: '',
    ),
    const AddService(),
    const AccountScreen(),
  ];
  pageChange(int index) {
    if (widget.status == 'active') {
      _initialIndex = index;
      widget.index = index;
      setState(() {});
    } else {
      if (index == 1) {
        FlushBarUtils.flushBar(
            "Your Account Status is ${widget.status}", context, "Information");
      } else {
        _initialIndex = index;
        widget.index = index;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return popupDialog(
            buttonText: 'Yes', text: "You're going to exit", context: context);
      },
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
          curve: Curves.bounceInOut,
          disableDefaultTabController: false,
          items: const [
            TabItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              title: 'Home',
            ),
            TabItem(
                icon: Icons.sell_outlined,
                title: 'Add Service',
                activeIcon: Icons.sell),
            TabItem(
                icon: Icons.account_circle_outlined,
                title: 'Account',
                activeIcon: Icons.account_circle)
          ],
          backgroundColor: AppColors.buttonColor,
          style: TabStyle.react,
          initialActiveIndex: _initialIndex,
          onTap: (index) {
            pageChange(index);
          },
        ),
        body: _initialIndex == 0
            ? Home(
                status: widget.status,
              )
            : page[_initialIndex],
      ),
    );
  }
}
