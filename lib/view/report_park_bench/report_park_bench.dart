import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/custom_bottom_app_bar.dart';

import 'package:park_benching/view/widget/my_text.dart';

class ReportParkBench extends StatefulWidget {
  const ReportParkBench({Key? key}) : super(key: key);

  @override
  State<ReportParkBench> createState() => _ReportParkBenchState();
}

class _ReportParkBenchState extends State<ReportParkBench> {
  int _value = 1;
  int _value2 = 1;
  int _value3 = 1;
  int _value4 = 1;
  int _value5 = 1;
  File? image;

  Future pickImage() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e){
      print("failed to pick image: $e");
    }
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppBar(
        title: 'Report Park Bench',
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          //dummy Bench Location
          Image.asset(
            'assets/images/map_2.png',
            height: 168,
            fit: BoxFit.cover,
          ),
          takePictureOfBench(
            () {},
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                heading(
                  'Cleanliness',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    Column(
                      children: [
                        Radio(
                            value: 1,
                            groupValue: _value,
                            onChanged: (value){
                              setState(() {
                                _value= value as int;
                              });
                            },
                        ),
                        Text("very clean"),
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _value,
                          onChanged: (value){
                            setState(() {
                              _value= value as int;
                            });
                          },
                        ),
                        Text("clean"),
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 3,
                          groupValue: _value,
                          onChanged: (value){
                            setState(() {
                              _value= value as int;
                            });
                          },
                        ),
                        Text("dirty"),
                      ],
                    ),
                  ],
                ),
                heading(
                  'Position',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    Column(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _value2,
                          onChanged: (value){
                            setState(() {
                              _value2= value as int;
                            });
                          },
                        ),
                        Text("park")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _value2,
                          onChanged: (value){
                            setState(() {
                              _value2= value as int;
                            });
                          },
                        ),
                        Text("bus stop")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 3,
                          groupValue: _value2,
                          onChanged: (value){
                            setState(() {
                              _value2= value as int;
                            });
                          },
                        ),
                        Text("forest path/track")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 4,
                          groupValue: _value2,
                          onChanged: (value){
                            setState(() {
                              _value2= value as int;
                            });
                          },
                        ),
                        Text("pedetrian zone")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 5,
                          groupValue: _value2,
                          onChanged: (value){
                            setState(() {
                              _value2= value as int;
                            });
                          },
                        ),
                        Text("street")
                      ],
                    ),
                  ],
                ),
                heading(
                  'View',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    Column(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _value3,
                          onChanged: (value){
                            setState(() {
                              _value3= value as int;
                            });
                          },
                        ),
                        Text("wonderful")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _value3,
                          onChanged: (value){
                            setState(() {
                              _value3= value as int;
                            });
                          },
                        ),
                        Text("changeable")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 3,
                          groupValue: _value3,
                          onChanged: (value){
                            setState(() {
                              _value3= value as int;
                            });
                          },
                        ),
                        Text("relaxed")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 4,
                          groupValue: _value3,
                          onChanged: (value){
                            setState(() {
                              _value3= value as int;
                            });
                          },
                        ),
                        Text("on the traffic")
                      ],
                    ),
                  ],
                ),
                heading(
                  'Reachability',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    Column(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _value4,
                          onChanged: (value){
                            setState(() {
                              _value4= value as int;
                            });
                          },
                        ),
                        Text("car")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _value4,
                          onChanged: (value){
                            setState(() {
                              _value4= value as int;
                            });
                          },
                        ),
                        Text("bicycle")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 3,
                          groupValue: _value4,
                          onChanged: (value){
                            setState(() {
                              _value4= value as int;
                            });
                          },
                        ),
                        Text("on foot")
                      ],
                    ),
                  ],
                ),
                heading(
                  'Equipment',
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    Column(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _value5,
                          onChanged: (value){
                            setState(() {
                              _value5= value as int;
                            });
                          },
                        ),
                        Text("several benches")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _value5,
                          onChanged: (value){
                            setState(() {
                              _value5= value as int;
                            });
                          },
                        ),
                        Text("table")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 3,
                          groupValue: _value5,
                          onChanged: (value){
                            setState(() {
                              _value5= value as int;
                            });
                          },
                        ),
                        Text("canopy")
                      ],
                    ),
                    Column(
                      children: [
                        Radio(
                          value: 4,
                          groupValue: _value5,
                          onChanged: (value){
                            setState(() {
                              _value5= value as int;
                            });
                          },
                        ),
                        Text("garbage can")
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          heading('Rating'),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            itemSize: 16.20,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            glow: false,
                            itemPadding: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            unratedColor: const Color(0xffCCCFD9),
                            itemBuilder: (context, _) => Image.asset(
                              kRatingStar,
                              height: 16.20,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: reportBrokenBench(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        heading('Message'),
                        MyText(
                          paddingTop: 10,
                          paddingLeft: 5,
                          text: '(optional)',
                          size: 13,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: TextFormField(
                        style: const TextStyle(
                          color: kTertiaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Mulish',
                        ),
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Write your message',
                          filled: true,
                          fillColor: kWhiteColor,
                          hintStyle: TextStyle(
                            color: kTertiaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Mulish',
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
          prototypeItem:
          ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        content: Text("Report Submitted Successfully"),
                      ),

                );
              }
              ),
                ),
                );
  }
  Widget takePictureOfBench(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        margin: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: kSecondaryColor,
            width: 1.0,
          ),
          color: kSecondaryColor.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kCameraIcon,
              height: 10.33,
            ),
            MaterialButton(
              color: Colors.green[100],
              child: const Text("Take picture of park bench",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Mulish"
                ),
              ),
              onPressed: () {
                pickImage();
              },
            ),
            image!=null ? Image.file(image!): Text("no image selected")
          ],
        ),
      ),
    );
  }

  Widget reportBrokenBench() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppLinks.report),
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: kSecondaryColor,
            width: 1.0,
          ),
          color: kSecondaryColor.withOpacity(0.05),
        ),
        child: Center(
          child: MyText(
            text: 'Report broken bench',
            size: 13,
            weight: FontWeight.w700,
            fontFamily: 'Mulish',
          ),
        ),
      ),
    );
  }

  Widget heading(String heading) {
    return MyText(
      text: heading,
      size: 16,
      weight: FontWeight.w700,
      color: kTertiaryColor,
      paddingBottom: 15,
      paddingTop: 35,
    );
  }


}
