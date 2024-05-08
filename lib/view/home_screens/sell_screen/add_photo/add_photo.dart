import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wizmo/models/sell_car_model.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/button_widget.dart';
import 'package:wizmo/utils/flushbar.dart';
import 'package:wizmo/view/home_screens/sell_screen/app_bar_widget.dart';

class AddPhoto extends StatefulWidget {
  final SellCarModel sellCarModel;
  const AddPhoto({super.key, required this.sellCarModel});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  List<File>? image = [];
  pickImage(source) async {
    final XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      image!.add(File(file.path));
      setState(() {});
      print('picked');
    } else {
      print('Not Picked');
    }
  }

  cameraChoicePicker(size) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Choice',
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
          height: size.height * 0.15,
          child: Column(
            children: [
              ListTile(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  textColor: AppColors.white,
                  trailing: Icon(Icons.collections, color: AppColors.white),
                  title: Text(
                    'Pick From Gallery',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: AppColors.white),
                  )),
              ListTile(
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  trailing: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.white,
                  ),
                  title: Text(
                    'Capture From Camera',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: AppColors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  removeImage(int index) {
    image!.removeAt(index);
    setState(() {});
  }

  @override
  void initState() {
    if (kDebugMode) {
      print('In The Add Photo');
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
          title: 'Add photo',
          size: MediaQuery.sizeOf(context),
          color1: AppColors.buttonColor,
          color2: AppColors.buttonColor,
          color3: AppColors.buttonColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Stack(
                children: [
                  SizedBox(
                    height: height * 0.83,
                    width: width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              ...List.generate(
                                  image!.isNotEmpty ? image!.length + 1 : 1,
                                  (index) => index == 0
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.01),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: height * 0.17,
                                                width: width * 0.43,
                                              ),
                                              Positioned(
                                                top: height * 0.015,
                                                left: 0,
                                                child: Container(
                                                    height: height * 0.15,
                                                    width: width * 0.41,
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .buttonColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: AppColors
                                                                  .shadowColor
                                                                  .withOpacity(
                                                                      0.17),
                                                              blurStyle:
                                                                  BlurStyle
                                                                      .normal,
                                                              offset:
                                                                  const Offset(
                                                                      1, 1),
                                                              blurRadius: 12,
                                                              spreadRadius: 2)
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    height *
                                                                        0.015)),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        cameraChoicePicker(
                                                            MediaQuery.sizeOf(
                                                                context));
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .camera_alt_rounded,
                                                        size: height * 0.08,
                                                        color: AppColors.white,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.01),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: height * 0.17,
                                                width: width * 0.41,
                                              ),
                                              Positioned(
                                                top: height * 0.015,
                                                left: 0,
                                                child: Container(
                                                    height: height * 0.15,
                                                    width: width * 0.38,
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: AppColors
                                                                  .shadowColor
                                                                  .withOpacity(
                                                                      0.17),
                                                              blurStyle:
                                                                  BlurStyle
                                                                      .normal,
                                                              offset:
                                                                  const Offset(
                                                                      1, 1),
                                                              blurRadius: 12,
                                                              spreadRadius: 2)
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    height *
                                                                        0.015)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              height * 0.015),
                                                      child: Image.file(
                                                          image![index - 1]
                                                              .absolute,
                                                          fit: BoxFit.fill),
                                                    )),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: InkWell(
                                                  onTap: () =>
                                                      removeImage(index - 1),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        AppColors.white,
                                                    radius: height * 0.02,
                                                    child: Icon(
                                                      FontAwesomeIcons.close,
                                                      color: AppColors.red,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: height * 0.093,
                      left: width * 0.075,
                      child: ButtonWidget(
                          text: 'Continue',
                          onTap: () {
                            if (image!.isNotEmpty) {
                              Map detail = {
                                'email': '',
                                'insurance': widget.sellCarModel.insurance,
                                'co2': widget.sellCarModel.co2,
                                'make': widget.sellCarModel.make,
                                'model': widget.sellCarModel.model,
                                'modelvariation': widget.sellCarModel.variation,
                                'year': widget.sellCarModel.year,
                                'mileage': widget.sellCarModel.mileage,
                                'bodytype': widget.sellCarModel.bodyType,
                                'fuletype': widget.sellCarModel.fuelType,
                                'enginesize': widget.sellCarModel.engineSize,
                                'enginepower': widget.sellCarModel.enginePower,
                                'fuelconsumption':
                                    widget.sellCarModel.consumption,
                                'acceleration':
                                    widget.sellCarModel.acceleration,
                                'gearboxe': widget.sellCarModel.gearBox,
                                'drivetrain': widget.sellCarModel.driveTrain,
                                'door': widget.sellCarModel.doors,
                                'seat': widget.sellCarModel.seats,
                                'description': widget.sellCarModel.description,
                                'sellertype': widget.sellCarModel.sellerType,
                                'tax': widget.sellCarModel.tax,
                                'location': widget.sellCarModel.location,
                                "color": widget.sellCarModel.colour,
                                'longitude': widget.sellCarModel.longitude,
                                'latitude': widget.sellCarModel.latitude,
                                'price': widget.sellCarModel.price,
                                'car_name': widget.sellCarModel.carName,
                                'co': widget.sellCarModel.co2,
                                'insurancegroup': widget.sellCarModel.insurance,
                                'image': image,
                                'rgistraion': widget.sellCarModel.registration,
                                'range': widget.sellCarModel.range,
                                'listFile': true
                              };
                              if (kDebugMode) {
                                print("SSSSSSSSSSSSSSSSSSSSS");
                                print(widget.sellCarModel.description);
                              }
                            } else {
                              FlushBarUtils.flushBar('Images are not added',
                                  context, 'Information');
                            }
                          })),
                  Positioned(
                      bottom: height * 0.014,
                      left: width * 0.075,
                      child: ButtonWidget(
                          text: 'Back',
                          onTap: () {
                            pop();
                          })),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  pop() {
    Navigator.pop(context);
  }
}
