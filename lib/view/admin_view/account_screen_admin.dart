import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/authentication/authentication.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/account_screen/edit_profile/edit_profile.dart';
import 'package:maintenance/view/login_signup/login/login.dart';

class AccountScreenAdmin extends StatefulWidget {
  const AccountScreenAdmin({
    super.key,
  });

  @override
  State<AccountScreenAdmin> createState() => _AccountScreenAdminState();
}

class _AccountScreenAdminState extends State<AccountScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.grey),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return SizedBox(
                    height: height,
                    child: const Center(
                      child: Text("Something Went Wrong"),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Text(
                          'Hi ${snapshot.data['name']},',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.black),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Text(
                        'Admin Account',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * 0.91,
                        child: Divider(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.01),
                      child: const Text(
                        "Account",
                      ),
                    ),

                    ///Account
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.05),
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
                            Map profile = {
                              'name': snapshot.data['name'],
                              'email': snapshot.data['email'],
                              'address': snapshot.data['address'],
                              'phone_number': snapshot.data['phone_number'],
                              'date_of_birth': snapshot.data['date_of_birth'],
                              'profile_image': snapshot.data['profile_image'],
                              'role': snapshot.data['role'],
                              'status': snapshot.data['status']
                            };
                            navigateToEditProfile(profile);
                          },
                          titleAlignment: ListTileTitleAlignment.center,
                          leading: Icon(
                            Icons.person,
                            color: AppColors.black,
                          ),
                          titleTextStyle: const TextStyle(
                              leadingDistribution:
                                  TextLeadingDistribution.even),
                          title: Text(
                            "Edit Profile",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: AppColors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: const Text(
                        "Others",
                      ),
                    ),

                    ///Others
                    ...List.generate(
                        2,
                        (index) => Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.013,
                                  horizontal: width * 0.05),
                              child: Container(
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
                                  onTap: index == 0
                                      ? () {
                                          FirebaseAuth.instance
                                              .signOut()
                                              .then((value) {
                                            navigateToLogin();
                                            FlushBarUtils.flushBar(
                                                'SignOut Successful',
                                                context,
                                                'Success');
                                          });
                                        }
                                      : () async {
                                          await FirebaseAuth
                                              .instance.currentUser!
                                              .delete()
                                              .then((value) {
                                            navigateToLogin();
                                            FlushBarUtils.flushBar(
                                                'Delete Successful',
                                                context,
                                                'Success');
                                          });
                                        },
                                  titleAlignment: ListTileTitleAlignment.center,
                                  leading: Icon(
                                    oIcon[index],
                                    color: AppColors.red,
                                  ),
                                  titleTextStyle: const TextStyle(
                                      leadingDistribution:
                                          TextLeadingDistribution.even),
                                  title: Text(
                                    oTitle[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: AppColors.red),
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right,
                                      color: AppColors.red),
                                ),
                              ),
                            )),
                    SizedBox(
                      height: height * 0.013,
                    )
                  ],
                );
              },
            )),
      ),
    );
  }

  navigateToEditProfile(Map profile) {
    Navigation().push(
        EditProfile(
          profile: profile,
        ),
        context);
  }

  navigateToLogin() {
    Authentication().logout();
    Navigation().pushRep(const LogIn(), context);
  }

  List oIcon = [Icons.logout_outlined, Icons.delete_forever_outlined];
  List oTitle = ['Logout', 'Delete Account'];
}
