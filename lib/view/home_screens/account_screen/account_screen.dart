import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizmo/main.dart';
import 'package:wizmo/res/app_urls/app_urls.dart';
import 'package:wizmo/res/authentication/authentication.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/exception/error_widget.dart';
import 'package:wizmo/utils/flushbar.dart';
import 'package:wizmo/utils/navigator_class.dart';
import 'package:wizmo/view/home_screens/account_screen/empty.dart';
import 'package:wizmo/view/home_screens/main_bottom_bar/main_bottom_bar.dart';
import 'package:wizmo/view/login_signup/login/login.dart';
import 'package:wizmo/view/login_signup/signup/signup.dart';

import 'edit_profile/edit_profile.dart';
import 'view_my_cars/view_my_cars.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isLogIn = true;
  bool loading = true;
  checkAuth() async {
    _isLogIn = await Authentication().getAuth();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    checkAuth();
    print('In the Account Screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: DefaultTextStyle(
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.grey),
          child: SingleChildScrollView(
              child: loading
                  ? SizedBox(
                      height: height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _isLogIn == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              child: Text(
                                'Welcome To Wizmo',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
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
                                  horizontal: width * 0.05,
                                  vertical: height * 0.02),
                              child: const Text(
                                "Account",
                              ),
                            ),

                            ///Account
                            ...List.generate(
                                3,
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          onTap: index == 0
                                              ? () {
                                                  navigateToEditProfile();
                                                }
                                              : index == 1
                                                  ? () {
                                                      navigateToMyCars();
                                                    }
                                                  : () {
                                                      navigateToSavedCars();
                                                    },
                                          titleAlignment:
                                              ListTileTitleAlignment.center,
                                          leading: Icon(
                                            icon[index],
                                            color: AppColors.black,
                                          ),
                                          titleTextStyle: const TextStyle(
                                              leadingDistribution:
                                                  TextLeadingDistribution.even),
                                          title: Text(
                                            title[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                          trailing: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: AppColors.black),
                                        ),
                                      ),
                                    )),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.02),
                              child: const Text(
                                "Support",
                              ),
                            ),

                            ///Support
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          onTap: () {},
                                          titleAlignment:
                                              ListTileTitleAlignment.center,
                                          leading: Icon(
                                            sIcon[index],
                                            color: AppColors.black,
                                          ),
                                          titleTextStyle: const TextStyle(
                                              leadingDistribution:
                                                  TextLeadingDistribution.even),
                                          title: Text(
                                            sTitle[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                          trailing: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: AppColors.black),
                                        ),
                                      ),
                                    )),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.02),
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
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
                                          titleAlignment:
                                              ListTileTitleAlignment.center,
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
                                                .headline3!
                                                .copyWith(color: AppColors.red),
                                          ),
                                          trailing: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: AppColors.red),
                                        ),
                                      ),
                                    )),
                            SizedBox(
                              height: height * 0.013,
                            )
                          ],
                        )
                      : Empty(
                          login: () {
                            navigateToLogin();
                          },
                          signup: () {
                            navigateToSignup();
                          },
                        )),
        ),
      ),
    );
  }

  navigateToSignup() {
    Navigation().push(const SignUp(), context);
  }

  navigateToEditProfile() {
    Navigation().push(const EditProfile(), context);
  }

  navigateToLogin() {
    Navigation().pushRep(const LogIn(), context);
  }

  navigateToMyCars() {
    Navigation().push(ViewMyCars(), context);
  }

  navigateToSavedCars() {
    Navigation().pushRep(MainBottomBar(provider: getIt(), index: 3), context);
  }

  List icon = [Icons.person, Icons.car_crash_sharp, Icons.favorite];
  List title = ["Edit Profile", 'View My Cars', "Saved Cars"];
  List sIcon = [Icons.info_outline, Icons.call];
  List sTitle = ['Help', 'Contact Us'];
  List oIcon = [Icons.logout_outlined, Icons.delete_forever_outlined];
  List oTitle = ['Logout', 'Delete Account'];
}
