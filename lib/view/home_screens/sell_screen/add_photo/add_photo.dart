import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance/models/sell_car_model.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/button_widget.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/sell_screen/app_bar_widget.dart';
import 'package:maintenance/view/home_screens/sell_screen/congrats_screen/congrats_screen.dart';
import 'package:maintenance/view/login_signup/widgets/constants.dart';

class AddPhoto extends StatefulWidget {
  final SellCarModel sellCarModel;
  const AddPhoto({super.key, required this.sellCarModel});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  List<File>? image = [];
  bool loading = false;
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

  Future _fetchData(String id) async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic> userData = {};
    if (querySnapshot.exists) {
      userData = querySnapshot.data() as Map<String, dynamic>;
      print(userData);
    } else {
      print('Document does not exist');
    }
    return userData;
  }

  cameraChoicePicker(size) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Choice',
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
                        .titleSmall!
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
                        .titleSmall!
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
                          loading: loading,
                          onTap: () async {
                            if (image!.isNotEmpty) {
                              setState(() {
                                loading = true;
                              });
                              List imageLinks = [];
                              final cars =
                                  FirebaseFirestore.instance.collection('cars');
                              final id = FirebaseAuth.instance.currentUser!.uid;
                              Map<String, dynamic> profile =
                                  await _fetchData(id);
                              final ref = firebase_storage
                                  .FirebaseStorage.instance
                                  .ref('/cars/$id');
                              for (var imageIndex in image!) {
                                firebase_storage.UploadTask uploadTask =
                                    ref.putFile(File(imageIndex.path));
                                await Future.value(uploadTask).then((value) {
                                  loading = false;
                                  setState(() {});
                                }).onError((error, stackTrace) {
                                  loading = false;
                                  setState(() {});
                                  FlushBarUtils.flushBar(
                                      error.toString(), context, "Error");
                                });
                                final url = await ref.getDownloadURL();
                                imageLinks.add(url);
                              }
                              cars.doc().set({
                                'Description': widget.sellCarModel.description,
                                "Location": widget.sellCarModel.location,
                                "Price": widget.sellCarModel.price,
                                "Registration Number":
                                    widget.sellCarModel.registration,
                                'Seller Type': widget.sellCarModel.sellerType,
                                "address": profile['address'],
                                "email": profile["email"],
                                'id': id,
                                'images': imageLinks,
                                'isSaved': false,
                                "latitude": widget.sellCarModel.latitude,
                                "longitude": widget.sellCarModel.longitude,
                                "make": widget.sellCarModel.make,
                                "model": widget.sellCarModel.model,
                                "car_name": widget.sellCarModel.carName,
                                "name": profile['name'],
                                "phone_number": profile['phone_number'],
                                "profile_image": profile['profile_image'],
                                "features": featureNames,
                                "feature_values": [
                                  widget.sellCarModel.make,
                                  widget.sellCarModel.model,
                                  widget.sellCarModel.variation,
                                  widget.sellCarModel.year,
                                  widget.sellCarModel.bodyType,
                                  widget.sellCarModel.acceleration,
                                  widget.sellCarModel.driveTrain,
                                  widget.sellCarModel.co2,
                                  widget.sellCarModel.fuelType,
                                  widget.sellCarModel.consumption,
                                  widget.sellCarModel.engineSize,
                                  widget.sellCarModel.enginePower,
                                  widget.sellCarModel.mileage,
                                  widget.sellCarModel.gearBox,
                                  widget.sellCarModel.colour,
                                  widget.sellCarModel.doors,
                                  widget.sellCarModel.seats,
                                  widget.sellCarModel.tax,
                                  widget.sellCarModel.insurance,
                                ]
                              }).then((value) {
                                Navigation()
                                    .pushRep(const CongratsScreen(), context);
                              });
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
