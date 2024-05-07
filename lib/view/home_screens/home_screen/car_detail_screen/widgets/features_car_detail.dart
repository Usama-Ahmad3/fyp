import 'package:flutter/material.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/view/home_screens/home_screen/car_detail_screen/car_detail_initials.dart';
import 'package:wizmo/view/home_screens/home_screen/car_detail_screen/car_detail_provider.dart';

class FeaturesCarDetail extends StatefulWidget {
  final CarDetailInitials carDetailInitials;
  const FeaturesCarDetail({super.key, required this.carDetailInitials});

  @override
  State<FeaturesCarDetail> createState() => _FeaturesCarDetailState();
}

class _FeaturesCarDetailState extends State<FeaturesCarDetail> {
  bool viewMore = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              ...List.generate(
                  viewMore ? widget.carDetailInitials.features!.length : 4,
                  (index) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025,
                            vertical: height * 0.003),
                        child: SizedBox(
                          height: height * 0.08,
                          width: width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.carDetailInitials.featureName![index]
                                    .toString(),
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              SizedBox(
                                height: height * 0.003,
                              ),
                              Container(
                                height: height * 0.05,
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                    color: AppColors.teal,
                                    borderRadius:
                                        BorderRadius.circular(height * 0.01)),
                                child: Center(
                                  child: Text(
                                    widget.carDetailInitials.features![index]
                                                .toString()
                                                .length >
                                            17
                                        ? widget
                                            .carDetailInitials.features![index]
                                            .toString()
                                            .substring(0, 17)
                                        : widget
                                            .carDetailInitials.features![index]
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(color: AppColors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          InkWell(
            onTap: () {
              viewMore = !viewMore;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.023),
              child: Text(
                viewMore ? 'View Less' : 'View More',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: AppColors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
