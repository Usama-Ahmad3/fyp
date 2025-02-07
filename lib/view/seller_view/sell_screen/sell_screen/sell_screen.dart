import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/button_widget.dart';
import 'package:maintenance/res/common_widgets/text_field_widget.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/login_signup/text_data_widget.dart';
import 'package:maintenance/view/seller_view/main_bottom_bar_seller.dart';
import 'package:maintenance/view/seller_view/sell_screen/add_photo/add_photo.dart';
import 'package:maintenance/view/seller_view/sell_screen/app_bar_widget.dart';

import 'map_screen/map_screen.dart';

class AddService extends StatefulWidget {
  final Map? details;
  const AddService({super.key, this.details});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final sellerTypeController = TextEditingController();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();
  final categoryController = TextEditingController();
  List categories = [];
  List categoriesIds = [];
  List sellerType = ['Dealership Seller', 'Private Seller'];
  String latitude = '';
  String longitude = '';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
                            if (title == 'Category') {
                              categoryController.text = list[index];
                            } else {
                              sellerTypeController.text = list[index];
                            }
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.003),
                            child: Container(
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

  getCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    for (var element in snapshot.docs) {
      categories.add(element['name']);
      categoriesIds.add(element['id']);
    }
  }

  getEditData() {
    nameController.text = widget.details?['company_name'];
    sellerTypeController.text = widget.details?['seller_type'];
    locationController.text = widget.details?['location'];
    categoryController.text = widget.details?['category'];
    descriptionController.text = widget.details?['description'];
    noteController.text = widget.details?['note'];
    latitude = widget.details?['latitude'];
    longitude = widget.details?['longitude'];
  }

  @override
  void initState() {
    if (kDebugMode) {
      print('In the Sell Screen');
    }
    widget.details != null ? getEditData() : null;
    getCategories();
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
            canBack: widget.details != null,
            size: MediaQuery.sizeOf(context),
            color1: AppColors.grey,
            title: widget.details != null ? "Edit your ad" : 'Create a new ad',
          ),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),

                  ///name
                  const TextDataWidget(text: 'Company Name'),
                  TextFieldWidget(
                    controller: nameController,
                    hintText: 'Enter your Company name',
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return "company name field can't empty";
                      }
                      return null;
                    },
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.034),
                        borderSide: BorderSide(color: AppColors.white)),
                  ),
                  SizedBox(height: height * 0.025),

                  ///sellerType
                  const TextDataWidget(text: 'Seller Type'),
                  InkWell(
                    onTap: () async {
                      selectChoice(
                          size: MediaQuery.sizeOf(context),
                          title: "Seller",
                          list: sellerType);
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
                  SizedBox(height: height * 0.025),

                  ///location
                  const TextDataWidget(text: 'Location'),
                  InkWell(
                    onTap: () {
                      Navigation().push(
                          MapScreen(
                            location: locationController,
                            onTap: (LatLng latLng) {
                              latitude = latLng.latitude.toString();
                              longitude = latLng.longitude.toString();
                            },
                          ),
                          context);
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
                  SizedBox(height: height * 0.025),

                  ///Category
                  const TextDataWidget(text: 'Category'),
                  InkWell(
                    onTap: () {
                      selectChoice(
                          size: MediaQuery.sizeOf(context),
                          title: "Category",
                          list: categories);
                    },
                    child: TextFieldWidget(
                      controller: categoryController,
                      hintText: 'Select Category',
                      suffixIcon: Icons.keyboard_arrow_right,
                      enable: false,
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return "category field can't empty";
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
                  const TextDataWidget(text: 'Description'),
                  InkWell(
                    child: TextFieldMultiWidget(
                      controller: descriptionController,
                      hintText: 'Enter description',
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return "description field can't empty";
                        }
                        return null;
                      },
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(height * 0.034),
                          borderSide: BorderSide(color: AppColors.white)),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  ///Note
                  const TextDataWidget(text: 'Special Note'),
                  InkWell(
                    child: TextFieldMultiWidget(
                      controller: noteController,
                      hintText: 'Write a special note for service seeker',
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return "special note field can't empty";
                        }
                        return null;
                      },
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(height * 0.034),
                          borderSide: BorderSide(color: AppColors.white)),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Center(
                    child: ButtonWidget(
                        text: 'Continue',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            final selectedCategoryIndex = categories.indexWhere(
                                (element) =>
                                    element == categoryController.text);
                            final detail = {
                              "company_name": nameController.text,
                              "seller_type": sellerTypeController.text,
                              "description": descriptionController.text,
                              'note': noteController.text,
                              "location": locationController.text,
                              'latitude': latitude,
                              'longitude': longitude,
                              "category": categoryController.text,
                              "category_id":
                                  categoriesIds[selectedCategoryIndex],
                            };
                            int docId = -1;
                            if (widget.details != null &&
                                (widget.details!['category'] !=
                                    categoryController.text)) {
                              docId = categories.indexWhere(
                                (element) =>
                                    element == widget.details!['category'],
                              );
                              if (docId != -1 &&
                                  widget.details!['id'] != null) {
                                Navigation().push(
                                    AddPhoto(
                                      detail: detail,
                                      categoryId: categoriesIds[docId],
                                      serviceId: widget.details?['id'],
                                      images: widget.details?['images'],
                                    ),
                                    context);
                              }
                            } else if (widget.details != null) {
                              Navigation().push(
                                  AddPhoto(
                                    detail: detail,
                                    images: widget.details?['images'],
                                  ),
                                  context);
                            } else {
                              Navigation().push(
                                  AddPhoto(
                                    detail: detail,
                                  ),
                                  context);
                            }
                          }
                        }),
                  ),
                  widget.details != null
                      ? SizedBox(
                          height: height * 0.02,
                        )
                      : const SizedBox.shrink(),
                  widget.details != null
                      ? Center(
                          child: ButtonWidget(
                              text: 'Delete',
                              loading: isLoading,
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final docId = categories.indexWhere(
                                  (element) =>
                                      element == widget.details!['category'],
                                );
                                final snapshot = await FirebaseFirestore
                                    .instance
                                    .collection('categories')
                                    .doc(categoriesIds[docId])
                                    .collection('services')
                                    .where('id',
                                        isEqualTo: widget.details!['id'])
                                    .get();
                                for (QueryDocumentSnapshot doc
                                    in snapshot.docs) {
                                  for (var i in doc['images']) {
                                    await FirebaseStorage.instance
                                        .refFromURL(i)
                                        .delete();
                                  }
                                  await doc.reference.delete();
                                }
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                setState(() {
                                  isLoading = false;
                                });
                                Navigation().pushRep(
                                    MainBottomBarSeller(
                                      index: 0,
                                    ),
                                    context);
                              }),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                    height: height * 0.034,
                  )
                ],
              ),
            )));
  }
}
