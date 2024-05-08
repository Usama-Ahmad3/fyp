import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wizmo/main.dart';
import 'package:wizmo/models/dynamic_car_detail_model.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/empty_screen.dart';
import 'package:wizmo/utils/navigator_class.dart';
import 'package:wizmo/view/home_screens/home_screen/car_detail_screen/car_detail_initials.dart';
import 'package:wizmo/view/home_screens/home_screen/home_widgets/car_container.dart';
import 'car_detail_screen/car_detail_screen.dart';
import 'home_widgets/top_searchbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<QuerySnapshot> fetchDataFromFirebase() async {
    return FirebaseFirestore.instance.collection('cars').get();
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
                      SafeArea(child: Image.asset('assets/images/wizmo.jpg')),
                      const TopSearchBar(),
                      FutureBuilder(
                        future: fetchDataFromFirebase(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.only(top: height * 0.02),
                                child: EmptyScreen(
                                    text: 'No cars found',
                                    text2:
                                        'Go to sell tab and add your first car'),
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
                                    return CarContainer(
                                      addCarId: document['id'],
                                      image: document['images'],
                                      price: document['Price'],
                                      name: document['model'],
                                      model: document['model'],
                                      onTap: () {
                                        DynamicCarDetailModel imageDetail =
                                            DynamicCarDetailModel(
                                                model: document['model'],
                                                images: document['images'],
                                                name: document['name'],
                                                saved: document['isSaved'],
                                                description:
                                                    document['Description'],
                                                location: document["Location"],
                                                sellerType:
                                                    document['Seller Type'],
                                                addCarId: document['id'],
                                                longitude:
                                                    document["longitude"],
                                                latitude: document["latitude"],
                                                email: document['email'],
                                                number:
                                                    document['phone_number'],
                                                sellerName: document['name'],
                                                price: document['Price']);
                                        var detail = CarDetailInitials(
                                            carDetails: imageDetail,
                                            featureName: document['features'],
                                            features:
                                                document['feature_values'],
                                            onTap: () {});
                                        Navigation().push(
                                            CarDetailScreen(
                                                carDetailInitials: detail),
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
