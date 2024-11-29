import 'package:flutter/material.dart';
import 'package:maintenance/res/common_widgets/cashed_image.dart';
import 'package:maintenance/view/onboarding/onboarding_widgets.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.1,
          ),
          cachedNetworkImage(
              cuisineImageUrl:
                  'https://cdn.pixabay.com/photo/2014/09/20/09/23/bargain-453490_1280.png',
              height: height * 0.4,
              imageFit: BoxFit.fill,
              errorFit: BoxFit.contain,
              width: width),
          SizedBox(
            height: height * 0.04,
          ),
          TextWidget(
            context,
            height,
            width,
            'Bargain like a shark' /*title*/,
            "Sell your Services! it's easy and free" /*subtitle1*/,
            '' /*subtitle2*/,
            'Stay Safe When Buying Services Online: Learn How to Protect Yourself and Explore Current Offers!' /*text1*/,
          )
        ],
      ),
    );
  }
}
