import 'dart:async';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SendLocationController extends GetxController{

  final Completer<GoogleMapController> mapController = Completer();
  final geo = Geoflutterfire();
  final box = GetStorage();


  final CameraPosition googleLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  LatLng currentPosition = const LatLng(0.0, 0.0);


  @override
  void onInit() {
    loadLocation();
    super.onInit();
  }

  loadLocation() async {
    Map userLocation = box.read("userLocation");
    final GoogleMapController googleMapController = await mapController.future;

    // animate map to current user location
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(userLocation["latitude"], userLocation["longitude"]), zoom: 19.151926040649414),
      ),
    );
  }

}