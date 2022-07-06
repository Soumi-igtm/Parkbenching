import 'package:flutter/material.dart';
import 'package:park_benching/view/widget/custom_app_bar.dart';
import 'package:park_benching/view/widget/custom_bottom_app_bar.dart';
import 'package:park_benching/view/widget/my_text.dart';
import 'package:park_benching/view/widget/my_text_field.dart';

class Report extends StatelessWidget {
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Report Broken Bench',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: [
            MyText(
              text:
                  'if it’s an issue with a park bench, please attach the report  the issue',
              fontFamily: 'Mulish',
              size: 12,
              paddingBottom: 20.0,
            ),
            MyTextField(
              hintText: 'Describe park bench issue',
              contentPadding: 0.0,
            )
          ],
        ),
      ),
      bottomNavigationBar: customBottomAppBar(
        'Send message',
        () {},
      ),
    );
  }
}
