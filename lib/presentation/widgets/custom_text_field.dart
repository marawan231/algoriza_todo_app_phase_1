import 'package:algoriza_todo_app/core/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final double width;
  final double height;
  final Color borderColor;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? suffixIcon;
  final void Function()? onPressed;
  final String text;
  final void Function()? onEditingComplete;
  final double? suffixIconSize;

  const CustomTextField({
    Key? key,
    this.width = 0.9,
    this.height = .07,
    this.borderColor = myGrey,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.onPressed,
    required this.text,
    this.onEditingComplete,
    this.suffixIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      // padding: EdgeInsets.only(
      //   top: MediaQuery.of(context).size.height * .02,
      //   // left: MediaQuery.of(context).size.width * .07,
      //   // right: MediaQuery.of(context).size.width * .07,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            width: size.width * width,
            height: size.height * height,
            decoration: BoxDecoration(
              color: myGrey,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: TextField(
              onEditingComplete: onEditingComplete,
              textAlign: TextAlign.left,
              controller: controller,
              style: const TextStyle(
                  color: myDarkGrey, fontWeight: FontWeight.w900),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 15, top: 17),
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                    color: myDarkGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                alignLabelWithHint: false,
                suffixIcon: IconButton(
                  icon: Icon(
                    suffixIcon,
                    color: myDarkGrey,
                    size: suffixIconSize,
                  ),
                  onPressed: onPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
