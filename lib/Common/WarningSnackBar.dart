import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Styles/Themes.dart';

SnackBar WarningSnackBar(String label) {
	return SnackBar(
		duration: const Duration(seconds: 1),
		backgroundColor: Colors.transparent,
		elevation: 0,
		content: Container(
			margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
			padding: EdgeInsets.fromLTRB(16, 10, 23, 10),
			decoration: BoxDecoration(
				color: const Color.fromRGBO(255,242,199, 1),
				border: Border.all(
					color: const Color.fromRGBO(236,206,97, 1),
					width: 1
				),
				borderRadius: BorderRadius.circular(10)
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Container(
						decoration: ShapeDecoration(
							color: Colors.white,
							shape: CircleBorder(),
						),
						child:Icon(
							Icons.check_circle_outlined,
							color: Color.fromRGBO(214,173,19,1)
						)
					),
					SizedBox(width: 8),
					Text(
						label,
						style: snackLabelStyle(Color.fromRGBO(214,173,19,1)),
					),
				],
			),
		),
	);
}