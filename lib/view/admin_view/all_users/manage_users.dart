import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/button_widget.dart';
import 'package:maintenance/res/common_widgets/popup.dart';
import 'package:maintenance/res/common_widgets/text_field_widget.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/admin_view/all_users/manage_profile_widget.dart';
import 'package:maintenance/view/admin_view/all_users/view_services/view_services.dart';
import 'package:maintenance/view/login_signup/text_data_widget.dart';

class ManageUsers extends StatefulWidget {
  final Map profile;
  final bool isUser;
  const ManageUsers({super.key, required this.profile, required this.isUser});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  bool loading = false;
  Future<DateTime?> selectDateTime(BuildContext context) => showDatePicker(
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
    roleController.text = widget.profile['role'];
    statusController.text = widget.profile['status'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  popup(
                      context: context,
                      text: "Are You Sure To Delete Account",
                      onTap: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.profile['id'])
                              .delete();
                          Navigator.pop(context);
                        } catch (e) {
                          FlushBarUtils.flushBar(
                              e.toString(), context, "Error");
                        }
                        Navigator.pop(context, true);
                      },
                      buttonText: "Delete");
                },
                icon: const Icon(Icons.delete)),
            SizedBox(
              width: width * 0.02,
            )
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ManageProfileWidget(
                  name: nameController.text,
                  image: widget.profile['profile_image'],
                  pickedImage: image,
                  location: widget.profile['address']),
              SizedBox(
                height: height * 0.02,
              ),
              const TextDataWidget(text: 'Name'),
              TextFieldWidget(
                type: TextInputType.name,
                controller: nameController,
                hintText: 'Usama Ahmad',
                enable: false,
                prefixIcon: Icons.person,
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
                hintText: 'admin@gmail.com',
                prefixIcon: Icons.person,
                enable: false,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TextDataWidget(text: 'Phone'),
              TextFieldWidget(
                controller: phoneController,
                hintText: '+92 3113829383',
                prefixIcon: Icons.contacts,
                enable: false,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TextDataWidget(text: 'Date of Birth'),
              TextFieldWidget(
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
              SizedBox(
                height: height * 0.01,
              ),
              const TextDataWidget(text: 'Role'),
              TextFieldWidget(
                controller: roleController,
                hintText: 'Role',
                prefixIcon: Icons.person,
                enable: false,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TextDataWidget(text: 'Account Status'),
              TextFieldWidget(
                controller: statusController,
                hintText: 'Account Status',
                prefixIcon: Icons.person,
                enable: false,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                  child: ButtonWidget(
                      text: widget.profile['status'] == 'active'
                          ? 'Suspend Account'
                          : "Activate Account",
                      onTap: () {
                        popup(
                            context: context,
                            text:
                                "Are you sure to ${widget.profile['status'] == 'active' ? 'Suspend' : "Activate"} Account",
                            onTap: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.profile['id'])
                                    .update({
                                  'status': widget.profile['status'] == 'active'
                                      ? 'suspend'
                                      : "active",
                                });
                                Navigator.pop(context);
                              } catch (e) {
                                FlushBarUtils.flushBar(
                                    e.toString(), context, "Error");
                              }
                              Navigator.pop(context, true);
                            },
                            buttonText: widget.profile['status'] == 'active'
                                ? "Suspend"
                                : "Activate");
                      },
                      loading: loading)),
              SizedBox(
                height: height * 0.01,
              ),
              widget.isUser
                  ? const SizedBox.shrink()
                  : Center(
                      child: ButtonWidget(
                          text: 'View Services',
                          onTap: () {
                            Navigation().push(
                                ViewServices(
                                  profile: widget.profile,
                                ),
                                context);
                          },
                          loading: loading)),
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ));
  }
}
