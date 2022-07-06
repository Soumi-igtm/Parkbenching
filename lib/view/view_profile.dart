import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkbenching/view/widget/my_text.dart';
import '../controller/bottom_nav_controller.dart';
import '../resources/auth_methods.dart';
import 'constant/color.dart';
import 'constant/common.dart';
import 'widget/custom_app_bar.dart';
import 'widget/my_button.dart';

import 'constant/images.dart';
import 'constant/validators.dart';

class ViewProfile extends StatefulWidget {
  final String uid;
  const ViewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final TextEditingController nameController = TextEditingController();
  late BottomNavController controller;
  String picture = "";
  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  loadUserData() {
    controller = Get.find<BottomNavController>();

    setState(() {
      nameController.text = controller.userSnap['name'];
    });
  }

  Future pickImage({bool fromGallery = false}) async {
    try {
      final image = await ImagePicker().pickImage(source: fromGallery ? ImageSource.gallery : ImageSource.camera);

      if (image == null) return;

      picture = image.path;
      Get.back();
      customToast("Uploading image...");
      try {
        String ext2 = picture.split(".").last;
        TaskSnapshot _pSnapshot =
            await FirebaseStorage.instance.ref('users/${widget.uid}/pic_${DateTime.now().millisecondsSinceEpoch}.$ext2').putFile(File(picture));
        String picUrl = await _pSnapshot.ref.getDownloadURL();
        AuthMethods.instance.updateField(uid: widget.uid, key: "image", value: picUrl);
        controller.fetchUser();
        customToast("Image updated");
        Get.off(() => ViewProfile(uid: widget.uid));
      } on FirebaseException catch (e) {
        customToast(e.toString());
      }
    } on PlatformException catch (e) {
      customToast("Failed to pick image");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'View Profile'),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Center(
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                controller.userSnap["image"].isEmpty
                    ? Image.asset(
                        kProfileIcon,
                        width: context.width / 2,
                        height: context.width / 2,
                        fit: BoxFit.fitHeight,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: controller.userSnap["image"],
                          placeholder: (context, s) => Image.asset(kProfileIcon),
                          width: context.width / 2,
                          height: context.width / 2,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.edit, color: kWhiteColor),
                  onPressed: () {
                    Get.bottomSheet(
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyButton(
                            text: "Gallery",
                            btnBgColor: kWhiteColor,
                            textColor: kTertiaryColor,
                            onPressed: () => pickImage(fromGallery: true),
                          ),
                          const Divider(),
                          MyButton(
                            text: "Camera",
                            btnBgColor: kWhiteColor,
                            textColor: kTertiaryColor,
                            onPressed: () => pickImage(),
                          )
                        ],
                      ),
                      backgroundColor: kWhiteColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: TextFormField(
                autofocus: false,
                controller: nameController,
                keyboardType: TextInputType.name,
                validator: nameValidator,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_pin_rounded),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Please enter your name",
                  suffix: GestureDetector(
                    onTap: () async {
                      if (nameController.text.isEmpty) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        return;
                      }
                      bool status = await AuthMethods.instance.updateField(uid: widget.uid, key: "name", value: nameController.text.trim());
                      if (status) {
                        controller.fetchUser();
                        customToast("Name updated");
                        Get.off(() => ViewProfile(uid: widget.uid));
                      }
                    },
                    child: MyText(text: "Update", size: 12, color: kTertiaryColor),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
        ],
      ),
    );
  }
}
