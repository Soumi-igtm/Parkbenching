import 'dart:async';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../routes/routes.dart';
import '../view/constant/color.dart';
import '../view/constant/common.dart';
import '../view/constant/images.dart';
import '../view/widget/my_text.dart';

class RateParkBenchController extends GetxController {
  String? uid = Get.parameters["uid"];
  final formKey = GlobalKey<FormState>();
  final Completer<GoogleMapController> mapController = Completer();
  final box = GetStorage();
  late Geoflutterfire geo;
  late GeoFirePoint centerPoint;
  late Stream<List<DocumentSnapshot>> stream;
  List<MarkerData> markers = <MarkerData>[];
  final radius = BehaviorSubject<double>.seeded(20.0);
  final CameraPosition googleLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  String bid = "";
  double selectedRating = 0.0;
  LatLng currentPosition = const LatLng(0.0, 0.0);

  final TextEditingController benchLocationController = TextEditingController(), reviewController = TextEditingController();

  @override
  void onInit() {
    geo = Geoflutterfire();
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
    centerPoint = geo.point(latitude: userLocation["latitude"], longitude: userLocation["longitude"]);
    stream = radius.switchMap((rad) {
      final collectionReference = FirebaseFirestore.instance.collection("benches");

      return geo.collection(collectionRef: collectionReference).within(center: centerPoint, radius: rad, field: 'location', strictMode: true);
    });
    stream.listen((List<DocumentSnapshot> documentList) {
      updateMarkers(documentList);
    });
  }

  void updateMarkers(List<DocumentSnapshot> documentList) {
    List<MarkerData> temp = [];
    for (var document in documentList) {
      final benchID = document.id;
      final GeoPoint point = document['location']['geopoint'];
      temp.add(
        MarkerData(
            marker: Marker(
                markerId: MarkerId(benchID),
                position: LatLng(point.latitude, point.longitude),
                onTap: () {
                  bid = benchID;
                  benchLocationController.text = "${point.latitude},${point.longitude}";
                }),
            child: Image.asset(kMapPin, width: 40)),
      );
    }
    markers.addAll(temp);
    update();
  }

  submitRate(BuildContext context) async {
    if (benchLocationController.text.isEmpty) {
      customToast("Select a bench first");
      return;
    }

    customToast("Please wait...");
    await benchesCollection.doc(bid).collection("reviews").add({
      "uid": uid!,
      "review": reviewController.text,
      "reviewDate": DateTime.now(),
      "rating": selectedRating,
    }).then((value) async {
      await benchesCollection.doc(bid).update({
        "rating": FieldValue.increment(selectedRating),
        "ratingCount": FieldValue.increment(1),
      });
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: () => Future.value(false),
        title: "Review added",
        titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        content: MyText(text: "Thanks for reviewing this bench"),
        confirm: ElevatedButton(
            onPressed: () => Get.offNamed(AppLinks.bottomNavBar, parameters: {"uid": uid!}),
            style: ElevatedButton.styleFrom(primary: kTertiaryColor),
            child: MyText(
              text: "Close",
              weight: FontWeight.bold,
              color: kWhiteColor,
            )),
      );
    });
  }

  @override
  void onClose() {
    benchLocationController.dispose();
    reviewController.dispose();
    super.onClose();
  }
}
