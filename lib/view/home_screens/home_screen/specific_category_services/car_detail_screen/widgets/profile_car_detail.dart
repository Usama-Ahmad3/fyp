import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maintenance/view/home_screens/home_screen/specific_category_services/car_detail_screen/category_detail.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:maintenance/models/dynamic_car_detail_model.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/utils/flushbar.dart';

class ProfileCarDetail extends StatefulWidget {
  final Map profile;
  final Map serviceData;
  bool auth;
  ProfileCarDetail(
      {super.key,
      required this.profile,
      this.auth = false,
      required this.serviceData});

  @override
  State<ProfileCarDetail> createState() => _ProfileCarDetailState();
}

class _ProfileCarDetailState extends State<ProfileCarDetail> {
  openMapSheet(context, longitude, latitude, location) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      showBottomSheet(
          context: context,
          backgroundColor: AppColors.buttonColor,
          enableDrag: true,
          builder: (context) {
            return SingleChildScrollView(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      for (var map in availableMaps)
                        ListTile(
                          onTap: () => map.showMarker(
                            coords: Coords(double.parse(longitude),
                                double.parse(latitude)),
                            title: location,
                          ),
                          title: Text(
                            map.mapName,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: AppColors.white),
                          ),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          });
    } catch (e) {
      print(e);
      FlushBarUtils.flushBar('Error While Opening Map', context, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.17),
                blurStyle: BlurStyle.normal,
                offset: const Offset(1, 1),
                blurRadius: 12,
                spreadRadius: 2)
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            leading: widget.profile['profile_image'] != null
                ? CircleAvatar(
                    radius: height * 0.023,
                    backgroundImage:
                        NetworkImage(widget.profile['profile_image']))
                : CircleAvatar(
                    radius: height * 0.023,
                    backgroundImage:
                        const AssetImage('assets/images/profile.jpeg'),
                  ),
            title: Text(
              widget.profile['name'],
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.black),
            ),
            subtitle: Text(
              widget.serviceData['location'].toString().length > 40
                  ? widget.serviceData['location'].toString().substring(0, 40)
                  : widget.serviceData['location'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: InkWell(
              onTap: () {
                widget.auth
                    ? openMapSheet(
                        context,
                        widget.serviceData['longitude'],
                        widget.serviceData['latitude'],
                        widget.serviceData['location'])
                    : DetailScreenState.popupDialog(
                        context: context,
                        text: 'Login required',
                        buttonText: 'Login');
              },
              child: Text(
                "Direction",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.black),
              ),
            )),
      ),
    );
  }
}
