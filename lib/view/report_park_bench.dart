import 'dart:io';

import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';

import '../controller/report_park_bench_controller.dart';

class ReportParkBench extends StatelessWidget {
  const ReportParkBench({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportParkBenchController>(
        init: ReportParkBenchController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(title: 'Report Park Bench'),
            body: Column(
              children: [
                MyText(
                  text: 'Select the bench from the map you want to report',
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
                          // onCameraMove: (CameraPosition position) {
                          //   controller.currentPosition = position.target;
                          // },
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
                              prefixIcon: const Icon(Icons.event_seat),
                              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Bench location",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              margin: const EdgeInsets.fromLTRB(15, 10, 7.5, 0),
                              decoration: BoxDecoration(
                                color: kSecondaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: kSecondaryColor,
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () => controller.pickImage(fromGallery: true),
                                borderRadius: BorderRadius.circular(5),
                                splashColor: kSecondaryColor.withOpacity(0.05),
                                highlightColor: kSecondaryColor.withOpacity(0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.image_search),
                                    MyText(
                                      paddingLeft: 5,
                                      text: 'From gallery',
                                      size: 13,
                                      fontFamily: 'Mulish',
                                      weight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              margin: const EdgeInsets.fromLTRB(7.5, 10, 15, 0),
                              decoration: BoxDecoration(
                                color: kSecondaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: kSecondaryColor,
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () => controller.pickImage(),
                                borderRadius: BorderRadius.circular(5),
                                splashColor: kSecondaryColor.withOpacity(0.05),
                                highlightColor: kSecondaryColor.withOpacity(0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.camera_alt),
                                    MyText(
                                      paddingLeft: 5,
                                      text: 'From camera',
                                      size: 13,
                                      fontFamily: 'Mulish',
                                      weight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => controller.photos.isNotEmpty
                            ? SizedBox(
                                height: 90,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: controller.photos.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.photos.removeAt(index);
                                      },
                                      child: Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          Image.file(
                                            File(controller.photos[index]),
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const ShapeDecoration(shape: CircleBorder(), color: kWhiteColor),
                                            child: const Icon(Icons.close, size: 18, color: Colors.red),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                        child: TextFormField(
                            autofocus: false,
                            controller: controller.descriptionController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.report),
                              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Describe park bench issue",
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
                            controller.submitReport(context);
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
