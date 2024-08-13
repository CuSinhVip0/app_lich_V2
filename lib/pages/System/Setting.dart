import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:luanvan/Common/Button/CustomButton.dart';
import 'package:luanvan/Common/Button/MainButton.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/utils/DbHelper.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';
import '../../Styles/Themes.dart';

class SettingsPage extends StatelessWidget{
	UserController userController = Get.find();
	@override
  	Widget build(BuildContext context) {
		context.isDarkMode;
    	return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: Text("settings".tr,style: AppBarTitleStyle(Colors.white),),
				backgroundColor: Get.isDarkMode ? RootColor.den_appbar : RootColor.cam_nhat,
				shadowColor: Colors.transparent,
				elevation: 0,
				iconTheme: IconThemeData(
					color: Colors.white
				),
			),
			body:  GestureDetector(
				onHorizontalDragUpdate: (details) {
					if (details.delta.dx > 30) {
						Get.back();
					}
				},
				child: Container(
					height: double.infinity,
					child: Stack(
						children: [
							SingleChildScrollView(
								child: Column(
									children: [
										/*  ----- ||   dark mode   || ----- */
										Container(
											padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
											child: Column(
												children: [
													GetBuilder(
														init:UserController(),
														builder: (userController) =>Row(
															children: [
																Expanded(
																	flex: 2,
																	child: Text("darkmode".tr,style: titleStyle,),
																),
																CupertinoSwitch(
																	value: userController.setting['DarkMode'] as bool,
																	onChanged: (value) async{
																		await DbHelper.updateSetting('darkmode', value?1:0);
																		userController.updateSetting('DarkMode',value);
																		Get.changeThemeMode(value == true ? ThemeMode.dark : ThemeMode.light);
																	})
															],
														))
												],
											),
										),
										/*  ----- || End dark mode || ----- */

										/*  ----- ||    Ngôn ngữ  || ----- */
										Container(
											padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
											child:GetBuilder(
												init: UserController(),
												builder: (userController)=>Row(
													children: [
														Expanded(
															flex: 2,
															child: Text("language".tr,style: titleStyle,),
														),
														Expanded(
															flex: 1,
															child: Row(
																children: [
																	Expanded(
																		flex: 1,
																		child: CustomButton(
																			title: "Vie",
																			height: 30,
																			width: 50,
																			txtColor: userController.setting['Language'] == "Vie" ? Colors.white : Colors.black,
																			bgColor: userController.setting['Language'] == "Vie" ?  RootColor.cam_nhat :Get.isDarkMode ? RootColor.button_darkmode :Colors.white,
																			borderColor: userController.setting['Language'] == "Vie" ?  RootColor.cam_nhat : Get.isDarkMode ? RootColor.button_darkmode : Colors.grey[400] ,
																			onTap: () async{
																				userController.updateSetting("Language", "Vie");
																				await DbHelper.updateSetting('language', 'Vie');
																				var locale = Locale('vi', 'VN');
																				Get.updateLocale(locale);
																			},
																		),
																	),
																	SizedBox(width: 8,),
																	Expanded(
																		flex: 1,
																		child: CustomButton(
																			title: "Eng",
																			height: 30,
																			width: 50,
																			txtColor: userController.setting['Language'] != 'Vie' ? Colors.white : Colors.black,
																			bgColor: userController.setting['Language'] != "Vie" ? RootColor.cam_nhat : Get.isDarkMode ? RootColor.button_darkmode :Colors.white,
																			borderColor: userController.setting['Language'] != "Vie" ? RootColor.cam_nhat : Get.isDarkMode ? RootColor.button_darkmode : Colors.grey[400],
																			onTap: () async{
																				userController.updateSetting("Language", "Eng");
																				await DbHelper.updateSetting('language', 'Eng');
																				var locale = Locale('en', 'US');
																				Get.updateLocale(locale);
																			},
																		),
																	),
																],
															),

														)
													],)
											),
										),
										/*  ----- || End ngôn ngữ || ----- */

										/*  ----- ||   Thời gian   || ----- */
										Container(
											child: Column(
												children: [
													Container(
														color: Get.isDarkMode ? Color(0xff2B2B2B): Color(0xffFDE8E6),
														child: ListTile(
															leading: Icon(Icons.access_time_filled,color:Get.isDarkMode ? Colors.white: Colors.black,),
															title: Text("time".tr,style: headingStyle,),

														),
													),
													Container(
														padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
														child: Column(
															children: [
																Row(
																	children: [
																		Expanded(
																			flex: 2,
																			child: Text("typeTime".tr,style: titleStyle,),
																		),
																		Expanded(
																			flex: 1,
																			child: GetBuilder(
																				init: UserController(),
																				builder: (userController)=>Row(
																					children: [
																						Expanded(
																							flex: 1,
																							child: CustomButton(
																								title: "12h",
																								height: 30,
																								width: 50,
																								txtColor: userController.setting['StyleTime'] == '12h' ? Colors.white : Colors.black,
																								bgColor: userController.setting['StyleTime'] == '12h' ? RootColor.cam_nhat :Get.isDarkMode ? RootColor.button_darkmode : Colors.white,
																								borderColor: userController.setting['StyleTime'] == '12h' ? RootColor.cam_nhat : Get.isDarkMode ? RootColor.button_darkmode :Colors.grey[400],
																								onTap: () async{
																									userController.updateSetting("StyleTime", '12h');
																									await DbHelper.updateSetting('styletime','12h' );
																								},
																							),
																						),
																						SizedBox(width: 8,),
																						Expanded(
																							flex: 1,
																							child: CustomButton(
																								title: "24h",
																								height: 30,
																								width: 50,
																								txtColor: userController.setting['StyleTime']== '24h' ? Colors.white : Colors.black,
																								bgColor: userController.setting['StyleTime'] == '24h' ?  RootColor.cam_nhat :Get.isDarkMode ? RootColor.button_darkmode :Colors.white,
																								borderColor: userController.setting['StyleTime'] == '24h' ?  RootColor.cam_nhat : Get.isDarkMode ? RootColor.button_darkmode :Colors.grey[400] ,
																								onTap: () async{
																									userController.updateSetting("StyleTime", '24h');
																									await DbHelper.updateSetting('styletime','24h' );
																								},
																							),
																						)
																					],
																				),
																			)
																		)
																	],
																)
															],
														),
													)
												],
											),
										)
										/*  ----- || End thời gian || ----- */
									],
								),
							),
							Positioned(
								bottom: 0,
								left: 0,
								right: 0,
								height: 100,
								child: Container(
								child: Card(
									child: Center(
										child: Container(
											width: 300,
											child: MainButton(
												title: "Khôi phục cài đặt gốc",
												onTap: () async{

													Get.dialog(
														Column(
															mainAxisAlignment: MainAxisAlignment.center,
															children: [
																Padding(
																	padding: const EdgeInsets.symmetric(horizontal: 40),
																	child: Container(
																		decoration: const BoxDecoration(
																			color: Colors.white,
																			borderRadius: BorderRadius.all(
																				Radius.circular(20),
																			),
																		),
																		child: Padding(
																			padding: const EdgeInsets.all(20.0),
																			child: Material(
																				child: Column(
																					children: [
																						const SizedBox(height: 10),
																						const Center(
																							child: Iconify(EmojioneV1.warning,size: 40,),
																						),
																						const SizedBox(height: 15),
																						 Text(
																							"Khôi phục lại toàn bộ cài đặt ! \nBạn vẫn muốn ?",
																							textAlign: TextAlign.center,
																							style: titleStyle,
																						),
																						const SizedBox(height: 20),
																						//Buttons
																						Row(
																							children: [
																								Expanded(
																									child: ElevatedButton(
																										child: Text(
																											"Hủy",
																											style: CustomStyle(16, Colors.white, FontWeight.w400),
																										),
																										style: ElevatedButton.styleFrom(
																											minimumSize: const Size(0, 45),
																											backgroundColor: RootColor.cam_nhat,
																											shape: RoundedRectangleBorder(
																												borderRadius: BorderRadius.circular(8),
																											),
																										),
																										onPressed: () {
																											Get.back();
																										},
																									),
																								),
																								const SizedBox(width: 10),
																								Expanded(
																									child: ElevatedButton(
																										child:  Text(
																											'Khôi phục',
																											style: CustomStyle(16, Colors.red, FontWeight.w400),
																										),
																										style: ElevatedButton.styleFrom(
																											minimumSize: const Size(0, 45),

																											shape: RoundedRectangleBorder(
																												borderRadius: BorderRadius.circular(8),
																											),
																										),
																										onPressed: () async{
																											userController.setting = {
																												"DarkMode": false,
																												"Language": 'Vie',
																												"StyleTime": '24h'
																											};
																											userController.update();
																											await DbHelper.updateSetting('darkmode', 0);
																											await DbHelper.updateSetting('language', 'Vie');
																											await DbHelper.updateSetting('styletime', '24h');
																											Get.updateLocale(Locale('vi', 'VN'));
																											Get.changeThemeMode(ThemeMode.light);
																											await userController.LV_resetSettingtoDataBase();
																											Get.back();
																										},
																									),
																								),
																							],
																						),
																					],
																				),
																			),
																		),
																	),
																),
															],
														),
													);
												},
											),
										),
									),
								),
							))
						],
					)
				),
			),
		);
  	}
}