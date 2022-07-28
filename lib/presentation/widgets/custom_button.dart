import 'package:algoriza_todo_app/core/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.text,
      this.backgroundColor = myGreen,
      required this.onTap,
      this.padding})
      : super(key: key);
  final String text;
  final Color backgroundColor;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .065,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: myWhite,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
