import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/authentication/authentication.dart';
import 'package:maintenance/utils/images.dart';
import 'package:maintenance/view/admin_view/main_bottom_bar_admin.dart';
import 'package:maintenance/view/home_screens/main_bottom_bar/main_bottom_bar.dart';
import 'package:maintenance/view/onboarding/main_onboarding.dart';
import 'package:maintenance/view/seller_view/main_bottom_bar_seller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isUser = false;
  bool walk = false;
  bool isLoggedIn = false;
  String status = '';
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    walk = pref.getBool("walk") ?? false;

    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      isUser = userDoc['role'] == "User";
      if (userDoc['role'] != "Admin") {
        status = userDoc['status'];
      }
      isLoggedIn = true;
      await Authentication().saveLogin(true);
    } else {
      isLoggedIn = false;
    }
    await Future.delayed(const Duration(seconds: 3));
    if (walk) {
      if (isUser) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainBottomBar(
                      status: status,
                    )));
      } else {
        ///means it's admin account
        if (status.isEmpty) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainBottomBarAdmin()));
        } else {
          if (isLoggedIn) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainBottomBarSeller(
                          status: status,
                        )));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainBottomBar()));
          }
        }
      }
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MainOnBoarding()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Image.asset(
              AppImages.background,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.2,
            child: const Text(
              "Maintenance & Repairing Services",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
