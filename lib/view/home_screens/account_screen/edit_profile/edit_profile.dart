import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizmo/models/get_profile.dart';
import 'package:wizmo/res/app_urls/app_urls.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/button_widget.dart';
import 'package:wizmo/res/common_widgets/text_field_widget.dart';
import 'package:wizmo/view/home_screens/account_screen/edit_profile/edit_profile_provider.dart';
import 'package:wizmo/view/home_screens/account_screen/edit_profile/edit_profile_widget.dart';
import 'package:wizmo/view/login_signup/widgets/text_data.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    final getProfile = Provider.of<EditProfileProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditProfileWidget(
                          name: 'widget.profile.name.toString()',
                          onTap: () {
                            value.imagePicker(
                                context: context, provider: value);
                          },
                          image: 'assets/images/profile.png',
                          pickedImage: value.image,
                          location: 'widget.profile.address.toString()'),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const TextData(text: 'Name'),
                      TextFieldWidget(
                        controller: value.nameController,
                        hintText: 'Usama Ahmad',
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
                        controller: value.emailController,
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
                        controller: value.phoneController,
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
                          final date = await value.slecteDtateTime(context);
                          if (date != null) {
                            value.dobController.text =
                                value.formatter.format(date).toString();
                          }
                        },
                        child: TextFieldWidget(
                          controller: value.dobController,
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
                              borderRadius:
                                  BorderRadius.circular(height * 0.034),
                              borderSide: BorderSide(color: AppColors.white)),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Center(
                          child: ButtonWidget(
                              text: 'Update',
                              onTap: () {
                                Map detailImage = {
                                  'name': value.nameController.text,
                                  'email': value.emailController.text,
                                  'address': 'widget.profile.address',
                                  'phone_number': value.phoneController.text,
                                  'date_of_birth': value.dobController.text,
                                };
                                Map detail = {
                                  'profile_image': value.image,
                                  'name': value.nameController.text,
                                  'email': value.emailController.text,
                                  'address': 'widget.profile.address',
                                  'phone_number': value.phoneController.text,
                                  'date_of_birth': value.dobController.text,
                                  'listFile': false
                                };
                                value.updateProfile(
                                    detail: value.image != null
                                        ? detail
                                        : detailImage,
                                    url:
                                        '${AppUrls.baseUrl}${AppUrls.updateProfile}',
                                    context: context);
                              },
                              loading: value.loading)),
                      SizedBox(
                        height: height * 0.03,
                      )
                    ],
                  );
                })));
  }
}
