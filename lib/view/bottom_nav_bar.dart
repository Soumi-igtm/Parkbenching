import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/drawer/custom_drawer.dart';
import 'package:park_benching/view/widget/my_text.dart';

import '../controller/bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
        init: BottomNavController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              key: controller.globalKey,
              extendBodyBehindAppBar: true,
              drawer: const CustomDrawer(),
              body: Stack(
                children: [
                  CustomGoogleMapMarkerBuilder(
                      customMarkers: controller.markers,
                      builder: (BuildContext context, Set<Marker>? markers) {
                        return GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                          initialCameraPosition: controller.googleLocation,
                          markers: markers ?? {},
                          onMapCreated: (GoogleMapController googleMapController) {
                            controller.mapController.complete(googleMapController);
                            controller.determinePosition();
                          },
                        );
                      }),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => controller.globalKey.currentState!.openDrawer(),
                        child: Container(
                          height: 45,
                          width: 45,
                          margin: const EdgeInsets.only(bottom: 8),
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            shape: const CircleBorder(),
                            color: kWhiteColor,
                            shadows: [
                              BoxShadow(
                                color: kBlackColor.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(4, 4),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Image.asset(kMenuIcon, height: 13.5, color: kTertiaryColor),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 60,
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppLinks.addBench, parameters: {"uid": controller.uid!}),
                      style: TextButton.styleFrom(backgroundColor: kTertiaryColor, shape: const StadiumBorder()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        child: MyText(text: "Add bench", color: kWhiteColor, weight: FontWeight.bold),
                      ),
                    ),
                  )
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
                      iconSize: 20,
                    ),
                    label: 'Route',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomBottomNavBarItem(
                      onTap: () => Get.toNamed(AppLinks.parks, parameters: {"uid": controller.uid!}),
                      index: 1,
                      icon: kParkIcon,
                      iconSize: 20,
                    ),
                    label: 'Parks',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomBottomNavBarItem(
                      onTap: () => Get.toNamed(AppLinks.reportParkBench),
                      index: 2,
                      icon: kReportIcon,
                      iconSize: 22,
                    ),
                    label: 'Report',
                  ),
                  BottomNavigationBarItem(
                    icon: CustomBottomNavBarItem(
                      onTap: () => Get.toNamed(AppLinks.rateParkBench, parameters: {"uid": controller.uid!}),
                      index: 3,
                      icon: kRateIcon,
                      iconSize: 17,
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
            ),
          );
        });
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
