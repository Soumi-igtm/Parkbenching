import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/send_location_controller.dart';

class SendLocation extends GetView<SendLocationController> {
  final TextEditingController _textEditingController = TextEditingController();

  SendLocation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Send location'),

      body: Column(
        children: [

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: context.height / 3.5,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: controller.googleLocation,
                  onMapCreated: (GoogleMapController googleMapController) {
                    controller.mapController.complete(googleMapController);
                  },
                  onCameraMove: (CameraPosition position) {
                    controller.currentPosition = position.target;
                  },
                ),
                const Icon(Icons.location_on, size: 30)
              ],
            ),
          ),
          MyText(
            text: 'Here you can send your location to friends or post your favourite park benches on social media',
            fontFamily: 'Mulish',
            size: 12,
            paddingTop: 20,
            paddingLeft: 40,
            paddingRight: 40,
            paddingBottom: 20.0,
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _textEditingController,
          //     decoration: const InputDecoration(border: OutlineInputBorder(), label: Text("Enter the location")),
          //   ),
          // ),
          // ElevatedButton(
          //   child: Text("Share the location"),
          //   onPressed: () async {
          //     final Url =
          //         'https://www.google.com/maps/place/Siraj+Garden/@22.7210037,88.4839073,17z/data=!4m9!1m2!2m1!1sshiraj+uddan!3m5!1s0x39f8a3b334cb6649:0xf72daa97efc19';
          //     if (_textEditingController.value.text.isNotEmpty) {
          //       await Share.share('${_textEditingController.text} ${Url}');
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
