import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_benching/view/constant/common.dart';

class BottomNavController extends GetxController {
  String? uid = Get.parameters["uid"];
  final box = GetStorage();
  late DocumentSnapshot userSnap;
  final Completer<GoogleMapController> mapController = Completer();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final CameraPosition googleLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void onInit() {
    fetchUser();
    Future.delayed(const Duration(milliseconds: 500), () {
      _determinePosition();
    });
    super.onInit();
  }

  void fetchUser() async {
    userSnap = await usersCollection.doc(uid!).get();
    update();
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // check for location permission
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //customSnackBarError('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      customToast('Location permissions are permanently denied, we cannot request permissions');
      return;
    }

    // get current user location
    Position data = await Geolocator.getCurrentPosition();

    // initialize google map controller
    final GoogleMapController googleMapController = await mapController.future;

    // animate map to current user location
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(data.latitude, data.longitude), zoom: 19.151926040649414),
      ),
    );
    box.write("userLocation", {"latitude": data.latitude, "longitude": data.longitude});
  }
}
