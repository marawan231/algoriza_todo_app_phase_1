import 'dart:math';

import 'package:flutter/material.dart';

const Color myRed = Color(0xffFF5147);
const Color myOrange = Color(0xffFF9D42);
const Color myYellow = Color(0xffF9C50B);
const Color myBlue = Color(0xff42A0FF);
const Color myGreen = Color(0xff25C06D);
const Color myGrey = Color(0xffF9F9F9);
const Color myDarkGrey = Color(0xFFD3D3D3);
const Color myBlack = Color(0xff222222);
const Color myWhite = Color(0xFFFFFFFF);

List<Color> colors = [
  myBlack,
  myBlue,
  myDarkGrey,
  myGreen,
  myOrange,
  myRed,
  myYellow
];

final Color randomColor = colors[Random().nextInt(colors.length)];
