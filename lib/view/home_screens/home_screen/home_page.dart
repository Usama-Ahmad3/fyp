import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/empty_screen.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/images.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/home_screen/home_widgets/category_container.dart';
import 'package:maintenance/view/home_screens/home_screen/specific_category_services/specific_category_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<QuerySnapshot> fetchDataFromFirebase() async {
    return FirebaseFirestore.instance.collection('categories').get();
  }

  final List<String> carouselImageList = [
    AppImages.image0,
    AppImages.image1,
    AppImages.image2,
    AppImages.image3,
    AppImages.image4,
    AppImages.image5,
    AppImages.image6,
    AppImages.image7,
  ];
  Future<QuerySnapshot> serviceProviders(String categoryId) async {
    return FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .collection('services')
        .get();
  }

  static bool loading = false;
  @override
  void initState() {
    print('In The Home Screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    fetchDataFromFirebase();
    return RefreshIndicator(
        displacement: 200,
        onRefresh: () async {
          loading = true;
          Future.delayed(const Duration(seconds: 2), () {
            loading = false;
            setState(() {});
          });
        },
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.03,
                      ),
                      SafeArea(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: height * 0.2,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                          items: carouselImageList
                              .map((item) => ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Center(
                                      child: Image.asset(
                                        item,
                                        fit: BoxFit.cover,
                                        width: 1000,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04, vertical: height * 0.008),
                        child: Text(
                          'Categories',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.black),
                        ),
                      ),
                      FutureBuilder(
                        future: fetchDataFromFirebase(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.only(top: height * 0.02),
                                child: EmptyScreen(
                                    text: 'No Data Found', text2: ''),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: height * 0.4,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.buttonColor)),
                              );
                            } else {
                              return Column(
                                children: [
                                  ...List.generate(snapshot.data!.docs.length,
                                      (index) {
                                    var document = snapshot.data!.docs[index];
                                    return FutureBuilder(
                                      future: serviceProviders(document['id']),
                                      builder: (context, service) {
                                        if (service.connectionState ==
                                            ConnectionState.waiting) {
                                          return CategoryContainer(
                                            image: document['images'],
                                            category: document['name'],
                                            services: '',
                                            onTap: () {
                                              try {
                                                if (service
                                                    .data!.docs.isNotEmpty) {
                                                  Navigation().push(
                                                      SpecificCategoryServices(
                                                          id: document['id']),
                                                      context);
                                                } else {
                                                  FlushBarUtils.flushBar(
                                                      "No Service Found",
                                                      context,
                                                      "Message");
                                                }
                                              } catch (e) {
                                                FlushBarUtils.flushBar(
                                                    "No Service Found",
                                                    context,
                                                    "Message");
                                              }
                                            },
                                          );
                                        }
                                        if (service.hasData) {
                                          return CategoryContainer(
                                            image: document['images'],
                                            category: document['name'],
                                            services: service.data!.docs.isEmpty
                                                ? "Nothing Found"
                                                : service.data!.docs.length
                                                    .toString(),
                                            onTap: () {
                                              try {
                                                if (service
                                                    .data!.docs.isNotEmpty) {
                                                  Navigation().push(
                                                      SpecificCategoryServices(
                                                          id: document['id']),
                                                      context);
                                                } else {
                                                  FlushBarUtils.flushBar(
                                                      "No Service Found",
                                                      context,
                                                      "Message");
                                                }
                                              } catch (e) {
                                                FlushBarUtils.flushBar(
                                                    "No Service Found",
                                                    context,
                                                    "Message");
                                              }
                                            },
                                          );
                                        } else {
                                          return CategoryContainer(
                                            image: document['images'],
                                            category: document['name'],
                                            services: 'Nothing Found',
                                            onTap: () {
                                              try {
                                                if (service
                                                    .data!.docs.isNotEmpty) {
                                                  Navigation().push(
                                                      SpecificCategoryServices(
                                                          id: document['id']),
                                                      context);
                                                } else {
                                                  FlushBarUtils.flushBar(
                                                      "No Service Found",
                                                      context,
                                                      "Message");
                                                }
                                              } catch (e) {
                                                FlushBarUtils.flushBar(
                                                    "No Service Found",
                                                    context,
                                                    "Message");
                                              }
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }),
                                ],
                              );
                            }
                          } else {
                            return SizedBox(
                              height: height * 0.4,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.buttonColor,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ));
  }
}
