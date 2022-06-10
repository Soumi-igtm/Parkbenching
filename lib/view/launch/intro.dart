import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/custom_bottom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';

class Intro extends StatelessWidget {
  Intro({Key? key}) : super(key: key);
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 100,
        title: Image.asset(
          kAppBarLogo,
          height: 78,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              kIntroBg,
              height: 227,
              fit: BoxFit.cover,
            ),
          ),
          MyText(
            text: 'Present the new Parkbenching',
            paddingTop: 30,
          ),
          MyText(
            text: 'The most beautiful park bench just for you!',
            size: 18,
            weight: FontWeight.w600,
            paddingTop: 15,
            paddingBottom: 30,
          ),
          features(
            'Find park benches',
          ),
          features(
            'Report park benches',
          ),
          features(
            'Send your own (park bench ) locations to be picked up or to meet with freinds',
          ),
          features(
            'View top rated park benches',
          ),
          features(
            'Report broken bench',
          ),
        ],
      ),
      bottomNavigationBar: customBottomAppBar(
        'Next',
        () {
          box.write("introread", true);
          Get.toNamed(AppLinks.loginSignUp);
        },
      ),
    );
  }

  Widget features(String feature) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Row(
        children: [
          Image.asset(
            kCheckIcon,
            height: 17,
          ),
          Expanded(
            child: MyText(
              paddingLeft: 10,
              text: feature,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}
