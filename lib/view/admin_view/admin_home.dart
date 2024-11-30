import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/cashed_image.dart';
import 'package:maintenance/res/common_widgets/empty_screen.dart';
import 'package:maintenance/res/common_widgets/popup.dart';
import 'package:maintenance/utils/flushbar.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> {
  int selectedRequestType = 0;
  final requestType = ['Pending', "Canceled", "All"];

  Future<QuerySnapshot> getPendingRequests(int selectedType) async {
    if (selectedType == 2) {
      return await FirebaseFirestore.instance
          .collection('users')
          .where('status', isNotEqualTo: 'admin')
          .get();
    } else {
      return await FirebaseFirestore.instance
          .collection('users')
          .where('status',
              isEqualTo: selectedType == 0 ? "pending" : "canceled")
          .get();
    }
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
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Text(
                requestType[selectedRequestType],
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: AppColors.black),
              ),
              SizedBox(
                width: width * 0.01,
              ),
              PopupMenuButton<int>(
                onSelected: (value) {
                  if (selectedRequestType != value) {
                    setState(() {
                      selectedRequestType = value;
                    });
                  }
                },
                itemBuilder: (context) {
                  return List.generate(
                    requestType.length,
                    (index) => PopupMenuItem(
                        value: index, child: Text(requestType[index])),
                  );
                },
              ),
              SizedBox(
                width: width * 0.03,
              ),
            ],
            title: Text(
              'Requests',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppColors.black),
            ),
          ),
          body: FutureBuilder(
            future: getPendingRequests(selectedRequestType),
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
                  if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data!.docs[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.01,
                              horizontal: width * 0.04),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.shadowColor
                                              .withOpacity(0.17),
                                          blurStyle: BlurStyle.normal,
                                          offset: const Offset(1, 1),
                                          blurRadius: 12,
                                          spreadRadius: 2)
                                    ],
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  titleAlignment: ListTileTitleAlignment.center,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: cachedNetworkImage(
                                        cuisineImageUrl: user['profile_image'],
                                        width: width * 0.13,
                                        height: height * 0.15,
                                        imageFit: BoxFit.fill),
                                  ),
                                  titleTextStyle: const TextStyle(
                                      leadingDistribution:
                                          TextLeadingDistribution.even),
                                  title: Text(
                                    user['name'],
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03),
                                  subtitle: Text(
                                    user['email'],
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              selectedRequestType == 2
                                  ? const SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          ...List.generate(
                                            2,
                                            (index) => requestButton(
                                                onTap: index == 0
                                                    ? () async {
                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(user['id'])
                                                              .update({
                                                            'status': "active",
                                                          });
                                                          setState(() {});
                                                        } catch (e) {
                                                          FlushBarUtils
                                                              .flushBar(
                                                                  e.toString(),
                                                                  context,
                                                                  "Error");
                                                        }
                                                      }
                                                    : selectedRequestType == 1
                                                        ? () {
                                                            popup(
                                                                context:
                                                                    context,
                                                                text:
                                                                    "Are you sure to delete account",
                                                                onTap:
                                                                    () async {
                                                                  try {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .doc(user[
                                                                            'id'])
                                                                        .delete();
                                                                  } catch (e) {
                                                                    FlushBarUtils.flushBar(
                                                                        e.toString(),
                                                                        context,
                                                                        "Error");
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                buttonText:
                                                                    "Delete");
                                                          }
                                                        : () async {
                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(user[
                                                                      'id'])
                                                                  .update({
                                                                'status':
                                                                    "canceled",
                                                              });
                                                              setState(() {});
                                                            } catch (e) {
                                                              FlushBarUtils
                                                                  .flushBar(
                                                                      e.toString(),
                                                                      context,
                                                                      "Error");
                                                            }
                                                          },
                                                text: index == 0
                                                    ? 'Approve'
                                                    : selectedRequestType == 1
                                                        ? "Delete"
                                                        : 'Cancel',
                                                loading: loading,
                                                size:
                                                    MediaQuery.sizeOf(context)),
                                          )
                                        ])
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox(
                      height: height * 0.8,
                      child: Center(
                        child: EmptyScreen(text: "No Data Found", text2: ''),
                      ),
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
        ));
  }

  Widget requestButton(
      {required VoidCallback onTap,
      required Size size,
      required String text,
      required bool loading}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height * 0.05,
        width: size.width * 0.44,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: AppColors.containerB12.withOpacity(0.2),
                  blurStyle: BlurStyle.normal,
                  offset: const Offset(0.5, 1),
                  blurRadius: 10,
                  spreadRadius: 5)
            ],
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(size.height * 0.05)),
        child: Center(
            child: loading
                ? CircularProgressIndicator(
                    color: AppColors.white,
                  )
                : Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.white),
                  )),
      ),
    );
  }
}
