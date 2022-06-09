import 'package:flutter/material.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';

class SendLocation extends StatelessWidget {
  const SendLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Send location',
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/map_2.png',
            height: 168,
            fit: BoxFit.cover,
          ),
          MyText(
            paddingTop: 30,
            paddingLeft: 40,
            paddingRight: 40,
            text:
                'Here you can you can send your location to friend\'s or post your favorite park benches on social media',
            size: 13,
            height: 1.5,
            weight: FontWeight.w500,
            fontFamily: 'Mulish',
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
