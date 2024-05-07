import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:wizmo/models/dynamic_car_detail_model.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/utils/flushbar.dart';
import 'package:wizmo/view/home_screens/home_screen/car_detail_screen/car_detail_provider.dart';
import 'package:wizmo/view/home_screens/home_screen/car_detail_screen/car_detail_screen.dart';

class ProfileCarDetail extends StatefulWidget {
  final DynamicCarDetailModel profile;
  bool auth;
  ProfileCarDetail({super.key, required this.profile, this.auth = false});

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
                                .headline3!
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
        height: height * 0.09,
        width: MediaQuery.of(context).size.width,
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
            leading: CircleAvatar(
              radius: height * 0.023,
              backgroundImage: const AssetImage('assets/images/profile.jpeg'),
            ),
            title: Text(
              widget.profile.sellerName.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              widget.profile.location.toString().length > 40
                  ? widget.profile.location.toString().substring(0, 40)
                  : widget.profile.location.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: InkWell(
              onTap: () {
                widget.auth
                    ? openMapSheet(context, widget.profile.longitude,
                        widget.profile.latitude, widget.profile.location)
                    : DetailScreenState.popupDialog(
                        context: context,
                        text: 'Login required',
                        buttonText: 'Login');
              },
              child: Text(
                "Direction",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )),
      ),
    );
  }
}
