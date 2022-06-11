import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:park_benching/controller/top_rated_park_benches_controller.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';

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
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    radiusButtons(
                      'Entire Germany',
                      4,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    children: controller.currentIndex == 0
                        ? controller.getDummyBenches
                            .where(
                            (element) => element.distance! < 1000,
                          )
                            .map((e) {
                            return BenchCards(
                              parkImage: e.parkImage,
                              parkName: e.parkName,
                              rating: e.rating,
                              distance: e.distance,
                            );
                          }).toList()
                        : controller.currentIndex == 1
                            ? controller.getDummyBenches
                                .where(
                                (element) => element.distance! < 10000,
                              )
                                .map((e) {
                                return BenchCards(
                                  parkImage: e.parkImage,
                                  parkName: e.parkName,
                                  rating: e.rating,
                                  distance: e.distance,
                                );
                              }).toList()
                            : controller.currentIndex == 3
                                ? controller.getDummyBenches
                                    .where(
                                    (element) => element.distance! < 10000,
                                  )
                                    .map((e) {
                                    return BenchCards(
                                      parkImage: e.parkImage,
                                      parkName: e.parkName,
                                      rating: e.rating,
                                      distance: e.distance,
                                    );
                                  }).toList()
                                : controller.getDummyBenches.map((e) {
                                    return BenchCards(
                                      parkImage: e.parkImage,
                                      parkName: e.parkName,
                                      rating: e.rating,
                                      distance: e.distance,
                                    );
                                  }).toList(),
                  ),
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
                      color: controller.currentIndex == index
                          ? kYellowColor
                          : kSecondaryColor,
                      width: 1.0,
                    ),
                    color: controller.currentIndex == index
                        ? kYellowColor.withOpacity(0.05)
                        : kSecondaryColor.withOpacity(0.05),
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
                      text: distance! < 1000
                          ? '${meterIntoKm(distance!)}m'
                          : '${meterIntoKm(distance!)}km',
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
