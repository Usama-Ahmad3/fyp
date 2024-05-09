import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizmo/res/authentication/authentication.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/button_widget.dart';
import 'package:wizmo/utils/navigator_class.dart';
import 'package:wizmo/view/login_signup/login/login.dart';
import 'package:wizmo/view/onboarding/second.dart';

import 'first.dart';
import 'third.dart';

class MainOnBoarding extends StatefulWidget {
  const MainOnBoarding({super.key});

  @override
  State<MainOnBoarding> createState() => _MainOnBoardingState();
}

class _MainOnBoardingState extends State<MainOnBoarding> {
  PageController controller = PageController(initialPage: 0);
  int currentPageValue = 0;
  final pageList = [
    const FirstScreen(),
    const SecondScreen(),
    const ThirdScreen()
  ];
  navigateToLast(int page) {
    controller.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.bounceInOut);
    currentPageValue = page;
    setState(() {});
  }

  navigateToLogin(BuildContext context) async {
    if (currentPageValue == 2) {
      Authentication().saveWalk(true);
      // ignore: use_build_context_synchronously
      Navigation().pushRep(const LogIn(), context);
    } else {
      currentPageValue += 1;
      navigateToLast(currentPageValue);
      setState(() {});
    }
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 10,
      width: isActive ? 24 : 10,
      decoration: BoxDecoration(
          color: isActive ? AppColors.buttonColor : Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          PageView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: pageList.length,
            onPageChanged: (page) {
              currentPageValue = page;
              setState(() {});
            },
            controller: controller,
            itemBuilder: (context, index) {
              return pageList[index];
            },
          ),
          Positioned(
              bottom: 55,
              left: 135,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  currentPageValue == 0 ? circleBar(true) : circleBar(false),
                  currentPageValue == 1 ? circleBar(true) : circleBar(false),
                  currentPageValue == 2 ? circleBar(true) : circleBar(false),
                ],
              )),
          currentPageValue == 2
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.03),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () {
                          controller.animateToPage(2,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.bounceInOut);
                          currentPageValue = 2;
                          setState(() {});
                        },
                        child: Text(
                          'Skip',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: AppColors.black),
                        )),
                  )),
          Positioned(
              bottom: height * 0.14,
              child: ButtonWidget(
                  text: currentPageValue == 2 ? "Let's Start" : 'Next',
                  onTap: () {
                    if (currentPageValue == 2) {
                      Authentication().saveWalk(true);
                      // ignore: use_build_context_synchronously
                      Navigation().pushRep(const LogIn(), context);
                    } else {
                      currentPageValue += 1;
                      controller.animateToPage(currentPageValue,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceInOut);
                      currentPageValue = currentPageValue;
                      setState(() {});
                    }
                  }))
        ],
      ),
    );
  }
}
