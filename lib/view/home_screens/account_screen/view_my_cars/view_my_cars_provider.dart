import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:wizmo/domain/app_repository.dart';
import 'package:wizmo/models/all_cars_home.dart';
import 'package:wizmo/utils/navigator_class.dart';
import 'package:wizmo/view/home_screens/home_screen/car_detail_screen/car_detail_initials.dart';
import 'package:wizmo/view/home_screens/home_screen/car_detail_screen/car_detail_screen.dart';

class ViewMyCarsProvider with ChangeNotifier {
  AppRepository appRepository;
  AllCarsHome myAllCarModel;
  ViewMyCarsProvider(
      {required this.appRepository, required this.myAllCarModel});
  final nextPageController = CarouselController();
  int _initialPage = 0;
  int get initialPage => _initialPage;
  bool _loading = true;
  bool get loading => _loading;
  navigateToCarDetail(
      {required BuildContext context, required CarDetailInitials detail}) {
    Navigation().push(CarDetailScreen(carDetailInitials: detail), context);
  }

  viewMyAllCars(
      {required BuildContext context,
      required String url,
      Map? details}) async {
    var response =
        await appRepository.post(url: url, context: context, details: details);
    print(response);
    if (response != null) {
      try {
        myAllCarModel = AllCarsHome.fromJson(response);
        _loading = false;
        notifyListeners();
      } catch (e) {
        print('EEEEEEEEERRRRRRRRRRRRRRRROOOOOOOOOOORRRRR');
        print(e);
      }
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  onChangeCorousel(int index) {
    _initialPage = index;
    notifyListeners();
  }
}
