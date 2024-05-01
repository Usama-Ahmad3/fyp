import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/button_widget.dart';
import 'package:wizmo/res/common_widgets/text_field_widget.dart';
import 'package:wizmo/utils/flushbar.dart';
import 'package:wizmo/view/home_screens/account_screen/edit_profile/edit_profile_widget.dart';
import 'package:wizmo/view/login_signup/widgets/text_data.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfile extends StatefulWidget {
  final Map profile;
  const EditProfile({super.key, required this.profile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool loading = false;
  Future<DateTime?> slecteDtateTime(BuildContext context) => showDatePicker(
        context: context,
        // initialDate: DateTime(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(primary: AppColors.buttonColor),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );
  final DateFormat formatter = DateFormat('dd-MM-yyyy', 'en_US');
  File? image;
  pickImageProviderUse(source) async {
    final XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      image = File(file.path);
      setState(() {});
      print('picked');
    } else {
      print('Not Picked');
    }
  }

  @override
  void initState() {
    nameController.text = widget.profile['name'];
    emailController.text = widget.profile['email'];
    phoneController.text = widget.profile['phone_number'];
    dobController.text = widget.profile['date_of_birth'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileWidget(
                  name: nameController.text,
                  onTap: () {
                    pickImageProviderUse(ImageSource.camera);
                  },
                  image: widget.profile['profile_image'],
                  pickedImage: image,
                  location: widget.profile['address']),
              SizedBox(
                height: height * 0.02,
              ),
              const TextData(text: 'Name'),
              TextFieldWidget(
                type: TextInputType.name,
                controller: nameController,
                hintText: 'Usama Ahmad',
                enable: true,
                prefixIcon: Icons.person,
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "email field can't empty";
                  }
                  return null;
                },
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TextData(text: 'Email'),
              TextFieldWidget(
                controller: emailController,
                hintText: 'admin@gmail.com',
                prefixIcon: Icons.person,
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "email field can't empty";
                  }
                  return null;
                },
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TextData(text: 'Phone'),
              TextFieldWidget(
                controller: phoneController,
                hintText: '+92 3113829383',
                prefixIcon: Icons.contacts,
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "Contact field can't be empty";
                  }
                  return null;
                },
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TextData(text: 'Date of Birth'),
              InkWell(
                onTap: () async {
                  final date = await slecteDtateTime(context);
                  if (date != null) {
                    dobController.text = formatter.format(date).toString();
                  }
                },
                child: TextFieldWidget(
                  controller: dobController,
                  hintText: 'Date of Birth',
                  prefixIcon: Icons.calendar_month,
                  enable: false,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "Date of Birth field can't empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Center(
                  child: ButtonWidget(
                      text: 'Update',
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        final id = FirebaseAuth.instance.currentUser!.uid;
                        final ref = firebase_storage.FirebaseStorage.instance
                            .ref('/profile/$id');
                        if (image != null) {
                          firebase_storage.UploadTask uploadTask =
                              ref.putFile(File(image!.path));
                          await Future.value(uploadTask)
                              .then((value) {})
                              .onError((error, stackTrace) {
                            FlushBarUtils.flushBar(
                                error.toString(), context, "Error");
                          });
                        }
                        print(nameController.text);
                        final url = await ref.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(id)
                            .update(image != null
                                ? {
                                    'name': nameController.text.toString(),
                                    'email': emailController.text.toString(),
                                    'phone_number':
                                        phoneController.text.toString(),
                                    'date_of_birth':
                                        dobController.text.toString(),
                                    'profile_image': url,
                                  }
                                : {
                                    'name': nameController.text.toString(),
                                    'email': emailController.text.toString(),
                                    'phone_number':
                                        phoneController.text.toString(),
                                    'date_of_birth':
                                        dobController.text.toString(),
                                  })
                            .then((value) {
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context);
                          FlushBarUtils.flushBar("Successfully Update Profile",
                              context, "Success");
                        }).onError((error, stackTrace) {
                          FlushBarUtils.flushBar(
                              error.toString(), context, "Error");
                        });
                      },
                      loading: loading)),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ));
  }
}
