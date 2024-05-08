import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizmo/domain/app_repository.dart';
import 'package:wizmo/res/authentication/authentication.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/view/home_screens/account_screen/view_my_cars/view_my_cars_provider.dart';
import 'package:wizmo/view/home_screens/main_bottom_bar/main_bottom_bar.dart';
import 'package:wizmo/view/home_screens/search_screen/filter_cars/filter_car_provider.dart';
import 'package:wizmo/view/home_screens/search_screen/search_provider.dart';
import 'package:wizmo/view/onboarding/onboarding_provider.dart';
import 'data/get_repository.dart';
import 'models/Car Favourites models/get_car_favourites.dart';
import 'models/Car Favourites models/post_car_favourites.dart';
import 'models/all_cars_home.dart';
import 'models/get_profile.dart';
import 'models/sell_car_model.dart';
import 'models/selling_models/body_typee.dart';
import 'models/selling_models/car_acceleration.dart';
import 'models/selling_models/car_co2.dart';
import 'models/selling_models/car_color.dart';
import 'models/selling_models/car_engine_power.dart';
import 'models/selling_models/car_engine_size.dart';
import 'models/selling_models/car_fuel_consumption.dart';
import 'models/selling_models/car_gearbox.dart';
import 'models/selling_models/car_model.dart';
import 'models/selling_models/car_year.dart';
import 'models/selling_models/doors.dart';
import 'models/selling_models/drive_train.dart';
import 'models/selling_models/insurance.dart';
import 'models/selling_models/make_model.dart';
import 'models/selling_models/mileage.dart';
import 'models/selling_models/model_variation.dart';
import 'models/selling_models/seats.dart';
import 'models/selling_models/tax.dart';
import 'models/selling_models/type_fuel.dart';
import 'models/selling_models/type_seller.dart';
import 'models/user_profile.dart';
import 'view/onboarding/main_onboarding.dart';

GetIt getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBg3H8XGI3JiGNwUiuOj0fsrpYHuSv9dXU',
          appId: 'com.usama.side_project',
          messagingSenderId: '',
          storageBucket: "sideproject-667c3.appspot.com",
          projectId: 'sideproject-667c3'));
  getIt.registerLazySingleton<AppRepository>(() => GetRepository());
  getIt.registerLazySingleton<UserProfile>(() => UserProfile());
  getIt.registerLazySingleton<GetProfile>(() => GetProfile());
  getIt.registerLazySingleton<Authentication>(() => Authentication());
  getIt.registerLazySingleton<PostCarFavourites>(() => PostCarFavourites());
  getIt.registerLazySingleton<GetCarFavourites>(() => GetCarFavourites());
  getIt.registerLazySingleton<AllCarsHome>(() => AllCarsHome());
  getIt.registerLazySingleton<MakeModel>(() => MakeModel());
  getIt.registerLazySingleton<CarModel>(() => CarModel());
  getIt.registerLazySingleton<TypeFuel>(() => TypeFuel());
  getIt.registerLazySingleton<CarFuelConsumption>(() => CarFuelConsumption());
  getIt.registerLazySingleton<CarEngineSize>(() => CarEngineSize());
  getIt.registerLazySingleton<CarEnginePower>(() => CarEnginePower());
  getIt.registerLazySingleton<Mileage>(() => Mileage());
  getIt.registerLazySingleton<CarGearbox>(() => CarGearbox());
  getIt.registerLazySingleton<Doors>(() => Doors());
  getIt.registerLazySingleton<Seats>(() => Seats());
  getIt.registerLazySingleton<CarColor>(() => CarColor());
  getIt.registerLazySingleton<Tax>(() => Tax());
  getIt.registerLazySingleton<SearchProvider>(
      () => SearchProvider(appRepository: getIt(), carModel: getIt()));
  getIt.registerLazySingleton<Insurance>(() => Insurance());
  getIt.registerLazySingleton<SellCarModel>(() => SellCarModel());
  getIt.registerLazySingleton<CarYear>(() => CarYear());
  getIt.registerLazySingleton<ModelVariation>(() => ModelVariation());
  getIt.registerLazySingleton<CarAcceleration>(() => CarAcceleration());
  getIt.registerLazySingleton<BodyTypee>(() => BodyTypee());
  getIt.registerLazySingleton<DriveTrain>(() => DriveTrain());
  getIt.registerLazySingleton<CarCo2>(() => CarCo2());
  getIt.registerLazySingleton<TypeSeller>(() => TypeSeller());
  getIt.registerSingleton<FilterCarProvider>(
      FilterCarProvider(appRepository: getIt(), myAllCarModel: getIt()));
  getIt.registerSingleton<ViewMyCarsProvider>(
      ViewMyCarsProvider(appRepository: getIt(), myAllCarModel: getIt()));
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnBoardingProvider()),
        ChangeNotifierProvider(
            create: (context) => FilterCarProvider(
                myAllCarModel: getIt(), appRepository: getIt())),
        ChangeNotifierProvider(
            create: (context) =>
                SearchProvider(carModel: getIt(), appRepository: getIt())),
        ChangeNotifierProvider(
            create: (context) => ViewMyCarsProvider(
                appRepository: getIt(), myAllCarModel: getIt())),
      ],
      child: MaterialApp(
        title: 'Wizmo',
        color: AppColors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
            useMaterial3: true,
            textTheme: TextTheme(
                // titleMedium:
                //     TextStyle(color: AppColors.black, fontSize: height * 0.04),
                headline1:
                    TextStyle(color: AppColors.black, fontSize: height * 0.06),
                headline2:
                    TextStyle(color: Colors.grey, fontSize: height * 0.03),
                headline3:
                    TextStyle(color: Colors.grey, fontSize: height * 0.018),
                headline4: TextStyle(
                    color: AppColors.grey, fontSize: height * 0.017))),
        home: walk
            ? MainBottomBar(
                index: 0,
              )
            : MainOnBoarding(),
      ),
    );
  }
}
