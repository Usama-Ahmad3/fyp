import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizmo/main.dart';
import 'package:wizmo/models/dynamic_car_detail_model.dart';
import 'package:wizmo/res/app_urls/app_urls.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/empty_screen.dart';
import 'package:wizmo/utils/navigator_class.dart';
import 'package:wizmo/view/home_screens/Favourites_Screens/favourites_provider.dart';
import 'package:wizmo/view/home_screens/home_screen/car_detail_screen/car_detail_initials.dart';
import 'package:wizmo/view/home_screens/home_screen/home_provider.dart';
import 'package:wizmo/view/home_screens/home_screen/home_widgets/car_container.dart';
import 'package:wizmo/view/login_signup/widgets/constants.dart';
import 'car_detail_screen/car_detail_screen.dart';
import 'home_initial_params.dart';
import 'home_widgets/top_searchbar.dart';

class HomePage extends StatefulWidget {
  final HomeInitialParams initialParams;
  const HomePage({super.key, required this.initialParams});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<QuerySnapshot> fetchDataFromFirebase() async {
    return FirebaseFirestore.instance.collection('cars').get();
  }

  HomeProvider get homeProvider => widget.initialParams.provider;
  bool _loading = false;
  @override
  void initState() {
    print('In The Home Screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<CarFavouritesProvider>(context, listen: false);
    provider.favouriteCarsGet(
        context: context, url: '${AppUrls.baseUrl}${AppUrls.getSavedCars}');
    return RefreshIndicator(
        displacement: 200,
        onRefresh: () async {
          _loading = true;
          Future.delayed(const Duration(seconds: 2), () {
            _loading = false;
            setState(() {});
          });
        },
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            print(provider.favoriteCarIds);
                          },
                          child: SafeArea(
                              child: Image.asset('assets/images/wizmo.jpg'))),
                      TopSearchBar(),
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
                                      admin:
                                          // document[] ==
                                          //     'admin'
                                          //     ? true :
                                          false,
                                      name: document['name'],
                                      model: document['model'],
                                      onTap: () {
                                        DynamicCarDetailModel imageDetail =
                                            DynamicCarDetailModel(
                                                model: document['model'],
                                                images: document['images'],
                                                name: document['name'],
                                                description:
                                                    document['Description'],
                                                location: document["Location"],
                                                sellerType:
                                                    document['Seller Type'],
                                                addCarId: document['id'],
                                                longitude: document[""],
                                                latitude: document[""],
                                                email: document['email'],
                                                number:
                                                    document['phone_number'],
                                                sellerName: document['name'],
                                                price: document['Price']);
                                        var detail = CarDetailInitials(
                                            carDetails: imageDetail,
                                            featureName: featureNames,
                                            features:
                                                document['feature_values'],
                                            onTap: () {},
                                            provider: getIt());
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
