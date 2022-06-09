import 'package:flutter/material.dart';
import 'package:park_benching/view/constant/color.dart';

import 'my_button.dart';

Widget customBottomAppBar(
    String? buttonText,
    VoidCallback? onTap,
    ) {
  return BottomAppBar(
    elevation: 0,
    color: kPrimaryColor,
    child: SizedBox(
      height: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: MyButton(
              onPressed: onTap,
              text: buttonText,
            ),
          ),
        ],
      ),
    ),
  );
}