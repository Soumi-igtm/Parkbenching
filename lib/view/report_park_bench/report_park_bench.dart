import 'dart:io';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';

import '../../controller/report_park_bench_controller.dart';
import '../constant/validators.dart';



class ReportParkBench extends GetView<ReportParkBenchController> {
  const ReportParkBench({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'Report Park Bench'),
      body: Column(
        children: [
          //dummy Bench Location
          // Image.asset(
          //   'assets/images/map_2.png',
          //   height: 168,
          //   fit: BoxFit.cover,
          // ),
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
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                    child: TextFormField(
                        autofocus: false,
                        controller: controller.benchNameController,
                        keyboardType: TextInputType.emailAddress,
                        validator: benchValidator,
                        onSaved: (value) {
                          controller.benchNameController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.event_seat),
                          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Bench name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                  ),
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
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      heading('Cleanliness'),
                      CustomRadioButton(
                        elevation: 0,
                        absoluteZeroSpacing: false,
                        unSelectedColor: kPrimaryColor,
                        buttonLables: const [
                          'Very clean',
                          'Clean',
                          'Dirty',
                        ],
                        buttonValues: const [
                          'Very clean',
                          'Clean',
                          'Dirty',
                        ],
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(fontSize: 13, fontFamily: 'Mulish'),
                        ),
                        radioButtonValue: (value) {
                          controller.cleanliness = value as String;
                        },
                        spacing: 5,
                        defaultSelected: "Clean",
                        enableShape: true,
                        enableButtonWrap: false,
                        scrollController: ScrollController(),
                        padding: 10,
                        selectedColor: kTertiaryColor,
                        unSelectedBorderColor: kTertiaryColor,
                      ),
                      heading("Position"),
                      CustomRadioButton(
                        elevation: 0,
                        absoluteZeroSpacing: false,
                        unSelectedColor: kPrimaryColor,
                        buttonLables: const [
                          'Park',
                          'Bus stop',
                          'Forest path/ Track',
                          'Pedestrian zone',
                          'Street',
                        ],
                        buttonValues: const [
                          'Park',
                          'Bus stop',
                          'Forest path/ Track',
                          'Pedestrian zone',
                          'Street',
                        ],
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(fontSize: 13, fontFamily: 'Mulish'),
                        ),
                        radioButtonValue: (value) {
                          controller.position = value as String;
                        },
                        spacing: 5,
                        defaultSelected: "Park",
                        enableShape: true,
                        enableButtonWrap: false,
                        scrollController: ScrollController(),
                        width: 145,
                        padding: 10,
                        selectedColor: kTertiaryColor,
                        unSelectedBorderColor: kTertiaryColor,
                      ),
                      heading('View'),
                      CustomRadioButton(
                        elevation: 0,
                        absoluteZeroSpacing: false,
                        unSelectedColor: kPrimaryColor,
                        buttonLables: const [
                          'Wonderful',
                          'Changeable',
                          'Relaxed',
                          'On the traffic',
                        ],
                        buttonValues: const [
                          'Wonderful',
                          'Changeable',
                          'Relaxed',
                          'On the traffic',
                        ],
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(fontSize: 13, fontFamily: 'Mulish'),
                        ),
                        radioButtonValue: (value) {
                          controller.view = value as String;
                        },
                        spacing: 5,
                        defaultSelected: "Wonderful",
                        enableShape: true,
                        enableButtonWrap: false,
                        scrollController: ScrollController(),
                        width: 120,
                        padding: 10,
                        selectedColor: kTertiaryColor,
                        unSelectedBorderColor: kTertiaryColor,
                      ),
                      heading('Reachability'),
                      CustomCheckBoxGroup(
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(fontSize: 13, fontFamily: 'Mulish'),
                        ),
                        unSelectedColor: kPrimaryColor,
                        buttonLables: const [
                          "Car",
                          "Bicycle",
                          "On foot",
                        ],
                        buttonValuesList: const [
                          "Car",
                          "Bicycle",
                          "On foot",
                        ],
                        checkBoxButtonValues: (values) {
                          controller.reachability = values;
                        },
                        spacing: 5,
                        defaultSelected: const ["Bicycle"],
                        enableButtonWrap: false,
                        scrollController: ScrollController(),
                        enableShape: true,
                        width: 100,
                        absoluteZeroSpacing: false,
                        selectedColor: kTertiaryColor,
                        unSelectedBorderColor: kTertiaryColor,
                        padding: 10,
                      ),
                      heading('Equipment'),
                      CustomCheckBoxGroup(
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(fontSize: 13, fontFamily: 'Mulish'),
                        ),
                        unSelectedColor: kPrimaryColor,
                        buttonLables: const [
                          "Several benches",
                          "Table",
                          "Canopy",
                          "Garbage can",
                        ],
                        buttonValuesList: const [
                          "Several benches",
                          "Table",
                          "Canopy",
                          "Garbage can",
                        ],
                        checkBoxButtonValues: (values) {
                          controller.equipment = values;
                        },
                        spacing: 5,
                        defaultSelected: const ["Several benches"],
                        enableButtonWrap: false,
                        scrollController: ScrollController(),
                        enableShape: true,
                        width: 150,
                        absoluteZeroSpacing: false,
                        selectedColor: kTertiaryColor,
                        unSelectedBorderColor: kTertiaryColor,
                        padding: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                heading('Rating'),
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 0,
                                  itemSize: 16.20,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  glow: false,
                                  itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  unratedColor: const Color(0xffCCCFD9),
                                  itemBuilder: (context, _) => Image.asset(
                                    kRatingStar,
                                    height: 16.20,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: reportBrokenBench(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        child: MyText(text: 'Submit', color: kWhiteColor, weight: FontWeight.bold, paddingTop: 15, paddingBottom: 15),
                        style: ElevatedButton.styleFrom(primary: kSecondaryColor),
                        onPressed: () {
                          controller.submitRating(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget takePictureOfBench(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: kSecondaryColor,
            width: 1.0,
          ),
          color: kSecondaryColor.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kCameraIcon,
              height: 10.33,
            ),
            MaterialButton(
              color: Colors.green[100],
              child: const Text(
                "Take picture of park bench",
                style: TextStyle(color: Colors.black, fontFamily: "Mulish"),
              ),
              onPressed: () {
                // pickImage();
              },
            ),
            //image != null ? Image.file(image!) : Text("no image selected")
          ],
        ),
      ),
    );
  }

  Widget reportBrokenBench() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppLinks.report),
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: kSecondaryColor,
            width: 1.0,
          ),
          color: kSecondaryColor.withOpacity(0.05),
        ),
        child: Center(
          child: MyText(
            text: 'Report broken bench',
            size: 13,
            weight: FontWeight.w700,
            fontFamily: 'Mulish',
          ),
        ),
      ),
    );
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
