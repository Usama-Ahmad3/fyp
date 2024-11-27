import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/empty_screen.dart';
import 'package:maintenance/utils/images.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/home_screen/home_widgets/category_container.dart';
import 'package:maintenance/view/seller_view/sell_screen/sell_screen/sell_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<QuerySnapshot> fetchDataFromFirebase() async {
    return FirebaseFirestore.instance.collection('categories').get();
  }

  Future<List<Map<String, dynamic>>> getServicesByUserId(String userId) async {
    try {
      final categorySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      List<Map<String, dynamic>> matchingServices = [];
      for (var categoryDoc in categorySnapshot.docs) {
        final servicesQuery = await categoryDoc.reference
            .collection('services')
            .where('user_id', isEqualTo: userId)
            .get();

        for (var serviceDoc in servicesQuery.docs) {
          matchingServices.add(serviceDoc.data());
        }
      }

      return matchingServices;
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
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
                          'My Services',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.black),
                        ),
                      ),
                      FutureBuilder(
                        future: getServicesByUserId(
                            FirebaseAuth.instance.currentUser!.uid),
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
                                  ...List.generate(snapshot.data!.length,
                                      (index) {
                                    var data = snapshot.data![index];
                                    DateTime dateTime =
                                        data['created_at'].toDate();
                                    final time = DateFormat(
                                            'dd MMMM yyyy \'at\' hh:mm a')
                                        .format(
                                      DateTime(
                                          dateTime.year,
                                          dateTime.month,
                                          dateTime.day,
                                          dateTime.hour,
                                          dateTime.minute,
                                          dateTime.second),
                                    );
                                    return CategoryContainer(
                                      image: data['images'],
                                      category: time,
                                      isCompany: true,
                                      services: data['company_name'],
                                      onTap: () {
                                        Navigation().push(
                                            AddService(
                                              details: data,
                                            ),
                                            context);
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
