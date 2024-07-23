
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:luanvan/Controller/Status/UpdateController.dart';

import 'package:luanvan/Styles/Colors.dart';
import '../../Controller/Component/UserController.dart';

import '../../Styles/Themes.dart';

class UpdatePage extends StatelessWidget {
	dynamic payload;
	Widget icon;
	UpdatePage(this.payload,this.icon);
	TextEditingController textEditingController = TextEditingController();
	UpdateController updateController = UpdateController();
	UserController userController = Get.find();
	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		print(payload);
		return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title:Text(payload['title'],style: headingStyle,),
			),
			body:SingleChildScrollView(
				physics: BouncingScrollPhysics(),
				child: Column(
					children: [
						Container(
							padding: EdgeInsets.all(20),
							child: Column(
								children: [
									Text(payload['content'],style: CustomStyle(14, Colors.black, FontWeight.w400),),
									SizedBox(height: 16,),
									Container(
										child: ListTile(
											shape: RoundedRectangleBorder(
												side: BorderSide(
													color: Colors.grey,
													width: 1,
												),
												borderRadius: BorderRadius.circular(8)
											),
											minVerticalPadding: 0, // else 2px still present
											dense: true, // else 2px still present
											leading: icon ?? SizedBox(),
											title: TextFormField(
												autofocus: true,
												controller: textEditingController,
												cursorColor: Colors.grey[400],
												style:CustomStyle(16, Colors.black, FontWeight.w400),
												decoration: InputDecoration(
													contentPadding: EdgeInsets.zero,
													hintText: payload['hint'],
													hintStyle:  subTitleStyle ,
													focusedBorder: UnderlineInputBorder(
														borderSide: BorderSide(
															color:Colors.transparent,
															width: 0
														)
													),
													enabledBorder: UnderlineInputBorder(
														borderSide: BorderSide(
															color:Colors.transparent,
															width: 0
														)
													),
													disabledBorder: UnderlineInputBorder(
														borderSide: BorderSide(
															color:Colors.transparent,
															width: 0
														)
													),
												),

											)),
									),
									SizedBox(height: 12,),
									Container(
										child: Center(
											child: Obx(()=>CupertinoButton(
												color: RootColor.cam_nhat,
												onPressed:updateController.loading.value == true ? null : () async{
													updateController.loading.value = true;
													bool res = await updateController.updateInforToDatabase(payload['key'],userController.userData['id'],textEditingController.text);
													res == true
														? Get.back()
														: Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
													updateController.loading.value = false;
												},
												disabledColor: RootColor.disable,
												child: Text("Cập nhật",style: buttonLableStyle,),
											),)
										),
									)
								],
							),
						),
					],
				),
			));
	}

}