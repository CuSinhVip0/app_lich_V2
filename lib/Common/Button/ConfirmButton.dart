import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luanvan/Styles/Colors.dart';
import '../../Styles/Themes.dart';

class ConfirmButton extends StatelessWidget{
	Function() onTap;
	String title;
	ConfirmButton({
		Key? key,
		required this.onTap,
		required this.title,
	}):super(key:key);

	@override
    Widget build(BuildContext context) {
    	return GestureDetector(
			onTap: onTap,
			child: Container(
				height: 52,
				width: 180,
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(32),
					color:RootColor.cam_nhat,
				),
				child:Center(
					child: Text(title.tr, style: buttonLableStyle),
				),
			),
		);
    }
}
