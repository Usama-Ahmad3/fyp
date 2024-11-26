import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/models/sell_car_model.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/button_widget.dart';
import 'package:maintenance/res/common_widgets/text_field_widget.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/sell_screen/add_photo/add_photo.dart';
import 'package:maintenance/view/home_screens/sell_screen/app_bar_widget.dart';
import 'package:maintenance/view/home_screens/sell_screen/description_screen/description_screen.dart';

class AboutYourCar extends StatefulWidget {
  final SellCarModel sellCarModel;
  const AboutYourCar({super.key, required this.sellCarModel});

  @override
  State<AboutYourCar> createState() => _AboutYourCarState();
}

class _AboutYourCarState extends State<AboutYourCar> {
  TextEditingController engineController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController insuranceController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController fuelConsumptionController = TextEditingController();
  TextEditingController powerController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController gearBoxController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController doorsController = TextEditingController();
  TextEditingController seatsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<List> _fetchData(String field) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('sell_car_data').get();

    List values = [];
    querySnapshot.docs.forEach((doc) {
      var data = doc.data() as Map<String, dynamic>;
      values = data[field];
    });

    return values;
  }

  selectChoice(
      {required Size size, required String title, required List list}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select $title',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
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
                            if (title == 'Fuel Type') {
                              fuelController.text = list[index];
                              widget.sellCarModel.fuelType = list[index];
                            } else if (title == 'Fuel Consumption') {
                              fuelConsumptionController.text = list[index];
                              widget.sellCarModel.consumption = list[index];
                            } else if (title == 'Engine Size') {
                              engineController.text = list[index];
                              widget.sellCarModel.engineSize = list[index];
                            } else if (title == 'Engine Power') {
                              powerController.text = list[index];
                              widget.sellCarModel.enginePower = list[index];
                            } else if (title == 'Mileage') {
                              mileageController.text = list[index];
                              widget.sellCarModel.mileage = list[index];
                            } else if (title == 'Gearbox') {
                              gearBoxController.text = list[index];
                              widget.sellCarModel.gearBox = list[index];
                            } else if (title == 'Doors') {
                              doorsController.text = list[index];
                              widget.sellCarModel.doors = list[index];
                            } else if (title == "Colour") {
                              colorController.text = list[index];
                              widget.sellCarModel.colour = list[index];
                            } else if (title == 'Seats') {
                              seatsController.text = list[index];
                              widget.sellCarModel.seats = list[index];
                            } else if (title == 'Tax') {
                              taxController.text = list[index];
                              widget.sellCarModel.tax = list[index];
                            } else {
                              insuranceController.text = list[index];
                              widget.sellCarModel.insurance = list[index];
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
                                            .titleSmall!
                                            .copyWith(color: AppColors.white),
                                      ),
                                      Text('tap to select',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
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
      print('In The About Your Car');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.08),
        child: AppBarWidget(
          title: 'About your car',
          color1: AppColors.buttonColor,
          color2: AppColors.grey,
          color3: AppColors.grey,
          size: MediaQuery.sizeOf(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),

              ///FuelType
              InkWell(
                onTap: () async {
                  await _fetchData('fuel_type').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Fuel Type',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: fuelController,
                  hintText: 'Select fuel type',
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "fuel type field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(height: height * 0.025),

              ///FuelConsumption
              InkWell(
                onTap: () async {
                  await _fetchData('fuel_consumption').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Fuel Consumption',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: fuelConsumptionController,
                  hintText: 'Select fuel consumption',
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "fuel consumption field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(height: height * 0.025),

              ///engine size
              InkWell(
                onTap: () async {
                  await _fetchData('engine_size').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Engine Size',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: engineController,
                  hintText: 'Select engine size',
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "engine size field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(height: height * 0.025),

              ///Engine power
              InkWell(
                onTap: () async {
                  await _fetchData('engine_power').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Engine Power',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: powerController,
                  hintText: 'Select engine power',
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "engine power field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(height: height * 0.025),

              ///mileage
              InkWell(
                onTap: () async {
                  await _fetchData('milage').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Mileage',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: mileageController,
                  hintText: 'Select mileage',
                  type: TextInputType.number,
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "mileage field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),

              ///gearbox
              InkWell(
                onTap: () async {
                  await _fetchData('gearbox').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Gearbox',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: gearBoxController,
                  hintText: 'Select gearbox',
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "gearbox field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(height: height * 0.025),

              ///color
              InkWell(
                onTap: () async {
                  await _fetchData('color').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Colour',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: colorController,
                  hintText: 'Select colour',
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "colour field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(height: height * 0.025),

              ///doors
              InkWell(
                onTap: () async {
                  await _fetchData('doors').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Doors',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: doorsController,
                  hintText: 'Select doors',
                  type: TextInputType.number,
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "doors field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),

              ///seats
              InkWell(
                onTap: () async {
                  await _fetchData('seats').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Seats',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: seatsController,
                  hintText: 'Select seats',
                  type: TextInputType.number,
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "seats field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),

              ///tax
              InkWell(
                onTap: () async {
                  await _fetchData('tax').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Tax',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: taxController,
                  hintText: 'Select tax',
                  type: TextInputType.number,
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "tax field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),

              ///insurance
              InkWell(
                onTap: () async {
                  await _fetchData('insurance').then((value) {
                    selectChoice(
                        size: MediaQuery.sizeOf(context),
                        title: 'Insurance',
                        list: value);
                  });
                },
                child: TextFieldWidget(
                  controller: insuranceController,
                  hintText: 'Select insurance',
                  type: TextInputType.number,
                  suffixIcon: Icons.keyboard_arrow_right,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "insurance field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),

              ButtonWidget(
                  text: 'Continue',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.sellCarModel.auto!
                          ? navigateToDescription()
                          : Navigation().push(
                              AddPhoto(sellCarModel: widget.sellCarModel),
                              context);
                    }
                  }),
              SizedBox(
                height: height * 0.012,
              ),
              ButtonWidget(
                  text: 'Back',
                  onTap: () {
                    Navigation().pop(context);
                  }),
              SizedBox(
                height: height * 0.015,
              )
            ],
          ),
        ),
      ),
    );
  }

  navigateToDescription() {
    widget.sellCarModel.colour = colorController.text;
    Navigation().push(
      DescriptionScreen(sellCarModel: widget.sellCarModel),
      context,
    );
  }
}
