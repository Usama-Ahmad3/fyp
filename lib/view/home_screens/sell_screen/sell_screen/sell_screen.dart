import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizmo/main.dart';
import 'package:wizmo/models/sell_car_model.dart';
import 'package:wizmo/res/app_urls/app_urls.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/button_widget.dart';
import 'package:wizmo/res/common_widgets/text_field_widget.dart';
import 'package:wizmo/utils/navigator_class.dart';
import 'package:wizmo/view/home_screens/sell_screen/about_your_car/about_your_car.dart';
import 'package:wizmo/view/home_screens/sell_screen/app_bar_widget.dart';
import 'package:wizmo/view/home_screens/sell_screen/sell_screen/sell_screen_provider.dart';

class SellScreen extends StatefulWidget {
  final SellScreenProvider provider;
  const SellScreen({super.key, required this.provider});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  SellScreenProvider get sellProvider => widget.provider;
  final nameController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final modelVariationController = TextEditingController();
  final yearController = TextEditingController();
  final sellerTypeController = TextEditingController();
  final bodyTypeController = TextEditingController();
  final co2Controller = TextEditingController();
  final accelerationController = TextEditingController();
  final driveTrainController = TextEditingController();
  final registrationController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  SellCarModel sellCarModel = SellCarModel();
  final _formKey = GlobalKey<FormState>();
  bool auto = true;
  bool manual = false;
  autoDescriptionDialog(BuildContext context, double height) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: height * 0.12,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        autofocus: true,
                        activeColor: AppColors.buttonColor,
                        value: auto,
                        onChanged: (bool? value) {
                          auto = value!;
                          manual = !auto;
                          descriptionController.clear();
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                      Checkbox(
                        autofocus: true,
                        activeColor: AppColors.buttonColor,
                        value: manual,
                        onChanged: (bool? value) {
                          manual = value!;
                          auto = !value;
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Auto Description"),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      const Text("Manual Description")
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> _values = []; // List to store fetched values

  Future<void> _fetchData(String field) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('sell_car_data').get();

    List<String> values = [];
    querySnapshot.docs.forEach((doc) {
      var data = doc.data() as Map<String, dynamic>;
      values.add(data[field]);
    });

    setState(() {
      _values = values;
      print(_values);
    });
  }

  selectChoice(Size size, BuildContext context, String title, List list) {
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
                    list.length,
                    (index) => InkWell(
                          onTap: () {
                            if (title == 'Make') {
                              makeController.text = list[index];
                              sellCarModel.make = list[index];
                            } else if (title == 'Model') {
                              modelController.text = list[index];
                              sellCarModel.model = list[index];
                            } else if (title == 'body_type') {
                              bodyTypeController.text = list[index];
                              sellCarModel.bodyType = list[index];
                            } else if (title == 'Acceleration') {
                              accelerationController.text = list[index];
                              sellCarModel.acceleration = list[index];
                            } else if (title == 'Drivetrain') {
                              driveTrainController.text = list[index];
                              sellCarModel.driveTrain = list[index];
                            } else if (title == 'Variation') {
                              modelVariationController.text = list[index];
                              sellCarModel.variation = list[index];
                            } else if (title == 'Year') {
                              yearController.text = list[index];
                              sellCarModel.year = list[index];
                            } else if (title == 'Seller') {
                              sellerTypeController.text = list[index];
                              sellCarModel.sellerType = list[index];
                            } else {
                              co2Controller.text = list[index];
                              sellCarModel.co2 = list[index];
                            }
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
                                  color: AppColors.buttonColor.withOpacity(0.7),
                                  borderRadius:
                                      BorderRadius.circular(size.height * 0.01),
                                  border:
                                      Border.all(color: AppColors.transparent),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.04),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        list[index],
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

  @override
  void initState() {
    if (kDebugMode) {
      print('In the Sell Screen');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var authProvider = Provider.of<SellScreenProvider>(context, listen: false);
    authProvider.checkAuth(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(width, height * 0.08),
          child: AppBarWidget(
            size: MediaQuery.sizeOf(context),
            color1: AppColors.grey,
            color2: AppColors.grey,
            color3: AppColors.grey,
            title: 'Create a new ad',
          ),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),

                  ///name
                  TextFieldWidget(
                    controller: nameController,
                    hintText: 'Enter your car name',
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return "name field can't empty";
                      }
                      return null;
                    },
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.034),
                        borderSide: BorderSide(color: AppColors.white)),
                  ),
                  SizedBox(height: height * 0.025),

                  ///Make
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        _fetchData('make');
                        // provider
                        //     .getMake(
                        //         loginDetails: null,
                        //         url: '${AppUrls.baseUrl}${AppUrls.make}',
                        //         context: context)
                        //     .then((val) {
                        //   selectChoice(
                        //       MediaQuery.of(context).size, context, 'Make');
                        // });
                      },
                      child: TextFieldWidget(
                        controller: makeController,
                        hintText: 'Select Make',
                        suffixIcon: Icons.keyboard_arrow_right,
                        enable: false,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "make field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(
                              color: AppColors.white,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///model
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider
                            .getModel(
                                loginDetails: null,
                                url: '${AppUrls.baseUrl}${AppUrls.carModel}',
                                context: context)
                            .then((val) {
                          provider.selectChoice(
                              MediaQuery.of(context).size, context, 'Model');
                        });
                      },
                      child: TextFieldWidget(
                        controller: modelController,
                        hintText: 'Select your car model',
                        suffixIcon: Icons.keyboard_arrow_right,
                        enable: false,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "car model field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///modelVariation
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider
                            .getModelVariation(
                                loginDetails: null,
                                url:
                                    '${AppUrls.baseUrl}${AppUrls.carVariation}',
                                context: context)
                            .then((value) {
                          provider.selectChoice(MediaQuery.of(context).size,
                              context, 'Variation');
                        });
                      },
                      child: TextFieldWidget(
                        controller: modelVariationController,
                        hintText: 'Select your car model variation',
                        suffixIcon: Icons.keyboard_arrow_right,
                        enable: false,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "car model variation field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///year
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider
                            .getYear(
                                loginDetails: null,
                                url: '${AppUrls.baseUrl}${AppUrls.carYear}',
                                context: context)
                            .then((value) {
                          provider.selectChoice(
                              MediaQuery.of(context).size, context, 'Year');
                        });
                      },
                      child: TextFieldWidget(
                        controller: yearController,
                        hintText: 'Select your car year',
                        suffixIcon: Icons.keyboard_arrow_right,
                        enable: false,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "car year field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///bodyType
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider
                            .getBodyType(
                                loginDetails: null,
                                url: '${AppUrls.baseUrl}${AppUrls.carBodyType}',
                                context: context)
                            .then((value) {
                          provider.selectChoice(MediaQuery.of(context).size,
                              context, 'body_type');
                        });
                      },
                      child: TextFieldWidget(
                        controller: bodyTypeController,
                        hintText: 'Select body_type',
                        suffixIcon: Icons.keyboard_arrow_right,
                        enable: false,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "body_type field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///acceleration
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider
                            .getAcceleration(
                                loginDetails: null,
                                url:
                                    '${AppUrls.baseUrl}${AppUrls.carAcceleration}',
                                context: context)
                            .then((value) {
                          provider.selectChoice(MediaQuery.of(context).size,
                              context, 'Acceleration');
                        });
                      },
                      child: TextFieldWidget(
                        controller: accelerationController,
                        hintText: 'acceleration',
                        enable: false,
                        suffixIcon: Icons.keyboard_arrow_right,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "acceleration field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///driveTrain
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider
                            .getDriveTrain(
                                loginDetails: null,
                                url:
                                    '${AppUrls.baseUrl}${AppUrls.carDriveTrain}',
                                context: context)
                            .then((value) {
                          provider.selectChoice(MediaQuery.of(context).size,
                              context, 'Drivetrain');
                        });
                      },
                      child: TextFieldWidget(
                        controller: driveTrainController,
                        hintText: 'Select drivetrain',
                        enable: false,
                        suffixIcon: Icons.keyboard_arrow_right,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "drivetrain field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///Co2
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider
                            .getCo2(
                                loginDetails: null,
                                url: '${AppUrls.baseUrl}${AppUrls.carCO2}',
                                context: context)
                            .then((value) {
                          provider.selectChoice(
                              MediaQuery.of(context).size, context, 'Co2');
                        });
                      },
                      child: TextFieldWidget(
                        controller: co2Controller,
                        hintText: 'Select co2',
                        suffixIcon: Icons.keyboard_arrow_right,
                        enable: false,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "co2 field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///registration Number
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => TextFieldWidget(
                      controller: registrationController,
                      hintText: 'Enter your registration number',
                      type: TextInputType.number,
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return "name field can't empty";
                        }
                        return null;
                      },
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(height * 0.034),
                          borderSide: BorderSide(color: AppColors.white)),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///sellerType

                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider
                            .getSellerType(
                                loginDetails: null,
                                url:
                                    '${AppUrls.baseUrl}${AppUrls.carSellerType}',
                                context: context)
                            .then((value) {
                          provider.selectChoice(
                              MediaQuery.of(context).size, context, 'Seller');
                        });
                      },
                      child: TextFieldWidget(
                        controller: sellerTypeController,
                        hintText: 'Select seller type',
                        suffixIcon: Icons.keyboard_arrow_right,
                        enable: false,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "seller type field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///location
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider.navigateToMap(context);
                      },
                      child: TextFieldWidget(
                        controller: locationController,
                        hintText: 'Select your location',
                        suffixIcon: Icons.keyboard_arrow_right,
                        enable: false,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return "location field can't empty";
                          }
                          return null;
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///price
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => TextFieldWidget(
                      controller: priceController,
                      hintText: 'Enter price',
                      type: TextInputType.number,
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return "price field can't empty";
                        }
                        return null;
                      },
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(height * 0.034),
                          borderSide: BorderSide(color: AppColors.white)),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///description
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => InkWell(
                      onTap: () {
                        provider.auto
                            ? provider.autoDescriptionDialog(context, height)
                            : null;
                      },
                      child: TextFieldMultiWidget(
                        controller: descriptionController,
                        hintText: 'Enter description',
                        enable: provider.manual,
                        suffixIcon: Icons.keyboard_arrow_right,
                        suffixIconColor: AppColors.grey,
                        hideIcon: Icons.keyboard_arrow_right,
                        passTap: () {
                          provider.autoDescriptionDialog(context, height);
                        },
                        onValidate: (value) {
                          if (provider.auto) {
                            return null;
                          } else {
                            if (value.isEmpty) {
                              return "description field can't empty";
                            }
                            return null;
                          }
                        },
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.034),
                            borderSide: BorderSide(color: AppColors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Consumer<SellScreenProvider>(
                    builder: (context, provider, child) => ButtonWidget(
                        text: 'Continue',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            sellCarModel.carName = nameController.text;
                            sellCarModel.registration =
                                registrationController.text;
                            sellCarModel.price = priceController.text;
                            sellCarModel.description =
                                descriptionController.text;
                            sellCarModel.location = locationController.text;
                            sellCarModel.auto = auto;
                            Navigation().push(
                                AboutYourCar(
                                    provider: getIt(),
                                    sellCarModel: sellCarModel),
                                context);
                          }
                        }),
                  ),
                  SizedBox(
                    height: height * 0.034,
                  )
                ],
              ),
            )));
  }
}
