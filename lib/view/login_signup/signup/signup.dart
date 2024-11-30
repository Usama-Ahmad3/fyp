import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:maintenance/res/authentication/authentication.dart';
import 'package:maintenance/res/common_widgets/button_widget.dart';
import 'package:maintenance/res/common_widgets/cashed_image.dart';
import 'package:maintenance/res/common_widgets/text_field_widget.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/main_bottom_bar/main_bottom_bar.dart';
import 'package:maintenance/view/login_signup/login/login.dart';
import 'package:maintenance/view/login_signup/text_data_widget.dart';
import 'package:maintenance/view/seller_view/main_bottom_bar_seller.dart';

import '../../../res/colors/app_colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var contactController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var idCardController = TextEditingController();
  var dobController = TextEditingController();
  String? _role;
  final roleUser = ['User', "Seller"];
  bool _obscure = true;
  bool loading = false;
  File? _image;
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<DateTime?> slecteDtateTime(BuildContext context) => showDatePicker(
        context: context,
        // initialDate: DateTime(),
        firstDate: DateTime(DateTime.now().year - 60),
        lastDate: DateTime.now(),
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
  @override
  void initState() {
    print('In The Sign Up Screen');
    super.initState();
  }

  pickImageProviderUse(source) async {
    final XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      _image = File(file.path);
      setState(() {});
      print('picked');
    } else {
      print('Not Picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.04,
              ),
              cachedNetworkImage(
                  cuisineImageUrl:
                      'https://tse4.mm.bing.net/th?id=OIP.7jV8fIMTD6_D30jljYWUHgHaEZ&pid=Api&P=0&h=220',
                  height: height * 0.4,
                  imageFit: BoxFit.fill,
                  errorFit: BoxFit.contain,
                  width: width),
              Center(
                child: Text(
                  'Get started now',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.black),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TextDataWidget(text: 'Name'),
              TextFieldWidget(
                controller: nameController,
                hintText: 'Enter Your Name',
                prefixIcon: Icons.person,
                onTap: () {},
                onChanged: (value) {
                  // return provider.test();
                },
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
              const TextDataWidget(text: 'Email'),
              TextFieldWidget(
                controller: emailController,
                hintText: 'Enter Your Email',
                prefixIcon: Icons.email_outlined,
                onTap: () {},
                onChanged: (value) {
                  // return provider.test();
                },
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "email field can't be empty";
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
              const TextDataWidget(text: 'Password'),
              TextFieldWidget(
                controller: passwordController,
                hintText: 'Enter Your Password',
                prefixIcon: Icons.lock_open,
                suffixIcon: Icons.visibility,
                hideIcon: Icons.visibility_off,
                obscure: _obscure,
                passTap: () {
                  _obscure = !_obscure;
                  setState(() {});
                },
                onTap: () {},
                onChanged: (value) {
                  // return provider.test();
                },
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "password field can't be empty";
                  }
                  return null;
                },
                enableBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.035),
                    borderSide: BorderSide(color: AppColors.white)),
                focusBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TextDataWidget(text: 'Contact'),
              TextFieldWidget(
                controller: contactController,
                type: TextInputType.phone,
                hintText: 'Enter Contact Number',
                prefixIcon: Icons.contacts,
                onTap: () {},
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
              const TextDataWidget(text: 'Address'),
              TextFieldWidget(
                controller: addressController,
                hintText: 'Enter Your Address',
                prefixIcon: Icons.location_history_rounded,
                onTap: () {},
                onChanged: (value) {
                  // return provider.test();
                },
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "Address field can't be empty";
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
              const TextDataWidget(text: 'ID Card'),
              TextFieldWidget(
                controller: idCardController,
                hintText: 'Enter Your ID Card Number',
                prefixIcon: Icons.info_outline,
                onTap: () {},
                onChanged: (value) {
                  // return provider.test();
                },
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "ID field can't be empty";
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
              const TextDataWidget(text: 'Date of Birth'),
              InkWell(
                onTap: () async {
                  final date = await slecteDtateTime(context);
                  if (date != null) {
                    dobController.text = formatter.format(date).toString();
                  }
                },
                child: TextFieldWidget(
                  controller: dobController,
                  hintText: 'Enter Your Date of Birth',
                  prefixIcon: Icons.date_range,
                  enable: false,
                  onTap: () {},
                  onChanged: (value) {
                    // return provider.test();
                  },
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "DOB field can't be empty";
                    }
                    return null;
                  },
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(height * 0.034),
                      borderSide: BorderSide(color: AppColors.white)),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              const TextDataWidget(text: 'Role'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: DropdownButton<String>(
                  iconEnabledColor: const Color(0XFF9B9B9B),
                  focusColor: const Color(0XFF9B9B9B),
                  isExpanded: true,
                  value: _role,
                  hint: Text(
                    "Select Your Role",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  items: roleUser
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: AppColors.black),
                            ),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _role = value!;
                      print(value);
                    });
                  },
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Container(
                      height: height * 0.15,
                      width: width * 0.5,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.shadowColor.withOpacity(0.2),
                                offset: const Offset(1, 1),
                                blurStyle: BlurStyle.normal,
                                blurRadius: 12,
                                spreadRadius: 3)
                          ],
                          borderRadius: BorderRadius.circular(height * 0.02)),
                      child: InkWell(
                        onTap: () {
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
                                    backgroundColor:
                                        AppColors.shadowColor.withOpacity(0.1),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: height * 0.03,
                                        horizontal: width * 0.01),
                                    content: SizedBox(
                                      height: height * 0.14,
                                      child: Column(
                                        children: [
                                          ListTile(
                                              onTap: () {
                                                pickImageProviderUse(
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                              textColor: AppColors.white,
                                              trailing: Icon(Icons.collections,
                                                  color: AppColors.white),
                                              title: Text(
                                                'Pick From Gallery',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        color: AppColors.white),
                                              )),
                                          ListTile(
                                              onTap: () {
                                                pickImageProviderUse(
                                                    ImageSource.camera);
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
                                                    .copyWith(
                                                        color: AppColors.white),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(height * 0.02),
                                child: Image.file(
                                  _image!.absolute,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Icon(
                                Icons.add,
                                size: height * 0.09,
                                color: AppColors.grey,
                              ),
                      )),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                child: ButtonWidget(
                  text: 'Sign Up',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString())
                          .then((value) async {
                        setState(() {
                          loading = true;
                        });
                        final news =
                            FirebaseFirestore.instance.collection('users');
                        final id = FirebaseAuth.instance.currentUser!.uid;
                        final ref = firebase_storage.FirebaseStorage.instance
                            .ref('/profile/$id');
                        firebase_storage.UploadTask uploadTask =
                            ref.putFile(File(_image!.path));
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
                        news.doc(id).set({
                          'name': nameController.text,
                          'email': emailController.text,
                          'password': passwordController.text,
                          'address': addressController.text,
                          'phone_number': contactController.text,
                          'date_of_birth': dobController.text,
                          'id_card': idCardController.text,
                          'profile_image': url,
                          'id': id,
                          'status': _role == "User" ? "active" : 'pending',
                          'role': _role
                        });
                        await Authentication().saveLogin(true);

                        navigateToHomeScreen(_role == 'User');
                      }).onError((error, stackTrace) {
                        FlushBarUtils.flushBar(
                            error.toString(), context, "Error Catch");
                      });
                    }
                  },
                  loading: loading,
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.09),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'By signing up you accept the',
                          style: Theme.of(context).textTheme.bodyLarge),
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: 'Terms of Services',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: AppColors.buttonColor)),
                      TextSpan(
                          text: '\nand ',
                          style: Theme.of(context).textTheme.bodyLarge),
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: 'Privacy Policy',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: AppColors.buttonColor))
                    ])),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have account? ",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    InkWell(
                      onTap: () {
                        navigateToSignin();
                      },
                      child: Text(
                        "LogIn",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.red),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigateToSignin() {
    Navigation().pushRep(const LogIn(), context);
  }

  navigateToHomeScreen(bool isUser) {
    isUser
        ? Navigation().pushRep(MainBottomBar(), context)
        : Navigation().pushRep(
            MainBottomBarSeller(
              status: 'pending',
            ),
            context);
  }
}
