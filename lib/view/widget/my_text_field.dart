import 'package:flutter/material.dart';
import 'package:park_benching/view/constant/color.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var hintText;
  bool? obSecure;
  double? paddingBottom,contentPadding;
  TextEditingController? controller = TextEditingController();
  ValueChanged<String>? onChanged;

  MyTextField({
    Key? key,
    this.hintText,
    this.onChanged,
    this.controller,
    this.obSecure = false,
    this.paddingBottom = 15.0,
    this.contentPadding = 20.0,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.paddingBottom!,
      ),
      child: TextFormField(
        onChanged: widget.onChanged,
        style: const TextStyle(
          color: kTertiaryColor,
          fontSize: 12,
        ),
        obscureText: widget.obSecure!,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: kTertiaryColor,
            fontSize: 12,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.contentPadding!,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: kBorderColor,
              width: 1.0,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: kBorderColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
