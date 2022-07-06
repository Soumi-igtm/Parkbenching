import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_benching/controller/intro_controller.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/custom_bottom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';

class Intro extends GetView<IntroController> {
  const Intro({Key? key}) : super(key: key);

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
            text: 'Present the new BenchNearby',
            paddingTop: 30,
          ),
          MyText(
            text: 'The most beautiful park bench just for you!',
            size: 18,
            weight: FontWeight.w600,
            paddingTop: 15,
            paddingBottom: 30,
          ),
          features('Find park benches'),
          features('Report park benches'),
          features('Send your own (park bench ) locations to be picked up or to meet with friends'),
          features('View top rated park benches'),
          features('Report broken bench'),
        ],
      ),
      bottomNavigationBar: customBottomAppBar(
        'Next',
        () => controller.next(),
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
