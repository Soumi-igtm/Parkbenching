import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/color.dart';

import '../view/constant/common.dart';
import '../view/widget/my_text.dart';

class RateParkBenchController extends GetxController {
  String? uid = Get.parameters["uid"];
  final formKey = GlobalKey<FormState>();
  final Completer<GoogleMapController> mapController = Completer();
  final box = GetStorage();

  final CameraPosition googleLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String cleanliness = "Clean", position = "Park", view = "Wonderful";
  List reachability = ["Bicycle"], equipment = ["Several benches"];
  LatLng currentPosition = const LatLng(0.0, 0.0);
  RxList photos = [].obs;

  final TextEditingController benchNameController = TextEditingController();

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

  submitRating(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    customToast("Please wait...");
    await benchesCollection.add({
      "benchName": benchNameController.text,
      "uid": uid!,
      "active": false,
      "cleanliness": cleanliness,
      "position": position,
      "view": view,
      "reachability": reachability,
      "equipment": equipment,
      "images": [],
      "location": GeoPoint(currentPosition.latitude, currentPosition.longitude),
    }).then((value) async {
      List photosUrl = [];
      if (photos.isNotEmpty) {
        for (var photo in photos) {
          try {
            String ext2 = photo.split(".").last;
            TaskSnapshot _pSnapshot =
                await FirebaseStorage.instance.ref('benches/${value.id}/photo_${DateTime.now().millisecondsSinceEpoch}.$ext2').putFile(File(photo));
            photosUrl.add(await _pSnapshot.ref.getDownloadURL());
          } on FirebaseException catch (e) {
            customToast(e.toString());
          }
        }
      }
      await benchesCollection.doc(value.id).update({"images": photosUrl, "active": true});
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: () => Future.value(false),
        title: "Rated",
        titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        content: MyText(text: "Thanks for rating this bench"),
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
    benchNameController.dispose();
    super.onClose();
  }
}
