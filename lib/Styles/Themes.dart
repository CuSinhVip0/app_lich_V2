import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luanvan/Styles/Colors.dart';


class Themes{
	static final light = ThemeData(
		brightness: Brightness.light
	);
	static final dark = ThemeData(
		brightness: Brightness.dark,
	);
}
TextStyle get heading1Style{
	return TextStyle(
		fontFamily: 'Mulish',
			fontSize: 26,
			fontWeight: FontWeight.w500,
			color: Colors.black,
	);
}

TextStyle get headingStyle{
	return TextStyle(
			fontFamily: 'Mulish',
			fontSize: 18,
			fontWeight: FontWeight.w500,
			color: Get.isDarkMode ? Colors.white: Colors.black
	);
}
TextStyle get titleStyle{
	return
		TextStyle(
			fontFamily: 'Mulish',
			fontSize: 16,
			fontWeight: FontWeight.w400,
			color:Get.isDarkMode ? Colors.white: Colors.black
	);
}


TextStyle get subTitleStyle{
	return
		TextStyle(
			fontFamily: 'Mulish',
			fontSize: 14,
			fontWeight: FontWeight.w400,
			color:Get.isDarkMode? Colors.grey[400] : Colors.grey[600]
	);
}

TextStyle get subLikeTitleStyle{
	return
		TextStyle(
			fontFamily: 'Mulish',
			fontSize: 14,
			fontWeight: FontWeight.w700,
			color: RootColor.cam_nhat
		);
}


TextStyle get buttonLableStyle{
	return
		TextStyle(
			fontFamily: 'Mulish',
			fontSize: 16,
			fontWeight: FontWeight.w600,
			color: Colors.white
	);
}

TextStyle  CustomStyle (double size,Color color,FontWeight weight){
	return
		TextStyle(
			fontFamily: 'Mulish',
			fontSize: size,
			fontWeight: weight,
			color: Get.isDarkMode? Colors.white : color
	);
}

TextStyle  snackLabelStyle(Color color) {
	return
		TextStyle(
			fontFamily: 'Mulish',
			fontSize: 14,
			fontWeight: FontWeight.w400,
			color: color
	);
}

TextStyle AppBarTitleStyle (Color color){
	return TextStyle(
		fontFamily: 'Mulish',
		fontSize: 20,
		fontWeight: FontWeight.w600,
		color: Get.isDarkMode? Colors.white: color,
	);
}

