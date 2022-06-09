import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_benching/view/constant/images.dart';

import 'my_text.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.title,
  }) : super(key: key);

  String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Image.asset(
          kBackIcon,
          height: 15.5,
        ),
      ),
      title: MyText(
        text: '$title',
        size: 18,
        weight: FontWeight.w700,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(65);
}