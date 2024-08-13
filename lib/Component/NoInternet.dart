import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luanvan/Common/Button/ConfirmButton.dart';
import 'package:luanvan/Common/Button/CustomButton.dart';
import 'package:luanvan/Common/Button/SmallButton.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/Styles/Themes.dart';

class NoInternet extends StatelessWidget {
	Function() tryagain;
	NoInternet(this.tryagain);
  	@override
  	Widget build(BuildContext context) {
    	return Card(
			surfaceTintColor: Colors.white,
			child: Container(
				height: 150,
				padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
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
						SizedBox(height: 8,),
						CustomButton(onTap: tryagain, title: "tryagain",height: 40,width: 100,)
					],
				),
			)
		);
  	}
}