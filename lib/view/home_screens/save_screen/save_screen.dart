import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/models/dynamic_car_detail_model.dart';
import 'package:maintenance/res/authentication/authentication.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/cashed_image.dart';
import 'package:maintenance/res/common_widgets/empty_screen.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/account_screen/empty.dart';
import 'package:maintenance/view/home_screens/home_screen/specific_category_services/car_detail_screen/car_detail_initials.dart';
import 'package:maintenance/view/login_signup/login/login.dart';
import 'package:maintenance/view/login_signup/signup/signup.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  bool loading = false;
  bool isLogIn = false;
  final nextPageController = CarouselSliderController();
  int _initialPage = 0;
  checkAuth() async {
    isLogIn = await Authentication().getAuth();
    loading = false;
    setState(() {});
  }

  Future<List<QueryDocumentSnapshot<Object?>>> fetchDataFromFirebase() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cars')
        .where('isSaved', isEqualTo: true)
        .get();
    return querySnapshot.docs;
  }

  @override
  void initState() {
    print('In the Save Screen');
    checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
              appBar: AppBar(
                title: Text(
                  'Saved',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.black),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: isLogIn
                  ? FutureBuilder(
                      future: fetchDataFromFirebase(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return EmptyScreen(
                              text: 'Nothing found in saved cars',
                              text2: 'First go and save your favorite cars');
                        } else {
                          print(snapshot.data!);
                          final carData = snapshot.data!
                              .map<Map<String, dynamic>>(
                                  (doc) => doc.data()! as Map<String, dynamic>)
                              .toList();
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ...List.generate(carData.length, (car) {
                                  final document = carData[car];
                                  print("Document $document");
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.012),
                                    child: Container(
                                      height: height * 0.3,
                                      width: width,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.01),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColors.shadowColor
                                                    .withOpacity(0.17),
                                                blurStyle: BlurStyle.normal,
                                                offset: const Offset(1, 1),
                                                blurRadius: 12,
                                                spreadRadius: 2)
                                          ],
                                          color: AppColors.white),
                                      child: Stack(
                                        children: [
                                          CarouselSlider.builder(
                                              itemCount:
                                                  document['images'].length,
                                              itemBuilder:
                                                  (context, index, realIndex) {
                                                return InkWell(
                                                  onTap: () {
                                                    DynamicCarDetailModel
                                                        imageDetail =
                                                        DynamicCarDetailModel(
                                                            model: document[
                                                                'model'],
                                                            images: document[
                                                                'images'],
                                                            name: document[
                                                                'model'],
                                                            description: document[
                                                                'Description'],
                                                            location: document[
                                                                'Location'],
                                                            sellerType: document[
                                                                'Seller Type'],
                                                            longitude: document[
                                                                'longitude'],
                                                            latitude: document[
                                                                'latitude'],
                                                            email: document[
                                                                'email'],
                                                            number: document[
                                                                'phone_number'],
                                                            sellerName:
                                                                document[
                                                                    'name'],
                                                            addCarId:
                                                                document['id'],
                                                            price: document[
                                                                'Price']);
                                                    var detail =
                                                        CarDetailInitials(
                                                            carDetails:
                                                                imageDetail,
                                                            featureName:
                                                                document[
                                                                    'features'],
                                                            features: document[
                                                                'feature_values'],
                                                            onTap: () {});
                                                    navigateToCarDetail(
                                                        detail, context);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: height * 0.23,
                                                        width: width,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      height *
                                                                          0.01),
                                                          child: cachedNetworkImage(
                                                              height:
                                                                  height * 0.23,
                                                              width: width,
                                                              cuisineImageUrl:
                                                                  document[
                                                                          'images']
                                                                      [index],
                                                              imageFit:
                                                                  BoxFit.fill,
                                                              errorFit:
                                                                  BoxFit.fill),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              carouselController:
                                                  nextPageController,
                                              options: CarouselOptions(
                                                  autoPlay: true,
                                                  autoPlayCurve:
                                                      Curves.easeInOut,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    _initialPage = index;
                                                    setState(() {});
                                                  },
                                                  height: height,
                                                  viewportFraction: 1,
                                                  animateToClosest: true,
                                                  initialPage: _initialPage,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  scrollPhysics:
                                                      const AlwaysScrollableScrollPhysics())),
                                          Positioned(
                                            bottom: height * 0.02,
                                            left: height * 0.009,
                                            right: height * 0.009,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  document['model'].length > 10
                                                      ? document['model']
                                                          .substring(0, 10)
                                                      : document['model'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(
                                                  '${document['Price']} \$',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color: AppColors.red),
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          height * 0.008),
                                                  color: AppColors.grey
                                                      .withOpacity(0.65),
                                                  shape: BoxShape.rectangle),
                                              child: Center(
                                                  child: Text(
                                                document['model'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: AppColors.white),
                                              )),
                                            ),
                                          ),
                                          Positioned(
                                              right: width * 0.02,
                                              top: height * 0.009,
                                              child: CircleAvatar(
                                                backgroundColor: AppColors.grey
                                                    .withOpacity(0.65),
                                                radius: height * 0.021,
                                                child: InkWell(
                                                  onTap: () async {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('cars')
                                                          .doc(document['id'])
                                                          .update({
                                                        "isSaved": false
                                                      }).then((value) {
                                                        setState(() {
                                                          print("djjdjdj");
                                                        });
                                                      });
                                                    } catch (e) {
                                                      print(
                                                          "djjdjdj ==> Error $e");
                                                    }
                                                  },
                                                  child: Icon(
                                                    document['isSaved']
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: document['isSaved']
                                                        ? AppColors.blue
                                                        : AppColors.white,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  : Empty(
                      login: () {
                        navigateToLogin();
                      },
                      signup: () {
                        navigateToSignup();
                      },
                    ),
            ),
    );
  }

  navigateToSignup() {
    Navigation().push(const SignUp(), context);
  }

  navigateToLogin() {
    Navigation().push(const LogIn(), context);
  }

  navigateToCarDetail(var carDetailInitials, context) {
    // Navigation()
    //     .push(CarDetailScreen(carDetailInitials: carDetailInitials), context);
  }
}
