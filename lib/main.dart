import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maintenance/firebase_options.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/view/home_screens/main_bottom_bar/main_bottom_bar.dart';

import 'view/onboarding/main_onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool walk = false;
  bool isLogin = false;
  load() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      walk = pref.getBool("walk") ?? false;
      isLogin = pref.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MyApp(
        walk: walk,
        isLogin: isLogin,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool walk;
  final bool isLogin;
  const MyApp({super.key, required this.walk, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: 'maintenance',
      color: AppColors.white,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
          useMaterial3: true,
          textTheme: TextTheme(
              // titleMedium:
              //     TextStyle(color: AppColors.black, fontSize: height * 0.04),
              titleLarge:
                  TextStyle(color: AppColors.black, fontSize: height * 0.06),
              titleMedium:
                  TextStyle(color: Colors.grey, fontSize: height * 0.03),
              titleSmall:
                  TextStyle(color: Colors.grey, fontSize: height * 0.018),
              bodyLarge:
                  TextStyle(color: AppColors.grey, fontSize: height * 0.017))),
      home: walk
          ? MainBottomBar(
              index: 0,
            )
          : MainOnBoarding(),
    );
  }
}
