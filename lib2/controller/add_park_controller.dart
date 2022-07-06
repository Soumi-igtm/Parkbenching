import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../routes/routes.dart';
import '../view/constant/color.dart';
import '../view/constant/common.dart';
import '../view/widget/my_text.dart';

class AddParkController extends GetxController {
  String? uid = Get.parameters["uid"];
  RxList photos = [].obs;
  final Completer<GoogleMapController> mapController = Completer();
  final box = GetStorage();
  final CameraPosition googleLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  LatLng currentPosition = const LatLng(0.0, 0.0);
  final TextEditingController parkNameController = TextEditingController(), parkDescriptionController = TextEditingController();

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

  Future pickImage({bool fromGallery = false}) async {
    try {
      final image = await ImagePicker().pickImage(source: fromGallery ? ImageSource.gallery : ImageSource.camera);

      if (image == null) return;

      photos.add(image.path);
    } on PlatformException catch (e) {
      customToast("Failed to pick image");
    }
  }

  submitPark(BuildContext context) async {
    if (parkNameController.text.isEmpty) {
      customToast("Provide a park name");
      return;
    }
    if (photos.isEmpty) {
      customToast("Add at least one image");
      return;
    }
    customToast("Please wait...");

    List<Placemark> placeMarks = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);

    print(placeMarks.first);

    await parksCollection.add({
      "active": false,
      "uid": uid!,
      "parkName": parkNameController.text,
      "parkNameSearch": parkNameController.text, // need to do
      "parkLocation": GeoPoint(currentPosition.latitude, currentPosition.longitude),
      "description": parkDescriptionController.text,
      "images": [],
      "country": placeMarks.first.country,
      "state": placeMarks.first.administrativeArea,
      "city": placeMarks.first.locality,
      "postalCode": placeMarks.first.postalCode,
      "totalBenches": 0,
      "addedOn": DateTime.now(),
    }).then((value) async {
      List photosUrl = [];

      for (var photo in photos) {
        customToast("uploading $photo");
        try {
          String ext2 = photo.split(".").last;
          TaskSnapshot _pSnapshot =
              await FirebaseStorage.instance.ref('parks/${value.id}/photo_${DateTime.now().millisecondsSinceEpoch}.$ext2').putFile(File(photo));
          photosUrl.add(await _pSnapshot.ref.getDownloadURL());
        } on FirebaseException catch (e) {
          customToast(e.toString());
        }
      }

      await parksCollection.doc(value.id).update({"images": photosUrl});
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: () => Future.value(false),
        title: "Park Added",
        titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        content: MyText(text: "Your addition will be reviewed by us then we will make it visible worldwide", align: TextAlign.center),
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
    parkNameController.dispose();
    parkDescriptionController.dispose();
    super.onClose();
  }
}
