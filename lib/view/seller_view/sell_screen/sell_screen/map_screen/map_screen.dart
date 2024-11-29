import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/button_widget.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/navigator_class.dart';

class MapScreen extends StatefulWidget {
  final TextEditingController location;
  final Function(LatLng) onTap;
  const MapScreen({super.key, required this.location, required this.onTap});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double lat = 0.0;
  double long = 0.0;
  List<Marker> allMarkers = [];
  GoogleMapController? mapController;
  bool loading = true;
  getLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      print('Temporary');
      await Geolocator.openLocationSettings();
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.requestPermission();
      print('Permanent');
    } else {
      await defaultLocation();
    }
  }

  defaultLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) async {
      long = value.longitude;
      lat = value.latitude;
      widget.onTap(LatLng(value.latitude, value.longitude));
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      print(placemarks);
      widget.location.text =
          '${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}';
    });
    addMarker();
    setState(() {
      loading = false;
    });
  }

  addMarker() {
    allMarkers.clear();
    allMarkers.add(Marker(
      markerId: const MarkerId('myMarker'),
      draggable: false,
      onTap: () {
        debugPrint('marker');
      },
      position: LatLng(lat, long),
    ));
  }

  @override
  void initState() {
    getLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                        liteModeEnabled: true,
                        onTap: (latLng) async {
                          try {
                            widget.onTap(latLng);
                            allMarkers.add(Marker(
                              markerId: const MarkerId('myMarker'),
                              draggable: false,
                              onTap: () {
                                debugPrint('marker');
                              },
                              position:
                                  LatLng(latLng.latitude, latLng.longitude),
                            ));
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(lat, long);
                            print(placemarks);
                            widget.location.text =
                                '${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}';
                            setState(() {});
                          } catch (e) {
                            FlushBarUtils.flushBar(
                                e.toString(), context, "Something went wrong");
                          }
                        },
                        compassEnabled: true,
                        mapType: MapType.normal,
                        buildingsEnabled: true,
                        indoorViewEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(lat, long), zoom: 15.0),
                        markers: Set.from(allMarkers),
                        // markers: _markers.values.toSet(),
                      ),
                Positioned(
                  top: height * 0.04,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: height * 0.01),
                        child: InkWell(
                            onTap: () {
                              Navigation().pop(context);
                            },
                            child: Container(
                                height: height * 0.04,
                                width: width * 0.13,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: height * 0.2,
            width: width,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    height: 8,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade300,
                      //color: Color(color),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  loading
                      ? const CircularProgressIndicator()
                      : Text(
                          widget.location.text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.black),
                        ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  ButtonWidget(
                      text: 'Continue',
                      onTap: () {
                        loading ? null : Navigation().pop(context);
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
