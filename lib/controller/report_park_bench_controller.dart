import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/color.dart';

import '../view/constant/common.dart';
import '../view/constant/images.dart';
import '../view/widget/my_text.dart';

class ReportParkBenchController extends GetxController {
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
  final TextEditingController benchLocationController = TextEditingController(), descriptionController = TextEditingController();

  LatLng currentPosition = const LatLng(0.0, 0.0);
  RxList photos = [].obs;
  String bid = "";

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

  submitReport(BuildContext context) async {
    if (benchLocationController.text.isEmpty) {
      customToast("Select a bench first");
      return;
    }
    if (photos.isEmpty) {
      customToast("Add at least one image");
      return;
    }
    customToast("Please wait...");

    await reportsCollection.add({
      "uid": uid!,
      "benchID": bid,
      "benchLocation": benchLocationController.text,
      "description": descriptionController.text,
      "images": [],
      "resolved": false,
      "reportDate": DateTime.now(),
      "resolveDate": null,
    }).then((value) async {
      List photosUrl = [];

      for (var photo in photos) {
        try {
          String ext2 = photo.split(".").last;
          TaskSnapshot _pSnapshot =
              await FirebaseStorage.instance.ref('reports/$bid/photo_${DateTime.now().millisecondsSinceEpoch}.$ext2').putFile(File(photo));
          photosUrl.add(await _pSnapshot.ref.getDownloadURL());
        } on FirebaseException catch (e) {
          customToast(e.toString());
        }
      }

      await reportsCollection.doc(value.id).update({"images": photosUrl});
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: () => Future.value(false),
        title: "Reported",
        titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        content: MyText(text: "Thanks for reporting this bench. We will get the issue resolved quickly"),
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

  Future pickImage({bool fromGallery = false}) async {
    try {
      final image = await ImagePicker().pickImage(source: fromGallery ? ImageSource.gallery : ImageSource.camera);

      if (image == null) return;

      photos.add(image.path);
    } on PlatformException catch (e) {
      customToast("Failed to pick image");
    }
  }

  @override
  void onClose() {
    radius.close();
    benchLocationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
