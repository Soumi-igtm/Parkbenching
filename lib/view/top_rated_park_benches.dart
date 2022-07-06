import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:parkbenching/controller/top_rated_park_benches_controller.dart';
import 'package:parkbenching/view/constant/color.dart';
import 'package:parkbenching/view/constant/common.dart';
import 'package:parkbenching/view/constant/images.dart';
import 'package:parkbenching/view/widget/custom_app_bar.dart';
import 'package:parkbenching/view/widget/my_text.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TopRatedParkBenches extends StatelessWidget {
  const TopRatedParkBenches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopRatedParkBenchesController>(
      init: TopRatedParkBenchesController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Top rated park benches',
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    radiusButtons(
                      'Radius (5km)',
                      0,
                    ),
                    radiusButtons(
                      'Radius (10km)',
                      1,
                    ),
                    radiusButtons(
                      'Radius (20km)',
                      2,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    radiusButtons(
                      'Entire Germany',
                      4,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: benchesCollection.where("active", isEqualTo: true).orderBy("rating", descending: true).snapshots(),
                      builder: (context, bSnapshot) {
                        if (!bSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                        List<DocumentSnapshot> benchData = bSnapshot.data!.docs;
                        if (controller.currentIndex == 0) {
                          benchData = benchData
                              .where((element) =>
                                  calculateDistance(
                                      lat1: controller.userLatitude,
                                      lon1: controller.userLongitude,
                                      lat2: element["location"]["geopoint"].latitude,
                                      lon2: element["location"]["geopoint"].longitude) <=
                                  5000)
                              .toList();
                        } else if (controller.currentIndex == 1) {
                          benchData = benchData
                              .where((element) =>
                                  calculateDistance(
                                      lat1: controller.userLatitude,
                                      lon1: controller.userLongitude,
                                      lat2: element["location"]["geopoint"].latitude,
                                      lon2: element["location"]["geopoint"].longitude) <=
                                  10000)
                              .toList();
                        } else if (controller.currentIndex == 2) {
                          benchData = benchData
                              .where((element) =>
                                  calculateDistance(
                                      lat1: controller.userLatitude,
                                      lon1: controller.userLongitude,
                                      lat2: element["location"]["geopoint"].latitude,
                                      lon2: element["location"]["geopoint"].longitude) <=
                                  20000)
                              .toList();
                        }
                        return ListView.builder(
                            itemCount: benchData.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            itemBuilder: (context, index) {
                              return BenchCards(
                                bid: benchData[index].id,
                                benchImage: benchData[index]["images"][0],
                                benchName: benchData[index]["benchName"],
                                rating: benchData[index]["ratingCount"] > 0
                                    ? (benchData[index]["rating"] / benchData[index]["ratingCount"]).toDouble()
                                    : 0.0,
                                distance: meterIntoKm(calculateDistance(
                                    lat1: controller.userLatitude,
                                    lon1: controller.userLongitude,
                                    lat2: benchData[index]["location"]["geopoint"].latitude,
                                    lon2: benchData[index]["location"]["geopoint"].longitude)),
                                lat: benchData[index]["location"]["geopoint"].latitude,
                                long: benchData[index]["location"]["geopoint"].longitude,
                                ulat: controller.userLatitude,
                                ulong: controller.userLongitude,
                              );
                            });
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget radiusButtons(String radius, int index) {
    return GetBuilder<TopRatedParkBenchesController>(
      init: TopRatedParkBenchesController(),
      builder: (controller) {
        return Expanded(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => controller.selectedIndex(index),
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 1
                        ? 3
                        : index == 2
                            ? 7
                            : 0,
                    right: index == 0
                        ? 7
                        : index == 1
                            ? 3
                            : 0,
                  ),
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: controller.currentIndex == index ? kYellowColor : kSecondaryColor,
                      width: 1.0,
                    ),
                    color: controller.currentIndex == index ? kYellowColor.withOpacity(0.05) : kSecondaryColor.withOpacity(0.05),
                  ),
                  child: Center(
                    child: MyText(
                      text: radius,
                      size: 13,
                      weight: FontWeight.w700,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class BenchCards extends StatelessWidget {
  String benchImage, benchName, bid, distance;
  double rating;
  double lat, long, ulat, ulong;
  BenchCards({
    Key? key,
    required this.bid,
    required this.benchImage,
    required this.benchName,
    required this.distance,
    required this.rating,
    required this.lat,
    required this.long,
    required this.ulat,
    required this.ulong,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            kMapPin,
            height: 41,
          ),
          Container(
            width: 109,
            margin: const EdgeInsets.only(
              left: 15,
            ),
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
                  child: CachedNetworkImage(
                    imageUrl: benchImage,
                    height: 78,
                    width: double.infinity,
                    fit: BoxFit.fill,
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
                        text: benchName,
                        size: 14,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                        weight: FontWeight.w500,
                      ),
                      Row(
                        children: [
                          MyText(
                            text: rating.toStringAsFixed(1),
                            size: 11,
                            paddingRight: 3.0,
                            weight: FontWeight.w500,
                          ),
                          Expanded(
                            child: RatingBar(
                              initialRating: rating,
                              minRating: 1,
                              itemSize: 8.0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(
                                horizontal: 1.0,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText(
                      text: 'Distance: ',
                      size: 13,
                      weight: FontWeight.w500,
                      color: kGreyColor,
                    ),
                    MyText(
                      text: distance,
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse(
                            "https://www.google.com/maps/dir/?api=AIzaSyCKmGnNcCM5Jy8ol1QeMsWbICnlPvAgGtA&origin=$ulat,$ulong&destination=$lat,$long"));
                      },
                      child: Image.asset('assets/images/route_with_bg.png', height: 35)),
                ),
                GestureDetector(
                  onTap: () => reviewSheet(bid),
                  child: MyText(
                    text: 'Reviews',
                    size: 14,
                    weight: FontWeight.w500,
                    color: kYellowColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void reviewSheet(String bid) {
    Get.bottomSheet(
      StreamBuilder<QuerySnapshot>(
          stream: benchesCollection.doc(bid).collection("reviews").snapshots(),
          builder: (context, rSnapshot) {
            if (!rSnapshot.hasData) return const Center(child: CircularProgressIndicator());
            List<DocumentSnapshot> dataReview = rSnapshot.data!.docs;
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              itemCount: dataReview.length,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: usersCollection.doc(dataReview[index]["uid"]).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      DocumentSnapshot uData = snapshot.data!;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: uData["image"].isEmpty
                                ? Image.asset(
                                    kProfileIcon,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: uData["image"],
                                      placeholder: (context, s) => Image.asset(kProfileIcon),
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            title: MyText(text: uData["name"], size: 16, maxLines: 1, overFlow: TextOverflow.ellipsis, weight: FontWeight.bold),
                            subtitle: MyText(text: DateFormat.yMMMMd().format(dataReview[index]["reviewDate"].toDate()), size: 12),
                          ),
                          RatingBar(
                            initialRating: dataReview[index]["rating"].toDouble(),
                            minRating: 1,
                            itemSize: 8.0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
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
                          MyText(text: dataReview[index]["review"])
                        ],
                      );
                    });
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          }),
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    );
  }
}
