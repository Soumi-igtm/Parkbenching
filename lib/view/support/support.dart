import 'package:flutter/material.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Support",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            kLogo,
            height: 200,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/email.png',
                    height: 20,
                  ),
                  MyText(
                    paddingLeft: 10,
                    text: 'info@apponauten.de',
                    size: 16,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/world-wide-web.png',
                    height: 20,
                  ),
                  MyText(
                    paddingLeft: 10,
                    text: 'www.apponauten.de',
                    size: 16,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }
}
