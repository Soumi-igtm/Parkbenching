import 'package:flutter/material.dart';
import 'package:parkbenching/view/constant/images.dart';
import 'package:parkbenching/view/widget/custom_app_bar.dart';
import 'package:parkbenching/view/widget/my_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                kLogo,
                height: 200,
              ),
              MyText(
                text: 'BenchNearby',
                size: 30,
                align: TextAlign.center,
                weight: FontWeight.w900,
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: (){
                  launchUrl(Uri.parse("mailto:info@apponauten.de?subject=&body="));
                },
                child: Row(
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
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: (){
                  launchUrl(Uri.parse("https://www.apponauten.de/"));
                },
                child: Row(
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
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: (){
                  launchUrl(Uri.parse("https://www.instagram.com/parkbank_apponauten/"));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/instagram.png',
                      height: 20,
                    ),
                    MyText(
                      paddingLeft: 10,
                      text: 'Find us on Instagram',
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }
}
