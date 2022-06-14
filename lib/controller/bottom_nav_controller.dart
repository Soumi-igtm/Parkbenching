import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/common.dart';
import 'package:rxdart/rxdart.dart';
import '../view/constant/images.dart';

class BottomNavController extends GetxController {
  String? uid = Get.parameters["uid"];

  final box = GetStorage();
  late DocumentSnapshot userSnap;
  final Completer<GoogleMapController> mapController = Completer();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final radius = BehaviorSubject<double>.seeded(20.0);
  late Geoflutterfire geo;
  late GeoFirePoint centerPoint;
  late Stream<List<DocumentSnapshot>> stream;
  List<MarkerData> markers = <MarkerData>[];
  final CameraPosition googleLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void onInit() {
    fetchUser();
    geo = Geoflutterfire();
    Future.delayed(const Duration(milliseconds: 200), () {
      determinePosition();
    });
    super.onInit();
  }

  void fetchUser() async {
    userSnap = await usersCollection.doc(uid!).get();
    update();
  }

  void determinePosition() async {
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

    centerPoint = geo.point(latitude: data.latitude, longitude: data.longitude);
    stream = radius.switchMap((rad) {
      final collectionReference = FirebaseFirestore.instance.collection("benches");

      return geo.collection(collectionRef: collectionReference).within(center: centerPoint, radius: rad, field: 'location', strictMode: true);
    });
    stream.listen((List<DocumentSnapshot> documentList) {
      updateMarkers(documentList);
    });
    box.write("userLocation", {"latitude": data.latitude, "longitude": data.longitude});
  }

  void updateMarkers(List<DocumentSnapshot> documentList) {
    List<MarkerData> temp = [];
    for (var document in documentList) {
      final benchID = document.id;
      final GeoPoint point = document['location']['geopoint'];
      temp.add(
        MarkerData(
            marker: Marker(markerId: MarkerId(benchID), position: LatLng(point.latitude, point.longitude)), child: Image.asset(kMapPin, width: 40)),
      );
    }
    markers.addAll(temp);
    update();
  }

  @override
  void onClose() {
    radius.close();
    super.onClose();
  }
}
