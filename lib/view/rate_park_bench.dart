import 'dart:io';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkbenching/view/constant/color.dart';
import 'package:parkbenching/view/constant/images.dart';
import 'package:parkbenching/view/widget/custom_app_bar.dart';
import 'package:parkbenching/view/widget/my_text.dart';

import '../controller/rate_park_bench_controller.dart';

class RateParkBench extends StatelessWidget {
  const RateParkBench({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RateParkBenchController>(
        init: RateParkBenchController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(title: 'Rate Park Bench'),
            body: Column(
              children: [
                MyText(
                  text: 'Select the bench from the map you want to rate',
                  fontFamily: 'Mulish',
                  size: 12,
                  paddingBottom: 20.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: context.height / 3.5,
                  child: CustomGoogleMapMarkerBuilder(
                      customMarkers: controller.markers,
                      builder: (BuildContext context, Set<Marker>? markers) {
                        return GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                          markers: markers ?? {},
                          initialCameraPosition: controller.googleLocation,
                          onMapCreated: (GoogleMapController googleMapController) {
                            controller.mapController.complete(googleMapController);
                          },
                        );
                      }),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                        child: TextFormField(
                            autofocus: false,
                            controller: controller.benchLocationController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(kBenchIcon, width: 25),
                                ],
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Bench location",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            heading('Rating'),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 0,
                              itemSize: 30,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              glow: false,
                              itemPadding: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                              unratedColor: const Color(0xffCCCFD9),
                              itemBuilder: (context, _) => Image.asset(kRatingStar, height: 30),
                              onRatingUpdate: (rating) {
                                controller.selectedRating = rating;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                        child: TextFormField(
                            autofocus: false,
                            controller: controller.reviewController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.rate_review),
                              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Describe your bench review",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          child: MyText(text: 'Submit', color: kWhiteColor, weight: FontWeight.bold, paddingTop: 15, paddingBottom: 15),
                          style: ElevatedButton.styleFrom(primary: kSecondaryColor),
                          onPressed: () {
                            controller.submitRate(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget heading(String heading) {
    return MyText(
      text: heading,
      size: 16,
      weight: FontWeight.w700,
      color: kTertiaryColor,
      paddingBottom: 15,
      paddingTop: 35,
    );
  }
}
