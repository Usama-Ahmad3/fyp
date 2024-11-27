import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/SplashScreen.dart';
import 'package:maintenance/firebase_options.dart';
import 'package:maintenance/res/colors/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
                bodyLarge: TextStyle(
                    color: AppColors.grey, fontSize: height * 0.017))),
        home: const SplashScreen());
  }
}
