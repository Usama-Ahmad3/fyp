import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wizmo/main.dart';
import 'package:wizmo/res/common_widgets/popup.dart';
import 'package:wizmo/view/home_screens/account_screen/account_screen.dart';
import 'package:wizmo/view/home_screens/home_screen/home_page.dart';
import 'package:wizmo/view/home_screens/save_screen/save_screen.dart';
import 'package:wizmo/view/home_screens/search_screen/search_screen.dart';
import 'package:wizmo/view/home_screens/sell_screen/sell_screen/sell_screen.dart';

class MainBottomBarProvider extends ChangeNotifier {
  MainBottomBarProvider({Key? key});
  final page = [
    const HomePage(),
    const SearchScreen(),
    SellScreen(
      provider: getIt(),
    ),
    const SaveScreen(),
    const AccountScreen(),
  ];
  int _initialIndex = 0;
  int get initialIndex => _initialIndex;
  pageChange(int index) {
    _initialIndex = index;
    notifyListeners();
  }

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
}
