import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/cashed_image.dart';
import 'package:maintenance/res/common_widgets/empty_screen.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/view/admin_view/all_users/manage_users.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  int selectedRole = 1;
  final roleUser = ['User', "Seller", "Admin"];
  Future<QuerySnapshot> getAllUsers() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: roleUser[selectedRole])
        .get();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Text(
              roleUser[selectedRole],
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
                if (selectedRole != value) {
                  setState(() {
                    selectedRole = value;
                  });
                }
              },
              itemBuilder: (context) {
                return List.generate(
                  roleUser.length,
                  (index) =>
                      PopupMenuItem(value: index, child: Text(roleUser[index])),
                );
              },
            ),
            SizedBox(
              width: width * 0.03,
            ),
          ],
          title: Text(
            'All Users',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.black),
          ),
        ),
        body: FutureBuilder(
          future: getAllUsers(),
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
                            vertical: height * 0.01, horizontal: width * 0.04),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColors.shadowColor.withOpacity(0.17),
                                    blurStyle: BlurStyle.normal,
                                    offset: const Offset(1, 1),
                                    blurRadius: 12,
                                    spreadRadius: 2)
                              ],
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            onTap: () {
                              if (selectedRole != 2) {
                                Map profile = {
                                  'id': user['id'],
                                  'name': user['name'],
                                  'email': user['email'],
                                  'address': user['address'],
                                  'phone_number': user['phone_number'],
                                  'date_of_birth': user['date_of_birth'],
                                  'profile_image': user['profile_image'],
                                  'role': user['role'],
                                  'status': user['status']
                                };
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManageUsers(
                                        profile: profile,
                                        isUser: selectedRole == 0,
                                      ),
                                    )).then(
                                  (value) {
                                    if (value != null) {
                                      setState(() {});
                                    }
                                  },
                                );
                              } else {
                                FlushBarUtils.flushBar(
                                    "Can't Manage Admin By App",
                                    context,
                                    "Read Only Role");
                              }
                            },
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
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            subtitle: Text(
                              user['email'],
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: AppColors.black),
                          ),
                        ),
                      );
                    },
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
        ));
  }
}
