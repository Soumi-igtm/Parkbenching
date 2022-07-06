import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../routes/routes.dart';
import '../view/constant/color.dart';
import '../view/constant/common.dart';
import '../view/widget/my_text.dart';

class AddBenchController extends GetxController {
  String? uid = Get.parameters["uid"];

  final Completer<GoogleMapController> mapController = Completer();
  final box = GetStorage();
  String cleanliness = "Clean", position = "Park", view = "Wonderful";
  List reachability = ["Bicycle"], equipment = ["Several benches"];

  LatLng currentPosition = const LatLng(0.0, 0.0);
  RxList photos = [].obs;
  var selectedParkName = "".obs;
  String selectParkID = "";
  double selectedRating = 0.0;
  final geo = Geoflutterfire();
  final CameraPosition googleLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final TextEditingController reviewController = TextEditingController();

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

  submitBench(BuildContext context) async {
    if (selectedParkName.isEmpty) {
      customToast("Select a park");
      return;
    }

    if (photos.isEmpty) {
      customToast("Add at least one photo");
      return;
    }

    customToast("Please wait...");
    GeoFirePoint myLocation = geo.point(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
    await benchesCollection.add({
      "uid": uid!,
      "active": false,
      "cleanliness": cleanliness,
      "position": position,
      "view": view,
      "reachability": reachability,
      "equipment": equipment,
      "images": [],
      "parkID": selectParkID,
      "parkName": selectedParkName.value,
      "rating": selectedRating,
      "ratingCount": 1,
      "location": myLocation.data
    }).then((value) async {
      List photosUrl = [];

      await benchesCollection.doc(value.id).collection("reviews").add({
        "rating": selectedRating,
        "uid": uid,
        "review": reviewController.text,
        "reviewDate": DateTime.now(),
      });

      for (var photo in photos) {
        customToast("uploading $photo");
        try {
          String ext2 = photo.split(".").last;
          TaskSnapshot _pSnapshot =
              await FirebaseStorage.instance.ref('benches/${value.id}/photo_${DateTime.now().millisecondsSinceEpoch}.$ext2').putFile(File(photo));
          photosUrl.add(await _pSnapshot.ref.getDownloadURL());
        } on FirebaseException catch (e) {
          customToast(e.toString());
        }
      }

      await benchesCollection.doc(value.id).update({"images": photosUrl, "active": true});
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: () => Future.value(false),
        title: "Added",
        titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        content: MyText(text: "Thanks for adding this bench. Your app is now visible worldwide"),
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

  openParkList() {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            ListTile(
              title: MyText(text: "Select Park", weight: FontWeight.bold, size: 20),
              trailing: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: kGreyColor),
              ),
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: parksCollection.where("active", isEqualTo: true).orderBy("parkName").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    List<DocumentSnapshot> parkData = snapshot.data!.docs;

                    return ListView.builder(
                        itemCount: parkData.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              selectParkID = parkData[index].id;
                              selectedParkName.value = parkData[index]["parkName"];
                              Get.back();
                            },
                            title: MyText(
                              text: parkData[index]["parkName"],
                              color: Colors.black,
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      backgroundColor: kWhiteColor,
    );
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}
