import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:park_benching/controller/park_controller.dart';
import 'package:park_benching/view/add_park.dart';

import 'constant/color.dart';
import 'constant/common.dart';
import 'constant/images.dart';
import 'widget/custom_app_bar.dart';
import 'widget/my_text.dart';

class Parks extends StatelessWidget {
  const Parks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkBenchController>(
      init: ParkBenchController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Parks'),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: TextButton(
            onPressed: () => Get.to(() => AddPark(uid: controller.uid!)),
            style: TextButton.styleFrom(backgroundColor: kTertiaryColor, shape: const StadiumBorder()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              child: MyText(text: "Add park", color: kWhiteColor, weight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    radiusButtons(
                      'Near me (5km)',
                      0,
                    ),
                    radiusButtons(
                      'Worldwide',
                      1,
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: parksCollection.where("active", isEqualTo: true).snapshots(),
                      builder: (context, pSnapshot) {
                        if (!pSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                        List<DocumentSnapshot> parkList = pSnapshot.data!.docs;

                        return ListView.builder(
                          itemCount: parkList.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          itemBuilder: (BuildContext context, int index) {
                            return BenchCards(
                              parkImage: parkList[index]["parkImage"],
                              parkName: parkList[index]["parkName"],
                              rating: parkList[index]["rating"],
                              distance: parkList[index]["distance"],
                            );
                          },
                        );
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
    return GetBuilder<ParkBenchController>(
      init: ParkBenchController(),
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
  String? parkImage, parkName;
  double? rating, distance;

  BenchCards({
    Key? key,
    this.parkImage,
    this.parkName,
    this.distance,
    this.rating,
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
                  child: Image.asset(
                    parkImage!,
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
                        text: '$parkName',
                        size: 14,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                        weight: FontWeight.w500,
                      ),
                      Row(
                        children: [
                          MyText(
                            text: rating.toString(),
                            size: 11,
                            paddingRight: 3.0,
                            weight: FontWeight.w500,
                          ),
                          Expanded(
                            child: RatingBar(
                              initialRating: 5,
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
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
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
          const SizedBox(
            width: 15,
          ),
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
                      text: distance! < 1000 ? '${meterIntoKm(distance!)}m' : '${meterIntoKm(distance!)}km',
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Image.asset(
                    'assets/images/route_with_bg.png',
                    height: 35,
                  ),
                ),
                MyText(
                  text: 'Reviews',
                  size: 14,
                  weight: FontWeight.w500,
                  color: kYellowColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  meterIntoKm(double meter) {
    meter = distance!;
    if (meter < 1000) {
      int? distanceInMeter = meter.toInt();
      return distanceInMeter;
    } else {
      meter = meter / 1000;
      return meter;
    }
  }
}
