import 'package:flutter/material.dart';
import 'package:parkbenching/view/constant/color.dart';
import 'package:parkbenching/view/widget/my_text.dart';

Widget customRadio(String title, int index) {
  return Wrap(
    children: [
      GestureDetector(
        onTap: () {},
        child: Container(
          height: 17,
          width: 17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: kBorderColor,
              width: 1.0,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
      MyText(
        paddingLeft: 8,
        text: title,
        size: 13,
        weight: FontWeight.w500,
        fontFamily: 'Mulish',
      ),
    ],
  );
}
