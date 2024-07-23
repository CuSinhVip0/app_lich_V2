import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/Styles/Themes.dart';

class NoInternet extends StatelessWidget {
  	@override
  	Widget build(BuildContext context) {
    	return Card(
			surfaceTintColor: Colors.white,
			child: Container(
				padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
				child: Column(
					children: [
						Container(
							child: Text("Nointernetconnection".tr,
								style: CustomStyle(20, RootColor.cam_nhat, FontWeight.w600),
							)
						),
						SizedBox(height: 8,),
						Container(
							child: Text("Pleaseconnecttotheinternetandtryagain".tr,style: subTitleStyle,)
						),
					],
				),
			)
		);
  	}
}