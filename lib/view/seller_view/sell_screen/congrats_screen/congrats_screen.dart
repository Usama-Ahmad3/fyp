import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/button_widget.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/seller_view/main_bottom_bar_seller.dart';

class CongratsScreen extends StatelessWidget {
  const CongratsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.2,
            ),
            Lottie.asset('assets/lotie_files/congrats.json',
                height: height * 0.3, width: width),
            SizedBox(
              height: height * 0.01,
            ),
            Center(
              child: Text(
                "Congratulations!",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Center(
              child: Text(
                "Your ad has been successfully added!",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: AppColors.buttonColor),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Center(
                child: Text(
                  "You can see your ad in your account.All you have to do now is wait for someone contact you.",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            ButtonWidget(
                text: 'Continue',
                onTap: () {
                  navigateToHomeScreen(context);
                })
          ],
        ),
      ),
    );
  }

  navigateToHomeScreen(context) {
    Navigation().pushRep(MainBottomBarSeller(index: 0), context);
  }
}
