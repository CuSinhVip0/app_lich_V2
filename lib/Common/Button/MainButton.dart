import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luanvan/Styles/Colors.dart';
import '../../Styles/Themes.dart';

class MainButton extends StatelessWidget{
	Function() onTap;
	String title;
	MainButton({
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
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(12),
					color:RootColor.cam_nhat,
				),
				child:Center(
					child: Text(title, style: buttonLableStyle),
				),
			),
		);
    }
}
