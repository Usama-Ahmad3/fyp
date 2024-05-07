import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wizmo/res/colors/app_colors.dart';

class CarContainer extends StatefulWidget {
  final List image;
  final String price;
  final String model;
  final String name;
  final String addCarId;
  final VoidCallback onTap;
  const CarContainer(
      {super.key,
      required this.image,
      required this.price,
      required this.addCarId,
      required this.name,
      required this.onTap,
      required this.model});

  @override
  State<CarContainer> createState() => _CarContainerState();
}

class _CarContainerState extends State<CarContainer> {
  final nextPageController = CarouselController();
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
                    widget.name.length > 10
                        ? widget.name.substring(0, 10)
                        : widget.name,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.price} \$',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: AppColors.red),
                  ),
                ],
              ),
            ),
            Positioned(
              top: height * 0.01,
              left: width * 0.03,
              child: Container(
                height: height * 0.03,
                width: width * 0.17,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 0.008),
                    color: AppColors.grey.withOpacity(0.65),
                    shape: BoxShape.rectangle),
                child: Center(
                    child: Text(
                  widget.model,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: AppColors.white),
                )),
              ),
            ),
            Positioned(
                right: width * 0.02,
                top: height * 0.009,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cars')
                      .doc(widget.addCarId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(
                          child: Text('Document does not exist'));
                    } else {
                      var car = snapshot.data!.data()! as Map<String, dynamic>;
                      return CircleAvatar(
                        backgroundColor: AppColors.grey.withOpacity(0.65),
                        radius: height * 0.021,
                        child: InkWell(
                          onTap: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('cars')
                                  .doc(widget.addCarId)
                                  .update({"isSaved": !car['isSaved']}).then(
                                      (value) {
                                setState(() {
                                  print("djjdjdj");
                                });
                              });
                            } catch (e) {
                              print("djjdjdj ==> Error $e");
                            }
                          },
                          child: Icon(
                            car['isSaved'] ? Icons.star : Icons.star_border,
                            color: car['isSaved']
                                ? AppColors.blue
                                : AppColors.white,
                          ),
                        ),
                      );
                    }
                  },
                )),
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
          .headline4!
          .copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
    ),
  );
}
