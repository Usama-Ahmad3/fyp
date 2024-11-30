import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/empty_screen.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/home_screen/home_widgets/category_container.dart';
import 'package:maintenance/view/home_screens/home_screen/specific_category_services/category_detail_screen/specific_service_detail.dart';

class ViewServices extends StatefulWidget {
  final Map profile;
  const ViewServices({super.key, required this.profile});

  @override
  State<ViewServices> createState() => _ViewServicesState();
}

class _ViewServicesState extends State<ViewServices> {
  List categoryIds = [];

  Future<List<Map<String, dynamic>>> getServicesByUserId(String userId) async {
    try {
      final categorySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      List<Map<String, dynamic>> matchingServices = [];
      categoryIds.clear();
      for (var categoryDoc in categorySnapshot.docs) {
        final servicesQuery = await categoryDoc.reference
            .collection('services')
            .where('user_id', isEqualTo: userId)
            .get();
        for (var serviceDoc in servicesQuery.docs) {
          categoryIds.add(serviceDoc.reference.parent.parent!.id);
          matchingServices.add(serviceDoc.data());
        }
      }

      return matchingServices;
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.profile['name']} Services',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: AppColors.black),
        ),
      ),
      body: FutureBuilder(
        future: getServicesByUserId(widget.profile['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.only(top: height * 0.02),
                child: EmptyScreen(text: 'No Data Found', text2: ''),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: height * 0.4,
                child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.buttonColor)),
              );
            } else {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    ...List.generate(snapshot.data!.length, (index) {
                      var data = snapshot.data![index];
                      DateTime dateTime = data['created_at'].toDate();
                      final time =
                          DateFormat('dd MMMM yyyy \'at\' hh:mm a').format(
                        DateTime(dateTime.year, dateTime.month, dateTime.day,
                            dateTime.hour, dateTime.minute, dateTime.second),
                      );
                      return CategoryContainer(
                        image: data['images'],
                        category: time,
                        isCompany: true,
                        services: data['company_name'],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SpecificServiceDetailScreen(
                                        userData: widget.profile,
                                        categoryId: categoryIds[index],
                                        serviceData: data),
                              )).then(
                            (value) {
                              if (value != null) {
                                setState(() {});
                              }
                            },
                          );
                        },
                      );
                    }),
                  ],
                );
              } else {
                return Center(
                  child: EmptyScreen(text: "No Data Found", text2: ''),
                );
              }
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
    );
  }
}
