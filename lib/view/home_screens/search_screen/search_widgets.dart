import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/home_screen/specific_category_services/specific_category_services.dart';

Future<QuerySnapshot> serviceProviders(String categoryId) async {
  return FirebaseFirestore.instance
      .collection('categories')
      .doc(categoryId)
      .collection('services')
      .get();
}

Widget searchWidget(
    {required double width,
    required double height,
    required String categoryName,
    required String categoryId,
    required BuildContext context}) {
  return FutureBuilder(
    future: serviceProviders(categoryId),
    builder: (context, snapshot) {
      return InkWell(
        onTap: () {
          try {
            if (snapshot.data!.docs.isNotEmpty) {
              Navigation()
                  .push(SpecificCategoryServices(id: categoryId), context);
            } else {
              FlushBarUtils.flushBar("No Service Found", context, "Message");
            }
          } catch (e) {
            FlushBarUtils.flushBar("No Service Found", context, "Message");
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Container(
                  height: height * 0.07,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.17),
                            blurStyle: BlurStyle.normal,
                            offset: const Offset(1, 1),
                            blurRadius: 12,
                            spreadRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(height * 0.01)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryName.length > 40
                              ? '${categoryName.substring(0, 40)}..'
                              : categoryName,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (snapshot.connectionState == ConnectionState.waiting)
                          Text(
                            '0',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        if (snapshot.hasData)
                          Text(
                            snapshot.data!.docs.isEmpty
                                ? "0"
                                : snapshot.data!.docs.length.toString(),
                            style: Theme.of(context).textTheme.titleSmall,
                          )
                        else
                          Text(
                            '0',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget searchText(String text, double width, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
    child: Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
  );
}
