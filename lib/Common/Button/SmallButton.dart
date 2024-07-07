import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luanvan/Styles/Colors.dart';
import '../../Styles/Themes.dart';

class SmallButton extends StatelessWidget{
	Function() onTap;
	Widget widget;
	bool? disable;
	SmallButton({
		Key? key,
		required this.onTap,
		required this.widget,
		this.disable
	}):super(key:key);

	@override
    Widget build(BuildContext context) {
    	return GestureDetector(
			onTap: onTap,
			child: Container(
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(12),
					color:disable == false ? RootColor.cam_nhat : RootColor.disable,
				),
				child: widget,
			),
		);
    }
}
