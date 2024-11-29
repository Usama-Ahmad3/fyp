import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/empty_screen.dart';
import 'package:maintenance/view/home_screens/home_screen/home_widgets/category_container.dart';
import 'package:maintenance/view/home_screens/home_screen/specific_category_services/category_detail_screen/category_detail.dart';

class SpecificCategoryServices extends StatefulWidget {
  final String id;
  const SpecificCategoryServices({super.key, required this.id});

  @override
  State<SpecificCategoryServices> createState() =>
      _SpecificCategoryServicesState();
}

class _SpecificCategoryServicesState extends State<SpecificCategoryServices> {
  Future<QuerySnapshot> fetchDataFromFirebase() async {
    return FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.id)
        .collection('services')
        .get();
  }

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final user =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return user.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: fetchDataFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.buttonColor),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  var userId = document['user_id'];

                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchUserData(userId),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: AppColors.buttonColor),
                        );
                      }

                      if (userSnapshot.hasData) {
                        var userInfo = userSnapshot.data!;

                        return CategoryContainer(
                          image: document['images'],
                          category: document['location'],
                          isCompany: true,
                          services: document['company_name'],
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryDetailScreen(
                                      userData: userInfo,
                                      serviceData: document.data()
                                          as Map<dynamic, dynamic>),
                                ));
                          },
                        );
                      } else {
                        return const Text("User data not available");
                      }
                    },
                  );
                },
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: height * 0.02),
                child: EmptyScreen(text: 'No Data Found', text2: ''),
              );
            }
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
