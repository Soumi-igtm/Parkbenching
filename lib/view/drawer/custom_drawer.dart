import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/support/support.dart';
import 'package:park_benching/view/widget/my_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchBox(),
            ListTile(
              onTap: () {},
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kProfileIcon,
                    height: 20,
                  ),
                ],
              ),
              title: MyText(
                text: 'Simon Petran',
                size: 16,
                weight: FontWeight.w600,
              ),
              subtitle: MyText(
                text: 'View profile',
                size: 11,
                weight: FontWeight.w500,
                color: kGreyColor,
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: Color(0xffDADADA),
            ),
            const SizedBox(
              height: 20,
            ),
            DrawerTiles(
              onTap: () {},
              icon: kBenchIcon,
              iconSize: 24.0,
              title: 'Bench History',
            ),
            DrawerTiles(
              onTap: () {},
              icon: kReportHistoryIcon,
              iconSize: 25.0,
              title: 'Report History',
            ),
            DrawerTiles(
              onTap: () {},
              icon: kTopRatedBenchesIcon,
              title: 'Top Rated Benches',
            ),
            DrawerTiles(
              onTap: () => Get.to(() => const Support()),
              icon: kSupportIcon,
              title: 'Support',
            ),
          ],
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }

  Widget searchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 12,
          color: kGreyColor,
        ),
        decoration: InputDecoration(
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                kSearchIcon,
                height: 16,
              ),
            ],
          ),
          hintText: 'Search benches, location',
          hintStyle: const TextStyle(
            fontSize: 12,
            color: kGreyColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xffDADADA),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xffDADADA),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DrawerTiles extends StatelessWidget {
  DrawerTiles({
    Key? key,
    this.icon,
    this.title,
    this.iconSize = 20.0,
    this.onTap,
  }) : super(key: key);
  String? icon, title;
  double? iconSize;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Image.asset(
          '$icon',
          height: iconSize,
        ),
        title: MyText(
          text: '$title',
          weight: FontWeight.w500,
          color: kGreyColor,
        ),
      ),
    );
  }
}
