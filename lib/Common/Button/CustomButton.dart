import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luanvan/Styles/Colors.dart';
import '../../Styles/Themes.dart';

class CustomButton extends StatelessWidget{
	Function() onTap;
	String title;
	double? width;
	double? height;
	Color? bgColor;
	Color? txtColor;
	Color? borderColor;
	CustomButton({
		Key? key,
		required this.onTap,
		required this.title,
		this.height,
		this.width,
		this.bgColor,
		this.txtColor,
		this.borderColor
	}):super(key:key);

	@override
    Widget build(BuildContext context) {
    	return GestureDetector(
			onTap: onTap,
			child: Container(
				height: height ?? 52,
				width: width ?? 180,
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(32),
					color:bgColor ??  (Get.isDarkMode ? RootColor.button_darkmode : RootColor.cam_nhat),
					border: Border.all(
						color: borderColor ?? (Get.isDarkMode ? RootColor.button_darkmode : RootColor.cam_nhat)
					)
				),
				child:Center(
					child: Text(title.tr, style: CustomStyle(14,txtColor ?? Colors.white ,FontWeight.w600),),
				),
			),
		);
    }
}
