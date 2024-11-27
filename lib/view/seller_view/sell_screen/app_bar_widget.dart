import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';

class AppBarWidget extends StatelessWidget {
  final Size size;
  final String title;
  final Color color1;
  final bool canBack;
  const AppBarWidget(
      {super.key,
      required this.size,
      this.canBack = false,
      required this.color1,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: canBack,
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.black),
        ),
        bottom: PreferredSize(
          preferredSize: Size(size.width * 0.9, size.height * 0.005),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.05,
              ),
              Container(
                height: size.height * 0.005,
                width: size.width * 0.2,
                color: AppColors.buttonColor,
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              Container(
                height: size.height * 0.005,
                width: size.width * 0.2,
                color: color1,
              ),
            ],
          ),
        ));
  }
}
