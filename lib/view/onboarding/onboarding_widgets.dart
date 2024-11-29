import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';

Widget ImageWidget(double height, String image) {
  return SizedBox(
      height: height * 0.4,
      child: Image.network(
        image,
        fit: BoxFit.fill,
      ));
}

Widget TextWidget(BuildContext context, double height, double width,
    String title, String subtitle1, String subtitle2, String text1) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: AppColors.black),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.01, horizontal: width * 0.1),
        child: Text(
          subtitle1,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: AppColors.blue),
        ),
      ),
      subtitle2 != ''
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Text(
                subtitle2,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: AppColors.blue),
              ),
            )
          : const SizedBox.shrink(),
      SizedBox(
        height: height * 0.03,
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.07,
        ),
        child: Text(
          text1,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: AppColors.black, fontSize: height * 0.018),
        ),
      ),
    ],
  );
}
