import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:luanvan/Component/Status/UpdatePage.dart';
import 'package:luanvan/utils/lunar_solar_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../Controller/InformationDetailController.dart';
import '../Styles/Colors.dart';
import '../Styles/Themes.dart';
import '../utils/CalculateAge.dart';

class InformationDetailPage extends StatelessWidget{
	InformationDetailController informationDetailController = Get.put(InformationDetailController());
	@override
  	Widget build(BuildContext context) {
		context.isDarkMode;
    	return Scaffold(
			backgroundColor: RootColor.bg_body,
			appBar: AppBar(
				centerTitle: true,
				title: Text("Thông tin cá nhân", style: AppBarTitleStyle(Get.isDarkMode ? Colors.white : Colors.black),),
			),
			body: SafeArea(
				child:GetBuilder(
					init: InformationDetailController(),
					builder: (informationDetailController)=> Skeletonizer(
						enabled: !informationDetailController.InforUser.isNotEmpty,
						child:informationDetailController.InforUser.isNotEmpty
							? Stack(
							children: [
								Container(

									padding: EdgeInsets.all(12),
									child: SingleChildScrollView(
										padding: EdgeInsets.only(bottom: 75),
										physics: BouncingScrollPhysics(),
										child: Column(
											children:[
												Card(
													elevation: 1,
													shadowColor: Colors.transparent,
													surfaceTintColor: Colors.white,
													child: Column(
														children: [
															/*----- ||   Avartar   || -----*/
															Container(
																padding: EdgeInsets.symmetric(vertical: 25),
																child: Center(
																	child: Column(
																		children: [
																			CircleAvatar(
																				backgroundColor: Colors.white,
																				radius: 50.0,
																				child: CircleAvatar(
																					backgroundImage: NetworkImage(informationDetailController.InforUser['UrlPic']),
																					radius: 100.0,
																				)

																			),
																			SizedBox(height: 8,),
																			Text(informationDetailController.InforUser['Name'] ?? "Người dùng mới",style: CustomStyle(20, Colors.black, FontWeight.w600),)
																		],
																	),
																),
															),
															/*----- || End avartar || -----*/
															SizedBox(height: 12,),
															Card(
																margin: EdgeInsets.all(0),
																elevation: 2,
																shadowColor: Colors.transparent,
																surfaceTintColor: Colors.white,
																child: Container(
																	child: Column(
																		children: [
																			/*----- ||   Ngày sinh dương lịch   || -----*/
																			GestureDetector(
																				onTap: () async{
																					var a = await showCupertinoModalPopup(
																						context: context,
																						builder: (_) => Container(
																							height: 190,
																							color: Color.fromARGB(255, 255, 255, 255),
																							child: Column(
																								children: [
																									Container(
																										height: 180,
																										child: CupertinoDatePicker(
																											mode: CupertinoDatePickerMode.date,
																											initialDateTime: DateTime.now(),
																											onDateTimeChanged: (val) {
																												informationDetailController.updateInforUser('Birth', val.toString().split(' ')[0]);
																											}),
																									),
																								],
																							),
																						));
																				},
																				child: ListTile(
																					contentPadding: EdgeInsets.symmetric(horizontal: 12),
																					leading: Icon(FluentIcons.food_cake_20_regular,size: 28,),
																					title: Row(
																						children: [
																							IntrinsicWidth(
																								child: Text("Ngày sinh dương lịch",style: titleStyle)
																							),
																							Expanded(child: Container(
																								child: Row(
																									children: [
																										Expanded(
																											child: Align(
																												alignment: Alignment.centerRight,
																												child:Text(informationDetailController.InforUser['Birth'].toString().split('-').reversed.join('/') ??"",style: titleStyle),
																											)
																										),
																										IntrinsicWidth(
																											child: Icon(FluentIcons.ios_chevron_right_20_filled),
																										)
																									],
																								),
																							))
																						],
																					),
																				),
																			),
																			/*----- || End Ngày sinh dương lịch || -----*/

																			/*----- ||   Ngày sinh âm lịch   || -----*/
																			Container(
																				padding: EdgeInsets.only(left: 12),
																				child: Row(
																					children: [
																						Expanded(child: ListTile(
																							contentPadding: EdgeInsets.symmetric(horizontal: 0),
																							leading: Icon(FluentIcons.food_cake_20_regular,size: 28,),
																							title: Row(
																								children: [
																									IntrinsicWidth(
																										child: Text("Ngày sinh âm lịch",style: titleStyle)
																									),
																								],
																							),
																							subtitle: GetBuilder(
																								init: InformationDetailController(),
																								builder: (informationDetailController) {
																									var arrSolar =  informationDetailController.InforUser['Birth'].toString().split('-') ;
																									var lunar = convertSolar2Lunar(int.parse(arrSolar[2]), int.parse(arrSolar[1]), int.parse(arrSolar[0]), 7);
																									return Text(informationDetailController.InforUser['Birth']?.toString() != null
																										?'Ngày ${getCanDay(jdn(int.parse(arrSolar[2]), int.parse(arrSolar[1]), int.parse(arrSolar[0])))}, ${lunar[1]}/${lunar[1]} năm ${getCanChiYear(lunar[2])}'
																										:'',style: subTitleStyle);
																								},
																							),


																						),),
																					],
																				),
																			),
																			/*----- || End Ngày sinh âm lịch || -----*/

																			/*----- ||   Tuổi của bạn   || -----*/
																			Container(
																				padding: EdgeInsets.only(left: 12),
																				child: Row(
																					children: [
																						Expanded(child: ListTile(
																							contentPadding: EdgeInsets.symmetric(horizontal: 0),
																							leading: Icon(FluentIcons.timer_20_regular,size: 28,),
																							title: Row(
																								children: [
																									IntrinsicWidth(
																										child: Text("Tuổi của bạn",style: titleStyle,)
																									),
																								],
																							),
																							subtitle: GetBuilder(
																								init: InformationDetailController(),
																								builder: (informationDetailController) {
																									var arrSolar =  informationDetailController.InforUser['Birth'].toString().split('-') ;
																									return  Text(informationDetailController.InforUser['Birth'].toString() != null
																										?CalculateAge(DateTime(int.parse(arrSolar[0]),int.parse(arrSolar[1]),int.parse(arrSolar[2])))
																										:'',style: subTitleStyle,);
																								},
																							),


																						),),
																					],
																				),
																			),
																			/*----- || End Tuổi của bạn || -----*/

																			/*----- ||   Giới tính   || -----*/
																			GestureDetector(
																				onTap: ()async{
																					var a = await showCupertinoModalPopup(
																						context: context,
																						builder: (_) => Container(
																							height: 190,
																							color: Color.fromARGB(255, 255, 255, 255),
																							child: Column(
																								children: [
																									Container(
																										height: 180,
																										child: CupertinoPicker(
																											backgroundColor: Colors.white,
																											itemExtent: 30,
																											scrollController: FixedExtentScrollController(
																												initialItem: 1
																											),
																											onSelectedItemChanged: (int value) {
																												informationDetailController.updateInforUser("Gender", value);
																											},
																											children: [
																												Text("Nam"),
																												Text("Nữ"),
																											],
																										)
																									),
																								],
																							),
																						));
																				},
																				child:ListTile(
																					contentPadding: EdgeInsets.symmetric(horizontal: 12),
																					leading: Icon(FluentIcons.person_heart_20_regular,size: 28,),
																					title: Row(
																						children: [
																							IntrinsicWidth(
																								child: Text("Giới tính")
																							),
																							Expanded(child: Container(
																								child: Row(
																									children: [
																										Expanded(
																											child: Align(
																												alignment: Alignment.centerRight,
																												child: Text(informationDetailController.InforUser['Gender'] != null
																													?(informationDetailController.InforUser['Gender']==1?"Nữ":"Nam")
																													:"",textAlign: TextAlign.end,),
																											)
																										),
																										IntrinsicWidth(
																											child: Icon(FluentIcons.ios_chevron_right_20_filled),
																										)
																									],
																								),
																							))
																						],
																					),
																				),
																			),

																			/*----- || End Giới tính || -----*/

																			/*----- ||   Ngũ hành   || -----*/
																			ListTile(
																				contentPadding: EdgeInsets.symmetric(horizontal: 8),
																				leading: Icon(FluentIcons.book_contacts_20_regular,size: 28,),
																				title: Row(
																					children: [
																						IntrinsicWidth(
																							child: Text("Ngũ hành")
																						),
																						Expanded(child: Container(
																							child: Row(
																								children: [
																									Expanded(
																										child: Align(
																											alignment: Alignment.centerRight,
																											child: Text("Nam",textAlign: TextAlign.end,),
																										)
																									),
																									IntrinsicWidth(
																										child: Icon(FluentIcons.ios_chevron_right_20_filled,color: Colors.transparent,),
																									)
																								],
																							),
																						))
																					],
																				),
																			),
																			/*----- || End ngũ hành || -----*/

																			/*----- ||   Cung mệnh   || -----*/
																			ListTile(
																				contentPadding: EdgeInsets.symmetric(horizontal: 12),
																				leading: Icon(FluentIcons.star_20_regular,size: 28,),
																				title: Row(
																					children: [
																						IntrinsicWidth(
																							child: Text("Cung mệnh")
																						),
																						Expanded(child: Container(
																							child: Row(
																								children: [
																									Expanded(
																										child: Align(
																											alignment: Alignment.centerRight,
																											child: Text("Đoài",textAlign: TextAlign.end,),
																										)
																									),
																									IntrinsicWidth(
																										child: Icon(FluentIcons.ios_chevron_right_20_filled,color: Colors.transparent,),
																									)
																								],
																							),
																						))
																					],
																				),
																			),
																			/*----- || End Cung mệnh || -----*/
																		],
																	),
																),
															),
														],
													),
												),

												/*-----||   Nghề nghiệp   ||-----*/
												Card(
													surfaceTintColor: Colors.white,
													elevation: 2,
													child: GestureDetector(
														onTap: (){
															Get.to(()=>UpdatePage({
																'title': 'Cập nhật nghề nghiệp',
																'content':'Chưa có nội dung gì cả',
																'hint':"Nhập nghề nghiệp...",
																'key':"Job"
															},Icon(FluentIcons.wrench_screwdriver_20_regular,size: 26)
															));
														},
														child: Container(
															child: Row(
																children: [
																	Expanded(
																		flex:5,
																		child: ListTile(
																			leading: Iconify(EmojioneV1.hammer_and_wrench,size: 24,),
																			title:Text("Nghề nghiệp",style: titleStyle,),
																			subtitle: Text(informationDetailController.InforUser['Job']?.toString() != null
																				? informationDetailController.InforUser['Job']
																				: "Nhập nghề nghiệp",style: subTitleStyle,),
																		),),
																	Expanded(
																		flex: 1,
																		child: Container(
																			padding: EdgeInsets.symmetric(vertical: 20),
																			child: Icon(FluentIcons.arrow_circle_right_20_regular,size: 30,),
																		),
																	)
																],
															),
														),
													)
												),
												/*-----|| End Nghề nghiệp ||-----*/

												/*-----||   Số diện thoại   ||-----*/
												Card(
													surfaceTintColor: Colors.white,
													elevation: 2,
													child: GestureDetector(
														onTap: (){
															Get.to(()=>UpdatePage({
																'title': 'Cập nhật số điện thoại',
																'content':'Chưa có nội dung gì cả',
																'hint':"Nhập số điện thoại...",
																'key':"Phone"
															},Icon(FluentIcons.call_20_regular,size: 26)
															));
														},
														child: Container(
															child: Row(
																children: [
																	Expanded(
																		flex:5,
																		child: ListTile(
																			leading: Iconify(EmojioneV1.telephone_receiver,size: 24,),
																			title:Text("Số điện thoại",style: titleStyle,),
																			subtitle: Text(informationDetailController.InforUser['Phone']?.toString() != null
																				? informationDetailController.InforUser['Phone']
																				:"Nhập số điện thoại",style: subTitleStyle,),
																		),),
																	Expanded(
																		flex: 1,
																		child: Container(
																			padding: EdgeInsets.symmetric(vertical: 20),
																			child: Icon(FluentIcons.arrow_circle_right_20_regular,size: 30,),
																		),
																	)
																],
															),
														),
													)
												),
												/*-----|| End Số diện thoại ||-----*/

												/*-----||  Email ||-----*/
												Card(
													surfaceTintColor: Colors.white,
													elevation: 2,
													child: GestureDetector(
														onTap: (){
															Get.to(()=>UpdatePage({
																'title': 'Cập nhật email',
																'content':'Chưa có nội dung gì cả',
																'hint':"Nhập email...",
																'key':"Email"
															},Icon(FluentIcons.mail_20_regular,size: 26)
															));
														},
														child: Container(
															child: Row(
																children: [
																	Expanded(
																		flex:5,
																		child: ListTile(
																			leading: Iconify(EmojioneV1.e_mail,size: 24,),
																			title:Text("Email",style: titleStyle,),
																			subtitle: Text(informationDetailController.InforUser['Email']?.toString() != null
																				?informationDetailController.InforUser['Email']
																				:"Nhập email",style: subTitleStyle,),
																		),),
																	Expanded(
																		flex: 1,
																		child: Container(
																			padding: EdgeInsets.symmetric(vertical: 20),
																			child: Icon(FluentIcons.arrow_circle_right_20_regular,size: 30,),
																		),
																	)
																],
															),
														),
													)
												),
												/*-----|| End Email ||-----*/

												/*-----||    Địa chỉ  ||-----*/
												Card(
													surfaceTintColor: Colors.white,
													elevation: 2,
													child: GestureDetector(
														onTap: (){
															Get.to(()=>UpdatePage({
																'title': 'Cập nhật địa chỉ',
																'content':'Chưa có nội dung gì cả',
																'hint':"Nhập địa chỉ...",
																'key':"Address"
															},Icon(FluentIcons.location_ripple_20_regular,size: 26)
															));
														},
														child: Container(
															child: Row(
																children: [
																	Expanded(
																		flex:5,
																		child:ListTile(
																			leading: Iconify(EmojioneV1.flag_for_vietnam,size: 24,),
																			title:Text("Địa chỉ",style: titleStyle,),
																			subtitle: Text(informationDetailController.InforUser['Address']?.toString() != null
																				?informationDetailController.InforUser['Address']
																				:"Nhập địa chỉ",style: subTitleStyle,),
																		),),
																	Expanded(
																		flex: 1,
																		child: Container(
																			padding: EdgeInsets.symmetric(vertical: 20),
																			child: Icon(FluentIcons.arrow_circle_right_20_regular,size: 30,),
																		),
																	)
																],
															),
														),
													)
												),
												/*-----|| End Địa chỉ ||-----*/
											],
										)
									)
								),
								Positioned(
									bottom: 0,
									right: 0,
									left: 0,
									child: Card(
										margin: EdgeInsets.zero,
										elevation: 0,
										surfaceTintColor: Colors.white,
										child: Container(
											height: 80,
											decoration: BoxDecoration(
												color: Colors.white,
												borderRadius: BorderRadius.circular(8),
												boxShadow: [
													BoxShadow(
														color: Colors.grey.withOpacity(0.5),
														spreadRadius: 0,
														blurRadius: 5,
														offset: Offset(0, -3),
													),
												],
											),
											child: Center(
												child: Obx(()=>CupertinoButton(
													color: RootColor.cam_nhat,
													onPressed:informationDetailController.loading.value == true ? null : () async{
														informationDetailController.loading.value = true;
														bool res = await informationDetailController.updateInforToDatabase_V2();
														res == true
															?  Get.snackbar("Thành công","Các thay đổi đã được cập nhật",snackPosition: SnackPosition.TOP)
															: Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
														informationDetailController.loading.value = false;
													},
													disabledColor: RootColor.disable,
													child: Text("Cập nhật",style: buttonLableStyle,),
												),)
											),
										),
									)
								)
							],
						)
							: SizedBox(),
				)
			))
        );
  	}
}