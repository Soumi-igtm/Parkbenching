import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkbenching/view/constant/common.dart';
import 'package:rxdart/rxdart.dart';
import '../view/bottom_nav_bar.dart';
import '../view/constant/color.dart';
import '../view/constant/images.dart';
import '../view/widget/my_text.dart';

class BottomNavController extends GetxController {
  String? uid = Get.parameters["uid"];
  String? guest = Get.parameters["guest"];

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
  RxBool isDetailsShown = false.obs;

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
            marker: Marker(
                markerId: MarkerId(benchID),
                position: LatLng(point.latitude, point.longitude),
                onTap: () {
                  openPinDetails(document);
                }),
            child: Image.asset(kMapPin, width: 40)),
      );
    }
    markers.addAll(temp);
    update();
  }

  void showMoreDetails() {
    isDetailsShown.value = !isDetailsShown.value;
  }

  openPinDetails(DocumentSnapshot pinData) {
    Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 111,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kWhiteColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.asset(
                                  kDummyBench,
                                  height: 78,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    MyText(
                                      paddingBottom: 8,
                                      text: pinData["parkName"],
                                      size: 11,
                                      weight: FontWeight.w500,
                                    ),
                                    MyText(
                                      text:
                                          "${meterIntoKm(calculateDistance(lat1: centerPoint.latitude, lon1: centerPoint.longitude, lat2: pinData["location"]["geopoint"].latitude, lon2: pinData["location"]["geopoint"].longitude))}",
                                      size: 14,
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        isDetailsShown.value == true
                            ? GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.only(top: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kSecondaryColor,
                                  ),
                                  child: Center(
                                    child: Image.asset(kRouteIcon, height: 23, color: kWhiteColor),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(
                        () => Column(
                          children: [
                            Row(
                              children: [
                                MyText(
                                  text: (pinData["rating"] / pinData["ratingCount"]).toDouble(),
                                  size: 13,
                                  paddingRight: 10.0,
                                  weight: FontWeight.w600,
                                ),
                                Expanded(
                                  child: RatingBar(
                                    initialRating: (pinData["rating"] / pinData["ratingCount"]).toDouble(),
                                    minRating: 1,
                                    itemSize: 16.20,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0,
                                    ),
                                    unratedColor: const Color(0xffCCCFD9),
                                    glow: false,
                                    onRatingUpdate: (rating) {},
                                    ratingWidget: RatingWidget(
                                      empty: Image.asset(
                                        kRatingStar,
                                        height: 16.20,
                                        color: const Color(0xffCCCFD9),
                                      ),
                                      full: Image.asset(
                                        kRatingStar,
                                        height: 16.20,
                                      ),
                                      half: Image.asset(
                                        kRatingStar,
                                        height: 16.20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: CategoryOfRating(
                                    title: 'Cleanliness',
                                    ratedAnswer: pinData["cleanliness"],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: CategoryOfRating(
                                    title: 'View',
                                    ratedAnswer: pinData["view"],
                                  ),
                                ),
                              ],
                            ),
                            isDetailsShown.value == true
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: CategoryOfRating(
                                              title: 'Reachability',
                                              ratedAnswer: pinData["reachability"].join(", "),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: CategoryOfRating(
                                              title: 'Position',
                                              ratedAnswer: pinData["position"],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CategoryOfRating(
                                              title: 'Equipment',
                                              ratedAnswer: pinData["equipment"].join(", "),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => showMoreDetails(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: isDetailsShown.value == true ? 'Less' : 'More',
                                    size: 13,
                                    paddingRight: 5,
                                    weight: FontWeight.w600,
                                    color: kYellowColor,
                                  ),
                                  Image.asset(
                                    isDetailsShown.value == true ? kArrowUp : kArrowDown,
                                    height: 7,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    radius.close();
    super.onClose();
  }
}
