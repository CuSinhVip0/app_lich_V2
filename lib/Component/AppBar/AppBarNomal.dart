import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Styles/Themes.dart';

Widget AppBarNomal (String text){
	return AppBar(
		centerTitle: true,
		title: Text(
			text,
			style: AppBarTitleStyle(Colors.black)
		),
		backgroundColor: Colors.transparent, // <-- this
		shadowColor: Colors.transparent,

	);
}