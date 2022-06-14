import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_benching/controller/bottom_nav_controller.dart';
import 'package:park_benching/resources/auth_methods.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/common.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';

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
                Image.asset(
                  kProfileIcon,
                  width: context.width / 2,
                  height: context.width / 2,
                  fit: BoxFit.fitHeight,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.edit, color: kWhiteColor),
                  onPressed: () {},
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
                    child: const Icon(Icons.check_circle, size: 18, color: kSecondaryColor),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
        ],
      ),
    );
  }
}
