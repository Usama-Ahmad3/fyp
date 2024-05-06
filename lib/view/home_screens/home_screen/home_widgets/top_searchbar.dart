import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizmo/res/app_urls/app_urls.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/view/home_screens/home_screen/home_provider.dart';

class TopSearchBar extends StatelessWidget {
  final String? make;
  final String? model;
  const TopSearchBar({super.key, this.make, this.model});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: height * 0.01),
      child: Material(
        color: AppColors.white,
        shadowColor: AppColors.shadowColor,
        borderRadius: BorderRadius.circular(height * 0.01),
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: SizedBox(
            height: height * 0.33,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.012, vertical: height * 0.01),
                  child: Text(
                    'Find your perfect car',
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: AppColors.black),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.01, vertical: height * 0.01),
                    child: Consumer<HomeProvider>(
                      builder: (context, value, child) {
                        return InkWell(
                          onTap: () async {
                            value
                                .getMake(
                                    loginDetails: null,
                                    url: '${AppUrls.baseUrl}${AppUrls.make}',
                                    context: context)
                                .then((val) {
                              value.selectChoice(
                                  MediaQuery.of(context).size, context, 'Make');
                            });
                            make = value.make;
                          },
                          child: Container(
                            height: height * 0.052,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 2,
                                    blurStyle: BlurStyle.outer,
                                    offset: const Offset(0, 0))
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                value.make == '' ? 'Select Make' : value.make,
                                // title!.isEmpty?'Select Make':title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(color: AppColors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.01),
                  child: Container(
                      height: height * 0.052,
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 2,
                                blurStyle: BlurStyle.outer,
                                offset: const Offset(0, 0))
                          ],
                          borderRadius: BorderRadius.circular(8)),
                      child: Consumer<HomeProvider>(
                        builder: (context, value, child) => InkWell(
                          onTap: () {
                            value
                                .getModel(
                                    loginDetails: null,
                                    url:
                                        '${AppUrls.baseUrl}${AppUrls.carModel}',
                                    context: context)
                                .then((val) {
                              value.selectChoice(MediaQuery.of(context).size,
                                  context, 'Model');
                            });
                          },
                          child: Center(
                            child: Text(
                              value.model == '' ? 'Select Model' : value.model,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      color: value.make == ''
                                          ? AppColors.grey
                                          : AppColors.black),
                            ),
                          ),
                        ),
                      )),
                ),
                Consumer<HomeProvider>(
                  builder: (context, value, child) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.012, vertical: height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            value.onRefresh();
                            value.flushBarUtils('Checking', context, 'Test');
                          },
                          child: const Row(
                            children: [Icon(Icons.refresh), Text('Refresh')],
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              value.navigateToSearch(1, context);
                            },
                            child: const Text('More options'))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                  child: Container(
                    height: height * 0.06,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.buttonColor,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: AppColors.white,
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Consumer<HomeProvider>(
                            builder: (context, value, child) => Text(
                              'Search ${value.allCarsHome.cars != null ? value.allCarsHome.cars!.length : ''} cars',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: AppColors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectChoice(Size size, BuildContext context, String title) {
    if (title == 'Make' ? makeModel.make != null : carModel.model != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Select $title',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: AppColors.white),
          ),
          elevation: 5,
          backgroundColor: AppColors.shadowColor.withOpacity(0.1),
          contentPadding: EdgeInsets.symmetric(
              vertical: size.height * 0.03, horizontal: size.width * 0.01),
          content: SizedBox(
            height: size.height * 0.45,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                      title == 'Make'
                          ? makeModel.make!.length
                          : carModel.model!.length,
                      (index) => InkWell(
                            onTap: () {
                              title == 'Make'
                                  ? _make =
                                      makeModel.make![index].name.toString()
                                  : _model =
                                      carModel.model![index].model.toString();
                              notifyListeners();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.003),
                              child: Container(
                                  height: size.height * 0.07,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.shadowColor
                                              .withOpacity(0.17),
                                          blurStyle: BlurStyle.normal,
                                          offset: const Offset(1, 1),
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                    color:
                                        AppColors.buttonColor.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(
                                        size.height * 0.01),
                                    border: Border.all(
                                        color: AppColors.transparent),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.04),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          title == 'Make'
                                              ? makeModel.make![index].name
                                                  .toString()
                                              : carModel.model![index].model
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(color: AppColors.white),
                                        ),
                                        Text('tap to select',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                    color: AppColors.white)),
                                      ],
                                    ),
                                  )),
                            ),
                          ))
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
