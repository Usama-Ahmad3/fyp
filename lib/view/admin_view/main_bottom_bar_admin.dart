import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/popup.dart';
import 'package:maintenance/view/admin_view/account_screen_admin.dart';
import 'package:maintenance/view/admin_view/admin_home.dart';
import 'package:maintenance/view/admin_view/all_users/all_users.dart';

// ignore: must_be_immutable
class MainBottomBarAdmin extends StatefulWidget {
  int index;
  MainBottomBarAdmin({
    super.key,
    this.index = 0,
  });

  @override
  State<MainBottomBarAdmin> createState() => _MainBottomBarAdminState();
}

class _MainBottomBarAdminState extends State<MainBottomBarAdmin> {
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
    const AdminHome(),
    const AllUsers(),
    const AccountScreenAdmin(),
  ];
  pageChange(int index) {
    _initialIndex = index;
    widget.index = index;
    setState(() {});
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
              icon: Icons.request_page,
              activeIcon: Icons.home,
              title: 'Requests',
            ),
            TabItem(
                icon: Icons.person,
                title: 'All Users',
                activeIcon: Icons.person_2_outlined),
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
        body: page[_initialIndex],
      ),
    );
  }
}
