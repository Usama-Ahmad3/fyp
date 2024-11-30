import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maintenance/res/authentication/authentication.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/popup.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/home_screens/home_screen/home_widgets/category_container.dart';
import 'package:maintenance/view/home_screens/home_screen/specific_category_services/category_detail_screen/story_page.dart';
import 'package:maintenance/view/login_signup/login/login.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'widgets/profile_service_detail.dart';

class SpecificServiceDetailScreen extends StatefulWidget {
  final Map userData;
  final Map serviceData;
  final String categoryId;
  const SpecificServiceDetailScreen(
      {super.key,
      required this.userData,
      required this.serviceData,
      this.categoryId = ''});

  @override
  State<SpecificServiceDetailScreen> createState() => DetailScreenState();
}

class DetailScreenState extends State<SpecificServiceDetailScreen> {
  bool _isLogIn = false;
  bool loading = true;
  var isDialOpen = ValueNotifier<bool>(false);
  convertDate(DateTime created) {
    final time = DateFormat('dd MMMM yyyy \'at\' hh:mm a').format(
      DateTime(created.year, created.month, created.day, created.hour,
          created.minute, created.second),
    );
    return time;
  }

  Future<void> makePhoneCall(String url, context) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      FlushBarUtils.flushBar(e.toString(), context, 'Could not launch');
      print("Exception$e");
    }
  }

  Future<void> launchInBrowser(String url, context) async {
    try {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } catch (e) {
      FlushBarUtils.flushBar(e.toString(), context, 'Could not launch $url');
    }
  }

  static popupDialog(
      {required BuildContext context,
      required String text,
      required String buttonText}) {
    popup(
        context: context,
        text: text,
        onTap: () {
          Navigation().pushRep(const LogIn(), context);
        },
        buttonText: buttonText);
  }

  @override
  void initState() {
    checkAuth();
    print('In The Car Detail Screen');
    super.initState();
  }

  checkAuth() async {
    _isLogIn = await Authentication().getAuth();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Service Details',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.black),
              ),
              centerTitle: true,
            ),
            floatingActionButton: SpeedDial(
              elevation: 3,
              label: Text(
                widget.categoryId.isNotEmpty
                    ? "Action Options"
                    : 'Message Seller',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: AppColors.white),
              ),
              animationCurve: Curves.easeInOutCirc,
              backgroundColor: AppColors.buttonColor,
              openCloseDial: isDialOpen,
              animationDuration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutBack,
              mini: false,
              closeManually: false,
              isOpenOnStart: false,
              onPress: () {
                isDialOpen.value = !isDialOpen.value;
                setState(() {});
              },
              useRotationAnimation: true,
              childrenButtonSize: Size(width * 0.17, height * 0.065),
              childMargin: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.014),
              children: widget.categoryId.isNotEmpty
                  ? [
                      SpeedDialChild(
                          onTap: () async {
                            print("WhatsApp");
                            final link = WhatsAppUnilink(
                                text: 'hi! how are you',
                                phoneNumber: widget.userData['phone_number']);
                            _isLogIn
                                ? launchInBrowser("$link", context)
                                : popupDialog(
                                    context: context,
                                    text: 'Login required',
                                    buttonText: 'Login');
                          },
                          child: const Icon(
                            FontAwesomeIcons.whatsapp,
                          ),
                          label: 'WhatsApp',
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          elevation: 3),
                      SpeedDialChild(
                          onTap: () {
                            print("Email");
                            _isLogIn
                                ? launchInBrowser(
                                    'mailto:${widget.userData['email']}',
                                    context)
                                : popupDialog(
                                    context: context,
                                    text: 'Login required',
                                    buttonText: 'Login');
                          },
                          child: const Icon(
                            Icons.email_outlined,
                          ),
                          label: 'Email',
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          elevation: 3),
                      SpeedDialChild(
                          onTap: () {
                            print('phone');
                            _isLogIn
                                ? makePhoneCall(
                                    'tel: ${widget.userData['phone_number']}',
                                    context)
                                : popupDialog(
                                    context: context,
                                    text: 'Login required',
                                    buttonText: 'Login');
                          },
                          child: const Icon(
                            Icons.phone,
                          ),
                          label: 'Phone',
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          elevation: 3),
                      SpeedDialChild(
                          onTap: () {
                            popup(
                                context: context,
                                text: "Are You Sure To Delete Service",
                                onTap: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection("categories")
                                        .doc(widget.categoryId)
                                        .collection('services')
                                        .doc(widget.serviceData['id'])
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
                          child: const Icon(
                            Icons.delete,
                          ),
                          label: 'Delete Service',
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          elevation: 3)
                    ]
                  : [
                      SpeedDialChild(
                          onTap: () async {
                            print("WhatsApp");
                            final link = WhatsAppUnilink(
                                text: 'hi! how are you',
                                phoneNumber: widget.userData['phone_number']);
                            _isLogIn
                                ? launchInBrowser("$link", context)
                                : popupDialog(
                                    context: context,
                                    text: 'Login required',
                                    buttonText: 'Login');
                          },
                          child: const Icon(
                            FontAwesomeIcons.whatsapp,
                          ),
                          label: 'WhatsApp',
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          elevation: 3),
                      SpeedDialChild(
                          onTap: () {
                            print("Email");
                            _isLogIn
                                ? launchInBrowser(
                                    'mailto:${widget.userData['email']}',
                                    context)
                                : popupDialog(
                                    context: context,
                                    text: 'Login required',
                                    buttonText: 'Login');
                          },
                          child: const Icon(
                            Icons.email_outlined,
                          ),
                          label: 'Email',
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          elevation: 3),
                      SpeedDialChild(
                          onTap: () {
                            print('phone');
                            _isLogIn
                                ? makePhoneCall(
                                    'tel: ${widget.userData['phone_number']}',
                                    context)
                                : popupDialog(
                                    context: context,
                                    text: 'Login required',
                                    buttonText: 'Login');
                          },
                          child: const Icon(
                            Icons.phone,
                          ),
                          label: 'Phone',
                          labelStyle: Theme.of(context).textTheme.titleSmall,
                          elevation: 3),
                    ],
              activeChild: Icon(
                Icons.clear,
                color: AppColors.white,
                size: height * 0.03,
              ),
              child: Icon(
                widget.categoryId.isNotEmpty
                    ? Icons.menu
                    : Icons.messenger_outline,
                color: AppColors.white,
                size: height * 0.03,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryContainer(
                    onTap: () {
                      navigateToStory();
                    },
                    category: widget.serviceData['location'],
                    image: widget.serviceData['images'],
                    services: widget.serviceData['company_name'],
                    isCompany: true,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        widget.serviceData['description'],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppColors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Seller Message:',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: ReadMoreText(
                      widget.serviceData['note'],
                      trimLength: 2,
                      trimMode: TrimMode.Line,
                      lessStyle: TextStyle(
                          color: AppColors.black, fontWeight: FontWeight.bold),
                      moreStyle: TextStyle(
                          color: AppColors.black, fontWeight: FontWeight.bold),
                      trimCollapsedText: 'See More',
                      trimExpandedText: 'See Less',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: AppColors.black),
                    ),
                  ),
                  widget.categoryId.isNotEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  'Created At:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: AppColors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  convertDate(widget.serviceData['created_at']
                                      .toDate()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: AppColors.black),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'About This Seller',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppColors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        widget.serviceData['seller_type'],
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  ProfileServiceDetail(
                    profile: widget.userData,
                    serviceData: widget.serviceData,
                    auth: _isLogIn,
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                ],
              ),
            ),
          );
  }

  navigateToStory() {
    Navigation()
        .push(StoryPage(files: widget.serviceData['images'].toList()), context);
  }
}
