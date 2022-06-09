import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:park_benching/controller/map_controller/map_controller.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/drawer/custom_drawer.dart';
import 'package:park_benching/view/widget/my_text.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          ListView(
            children: [
              dummyMap(),
            ],
          ),
          Positioned(
            top: 50,
            left: 15,
            child: drawerIcon(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kTertiaryColor,
        unselectedItemColor: kTertiaryColor,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: [
          BottomNavigationBarItem(
            icon: CustomBottomNavBarItem(
              onTap: () {},
              index: 0,
              icon: kRouteIcon,
              iconSize: 23,
            ),
            label: 'Route',
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavBarItem(
              onTap: () => Get.toNamed(AppLinks.reportParkBench),
              index: 1,
              icon: kReportIcon,
              iconSize: 25,
            ),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavBarItem(
              onTap: () => Get.toNamed(AppLinks.sendLocation),
              index: 2,
              icon: kSendIcon,
              iconSize: 20,
            ),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavBarItem(
              onTap: () => Get.toNamed(AppLinks.rateParkBench),
              index: 3,
              icon: kRateIcon,
              iconSize: 20,
            ),
            label: 'Rate',
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavBarItem(
              onTap: () => Get.toNamed(AppLinks.topRatedParkBenches),
              index: 4,
              icon: kTopRatedIcon,
              iconSize: 20,
            ),
            label: 'Top',
          ),
        ],
      ),
    );
  }

  Widget dummyMap() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/dummy_map.png',
          height: Get.height,
          width: Get.width,
          fit: BoxFit.cover,
        ),
        const Positioned(
          top: 50,
          right: 150,
          child: MapPinsAndBenchDetails(),
        ),
        const Positioned(
          top: 50,
          left: 30,
          child: MapPinsAndBenchDetails(),
        ),
        Positioned(
          top: Get.height * 0.15,
          right: 30,
          child: const MapPinsAndBenchDetails(),
        ),
        Positioned(
          top: Get.height * 0.2,
          left: 30,
          child: const MapPinsAndBenchDetails(),
        ),
        Positioned(
          top: Get.height * 0.4,
          right: 15,
          child: const MapPinsAndBenchDetails(),
        ),
        Positioned(
          top: Get.height * 0.5,
          left: 150,
          child: Image.asset(
            kDestinationPin,
            height: 100,
          ),
        ),
        Positioned(
          top: Get.height * 0.7,
          right: 100,
          child: Image.asset(
            kMyLocationIcon,
            height: 36,
          ),
        ),
      ],
    );
  }

  Widget drawerIcon() {
    return GestureDetector(
      onTap: () => _globalKey.currentState!.openDrawer(),
      child: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: kWhiteColor,
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(4, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            kMenuIcon,
            height: 13.5,
            color: kTertiaryColor,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryOfRating extends StatelessWidget {
  CategoryOfRating({
    Key? key,
    this.title,
    this.ratedAnswer,
  }) : super(key: key);

  String? title, ratedAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          paddingBottom: 10,
          text: title,
          size: 13,
          weight: FontWeight.w500,
        ),
        Row(
          children: [
            Image.asset(
              kCheckWhite,
              height: 14,
            ),
            Expanded(
              child: MyText(
                paddingLeft: 10,
                text: ratedAnswer,
                size: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CustomBottomNavBarItem extends StatelessWidget {
  CustomBottomNavBarItem({
    Key? key,
    @required this.icon,
    this.iconSize = 20.0,
    this.index,
    this.onTap,
  }) : super(key: key);
  String? icon;
  double? iconSize;
  int? index;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: index == 0 ? kSecondaryColor : kWhiteColor,
        ),
        child: Center(
          child: Image.asset(
            '$icon',
            height: iconSize,
            color: index == 0 ? kWhiteColor : kTertiaryColor,
          ),
        ),
      ),
    );
  }
}

class MapPinsAndBenchDetails extends StatelessWidget {
  const MapPinsAndBenchDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.dialog(
        GetBuilder<MapController>(
          init: MapController(),
          builder: (controller) {
            return Column(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          MyText(
                                            paddingBottom: 8,
                                            text: 'Redknap  Bench',
                                            size: 11,
                                            weight: FontWeight.w500,
                                          ),
                                          MyText(
                                            text: '300m',
                                            size: 14,
                                            weight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              controller.isDetailsShown == true
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: kSecondaryColor,
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            kRouteIcon,
                                            height: 23,
                                            color: kWhiteColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    MyText(
                                      text: '4.0',
                                      size: 13,
                                      paddingRight: 10.0,
                                      weight: FontWeight.w600,
                                    ),
                                    Expanded(
                                      child: RatingBar(
                                        initialRating: 5,
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
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: CategoryOfRating(
                                        title: 'Cleanliness',
                                        ratedAnswer: 'Very clean',
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: CategoryOfRating(
                                        title: 'View',
                                        ratedAnswer: 'Wonderful',
                                      ),
                                    ),
                                  ],
                                ),
                                controller.isDetailsShown == true
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
                                                  ratedAnswer: 'Car',
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: CategoryOfRating(
                                                  title: 'Position',
                                                  ratedAnswer: 'Park',
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
                                                  ratedAnswer:
                                                      'Several benches',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () => controller.showMoreDetails(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      MyText(
                                        text: controller.isDetailsShown == true
                                            ? 'Less'
                                            : 'More',
                                        size: 13,
                                        paddingRight: 5,
                                        weight: FontWeight.w600,
                                        color: kYellowColor,
                                      ),
                                      Image.asset(
                                        controller.isDetailsShown == true
                                            ? kArrowUp
                                            : kArrowDown,
                                        height: 7,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      child: Image.asset(
        kMapPin,
        height: 36,
      ),
    );
  }
}
