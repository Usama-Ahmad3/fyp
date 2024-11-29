import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';

class CategoryContainer extends StatefulWidget {
  final List image;
  final String services;
  final String category;
  final bool isCompany;
  final VoidCallback onTap;
  const CategoryContainer(
      {super.key,
      required this.image,
      required this.services,
      this.isCompany = false,
      required this.onTap,
      required this.category});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
  final nextPageController = CarouselSliderController();
  int _initialPage = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: height * 0.012),
      child: Container(
        height: height * 0.3,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.01),
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.17),
                  blurStyle: BlurStyle.normal,
                  offset: const Offset(1, 1),
                  blurRadius: 12,
                  spreadRadius: 2)
            ],
            color: AppColors.white),
        child: Stack(
          children: [
            CarouselSlider.builder(
                itemCount: widget.image.length,
                itemBuilder: (context, index, realIndex) {
                  return InkWell(
                    onTap: widget.onTap,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.23,
                          width: width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(height * 0.01),
                            child: Image.network(
                              widget.image[index],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                carouselController: nextPageController,
                options: CarouselOptions(
                    autoPlay: true,
                    autoPlayCurve: Curves.easeInOut,
                    onPageChanged: (index, reason) {
                      _initialPage = index;
                      setState(() {});
                    },
                    height: height,
                    viewportFraction: 1,
                    animateToClosest: true,
                    initialPage: _initialPage,
                    scrollDirection: Axis.horizontal,
                    scrollPhysics: const AlwaysScrollableScrollPhysics())),
            Positioned(
              bottom: height * 0.02,
              left: height * 0.009,
              right: height * 0.009,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isCompany ? "Company Name" : "Service Providers",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.services.isEmpty ? "Not Specified" : widget.services,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.red),
                  ),
                ],
              ),
            ),
            Positioned(
              top: height * 0.01,
              left: width * 0.01,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 0.008),
                    color: AppColors.grey.withOpacity(0.65),
                    shape: BoxShape.rectangle),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    widget.category.length > 35
                        ? widget.category.substring(0, 35)
                        : widget.category,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: AppColors.white),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget TextWidget(
  String text,
  BuildContext context,
  double width,
) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
    child: Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
    ),
  );
}
