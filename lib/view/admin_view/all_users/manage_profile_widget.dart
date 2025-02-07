import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/cashed_image.dart';

class ManageProfileWidget extends StatelessWidget {
  final String name;
  final String location;
  final String image;
  final File? pickedImage;
  const ManageProfileWidget(
      {super.key,
      required this.name,
      this.pickedImage,
      required this.image,
      required this.location});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Stack(
        children: [
          ///Sized box that appears(actually invisible) on the bottom of every widget of profile section
          SizedBox(height: height * 0.3, width: width),

          ///Container that appears(actually appears) on top of bottom which have names and half profile pic section
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: height * 0.2,
              width: width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(height * 0.01),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.17),
                      blurStyle: BlurStyle.normal,
                      offset: const Offset(1, 1),
                      blurRadius: 12,
                      spreadRadius: 2)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    location,
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ),
            ),
          ),

          ///Container in which the profile pic shows
          Positioned(
            top: height * 0.02,
            left: width * 0.3,
            child: Container(
              height: height * 0.15,
              width: width * 0.33,
              decoration: BoxDecoration(
                  color: AppColors.deepPurple, shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height * 0.55),
                child: pickedImage != null
                    ? Image.file(pickedImage!, fit: BoxFit.cover)
                    : cachedNetworkImage(
                        imageFit: BoxFit.fill, cuisineImageUrl: image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
