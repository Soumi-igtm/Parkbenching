import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/my_text.dart';
import 'constant/color.dart';
import 'widget/custom_app_bar.dart';

import '../controller/add_park_controller.dart';

class AddPark extends GetView<AddParkController> {
  const AddPark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: 'Add Park'),
      body: Column(
        children: [
          MyText(
            text: 'Place the marker over the park location',
            fontFamily: 'Mulish',
            size: 12,
            paddingBottom: 20.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: context.height / 3.5,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: controller.googleLocation,
                  onMapCreated: (GoogleMapController googleMapController) {
                    controller.mapController.complete(googleMapController);
                  },
                  onCameraMove: (CameraPosition position) {
                    controller.currentPosition = position.target;
                  },
                ),
                const Icon(Icons.location_on, size: 30)
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
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
                    controller: controller.parkNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(kParkIcon, width: 25),
                        ],
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Park Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                  child: TextFormField(
                    autofocus: false,
                    controller: controller.parkDescriptionController,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.comment),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Park Description (optional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: MyText(text: 'Add for review', color: kWhiteColor, weight: FontWeight.bold, paddingTop: 15, paddingBottom: 15),
                    style: ElevatedButton.styleFrom(primary: kSecondaryColor),
                    onPressed: () {
                      controller.submitPark(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
