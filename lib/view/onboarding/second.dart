import 'package:flutter/material.dart';
import 'package:maintenance/res/common_widgets/cashed_image.dart';
import 'package:maintenance/view/onboarding/onboarding_widgets.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            cachedNetworkImage(
                cuisineImageUrl:
                    'https://c7.alamy.com/comp/2PFW668/sign-displaying-buy-sell-word-for-the-buying-and-selling-of-goods-and-services-trading-merchandising-2PFW668.jpg',
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
              'Buy and Sell Services' /*title*/,
              "You don't have to be an expert to earn or save money by connecting with the right service" /*subtitle1*/,
              '' /*subtitle2*/,
              'Offering Services at Their Maximum Value!' /*text1*/,
            )
          ],
        ),
      ),
    );
  }
}
