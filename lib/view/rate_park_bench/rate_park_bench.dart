import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/custom_bottom_app_bar.dart';
import 'package:park_benching/view/widget/custom_radio.dart';
import 'package:park_benching/view/widget/my_button.dart';
import 'package:park_benching/view/widget/my_text.dart';

class RateParkBench extends StatelessWidget {
  const RateParkBench({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rate Park Bench',
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          //dummy Bench Location
          Image.asset(
            'assets/images/map_2.png',
            height: 168,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 10, 0),
            child: Row(
              children: [
                Expanded(
                  child: MyButton(
                    onPressed: () {},
                    height: 45,
                    text: 'Confirm rating',
                    textSize: 13,
                    weight: FontWeight.w700,
                    fontFamily: 'Mulish',
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: kSecondaryColor,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5),
                      splashColor: kSecondaryColor.withOpacity(0.05),
                      highlightColor: kSecondaryColor.withOpacity(0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add),
                          MyText(
                            paddingLeft: 5,
                            text: 'Add pictures',
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
                heading(
                  'Cleanliness',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    customRadio(
                      'very clean',
                      0,
                    ),
                    customRadio(
                      'clean',
                      1,
                    ),
                    customRadio(
                      'dirty',
                      2,
                    ),
                  ],
                ),
                heading(
                  'Position',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    customRadio(
                      'park',
                      0,
                    ),
                    customRadio(
                      'bus stop',
                      1,
                    ),
                    customRadio(
                      'forest path\\track',
                      2,
                    ),
                    customRadio(
                      'pedetrian zone',
                      3,
                    ),
                    customRadio(
                      'street',
                      4,
                    ),
                  ],
                ),
                heading(
                  'View',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    customRadio(
                      'wonderful',
                      0,
                    ),
                    customRadio(
                      'changeable',
                      1,
                    ),
                    customRadio(
                      'relaxed',
                      2,
                    ),
                    customRadio(
                      'on the traffic',
                      3,
                    ),
                  ],
                ),
                heading(
                  'Reachability',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    customRadio(
                      'car',
                      0,
                    ),
                    customRadio(
                      'bicycle',
                      1,
                    ),
                    customRadio(
                      'on foot',
                      2,
                    ),
                  ],
                ),
                heading(
                  'Equipment',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    customRadio(
                      'several benches',
                      0,
                    ),
                    customRadio(
                      'table',
                      1,
                    ),
                    customRadio(
                      'canopy',
                      2,
                    ),
                    customRadio(
                      'garbage can',
                      2,
                    ),
                  ],
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: customBottomAppBar(
        'Submit',
        () {},
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

  Widget takePictureOfBench(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
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
              height: 18.33,
            ),
            MyText(
              paddingTop: 8,
              text: 'Take picture of park bench',
              size: 11,
              weight: FontWeight.w500,
              fontFamily: 'Mulish',
            ),
          ],
        ),
      ),
    );
  }
}
