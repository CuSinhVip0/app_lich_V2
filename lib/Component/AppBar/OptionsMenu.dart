import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:luanvan/Common/Button/CustomButton.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import 'package:luanvan/Controller/Home/Calender.dart';
import 'package:luanvan/Controller/TaskList.dart';
import 'package:luanvan/pages/InformationDetailPage.dart';
import 'package:luanvan/pages/System/Setting.dart';

import '../../Styles/Colors.dart';
import '../../Styles/Themes.dart';
import '../../pages/LoginPage.dart';

class OptionsMenu extends StatelessWidget{
	UserController userController = Get.find();
	CalenderController calenderController = Get.find();
	TaskListController taskListController = Get.find();
	@override
  	Widget build(BuildContext context) {
		context.isDarkMode;
    	return Drawer(
			shape: const RoundedRectangleBorder(
				borderRadius: BorderRadius.only(
					topRight: Radius.circular(0),
					bottomRight: Radius.circular(0)),
			),
			elevation: 20.0,

			width: 320,
			child:Column(
				children: [
					Stack(children: [
						Container(
							height: 200,
							child: Image.asset(Get.isDarkMode ? 'assets/backgroundlogin_dark.png' :'assets/backgroundlogin.png',fit: BoxFit.cover,alignment: Alignment.topRight,)
						),

						Positioned(
							bottom: 0,
							child: Padding(
								padding: EdgeInsets.symmetric(vertical: 30,horizontal: 55),
								child: GetBuilder(
									init: UserController(),
									builder: (userController)=> userController.isLogin.value
										? Column(
										crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												CircleAvatar(
													backgroundColor: Colors.white,
													radius: 40.0,
													child: CircleAvatar(
														backgroundImage: NetworkImage(userController.userData['picture']['data']['url'],),
														radius: 100.0,
													),
												),
												SizedBox(height:4),
												Text(userController.userData['name'],style: CustomStyle(18, Colors.black, FontWeight.w700),)
											],
										)
										: Column(
										children: [
											// CustomButton(onTap: (){}, title: "Đăng ký",height: 40, width: 120,),
											Divider(height: 8.0),
											CustomButton(onTap: (){
												Get.to(()=>LoginPage());
											}, title: "signin",height: 40, width: 120,),
										],
									)
								),
							))
					]),
					Expanded(child: Container(
						color: Get.isDarkMode ? RootColor.den_body : Colors.white,
						child: GetBuilder(
							init: UserController(),
							builder: (userController)=>ListView(
								physics: NeverScrollableScrollPhysics(),
								padding: EdgeInsets.symmetric(horizontal: 20),
								children: <Widget>[
									userController.isLogin.value == true ? ListTile(
										leading: Icon(Icons.edit_note_outlined,color: Get.isDarkMode ? Colors.white: Colors.black,),
										title: Text('userInfor'.tr,style: CustomStyle(16,Colors.black,FontWeight.w400)),
										onTap: () {
											Get.to(()=>InformationDetailPage());
										},
									): SizedBox(),
									userController.isLogin.value == true ?  Divider(
										height: 2.0,
									): SizedBox(),
									ListTile(
										leading: Icon(Icons.headset_mic_outlined ,color: Get.isDarkMode ? Colors.white: Colors.black,),
										title: Text('custommerSp'.tr,style: CustomStyle(16,Colors.black,FontWeight.w400)),
										onTap: () {
											print(userController.userData.toString());
										},
									),
									Divider(
										height: 2.0,
									),
									ListTile(
										leading: Icon(Icons.payments_outlined, color: Get.isDarkMode ? Colors.white: Colors.black,),
										title: Text('payOfService'.tr,style: CustomStyle(16,Colors.black,FontWeight.w400)),
										onTap: () {
											print(userController.test.value);
										},
									),
									Divider(
										height: 2.0,
									),
									ListTile(
										leading: Icon(Icons.settings_rounded,color: Get.isDarkMode ? Colors.white: Colors.black,),
										title: Text('setting'.tr,style: CustomStyle(16,Colors.black,FontWeight.w400)),
										onTap: () {
											Get.to(()=>SettingsPage());
										},
									),
									Divider(
										height: 2.0,
									),
									userController.isLogin.value == true ? ListTile(
										leading: Icon(Icons.login_outlined,color: Get.isDarkMode ? Colors.white: Colors.black,),
										title: Text('signout'.tr,style: CustomStyle(16,Colors.black,FontWeight.w400)),
										onTap: () async {
											bool res = userController.typeLogin == "FB"
												? await userController.logoutFaceBook()
												: userController.typeLogin == "GG"
												? await userController.logoutGoogle()
												: false;
											if(res)  {
												Get.snackbar("Đăng xuất thành công", 'Hẹn gặp lại');
												calenderController.getDateEventToSetBookmark(taskListController.selectedDate.month,taskListController.selectedDate.year);
												taskListController.getTasks();
											} else Get.snackbar("Đăng xuất không thành công", 'Vui lòng thử lại') ;
										},
									): SizedBox()
								],
							),
						),
					))
				],
			)
		);
  	}
}