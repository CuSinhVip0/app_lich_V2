import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luanvan/Common/Button/ConfirmButton.dart';
import 'package:luanvan/Common/Button/MainButton.dart';
import 'package:luanvan/Common/Input/Input.dart';
import 'package:luanvan/Controller/DetailPostController.dart';
import 'package:luanvan/Controller/Extension/ExtensionDetailController.dart';
import 'package:luanvan/Controller/StatusController.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Reminder/CreateTask.dart';
import '../../Controller/Extension/CungHoangDaoController.dart';
import '../../Styles/Colors.dart';
import '../../Styles/Themes.dart';
import '../../utils/formatTimeToString.dart';
import '../../utils/lunar_solar_utils.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';

class CungHoangDaoTronDoiPage extends StatelessWidget  {
	CungHoangDaoController cungHoangDaoController = Get.find();
	UserController userController = Get.find();
	CungHoangDaoTronDoiPage();
	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () => FocusScope.of(context).unfocus(),
			child: Scaffold(
				appBar: AppBar(
					centerTitle: true,
					title: Text("zodiaclt".tr,style: AppBarTitleStyle(Colors.white),),
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
					child: Card(
						child: SingleChildScrollView(
							physics: BouncingScrollPhysics(),
							child: GetBuilder(
								init: CungHoangDaoController(),
								builder: (cungHoangDaoController)=>Container(
									child:  Padding(
										padding: EdgeInsets.symmetric(horizontal: 12),
										child: Column(
											children: [
												CarouselSlider(
													options: CarouselOptions(
														height: 400,
														aspectRatio: 16/9,
														viewportFraction: 0.6,
														initialPage: 0,
														enableInfiniteScroll: false,
														reverse: false,
														enlargeCenterPage: true,
														enlargeFactor: 0.3,
														scrollDirection: Axis.horizontal,
														onPageChanged: (index, reason) {
															cungHoangDaoController.index.value = index;
														}
													),
													items:cungHoangDaoController.data.map((i) {
														return Builder(
															builder: (BuildContext context) {
																return Card(
																	surfaceTintColor: Colors.white,
																	child:Container(
																		child: Column(
																			mainAxisAlignment: MainAxisAlignment.end,
																			children: [
																				Expanded(child: Image.asset('assets/${i['EngName'].toString().trim()}.jpg',fit: BoxFit.cover,),),
																				Text(i['Name'], style: CustomStyle(18,RootColor.cam_nhat, FontWeight.w700),),
																				Text(i['RangeTime'], style: titleStyle,)
																			],
																		)
																	)
																);
															},
														);
													}).toList(),
												),
												SizedBox(height: 30,),
												Card(
													elevation: 4,
													child: Container(
														padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
														child: Column(
															children: [
																Container(
																	child: TabBar(
																		controller: cungHoangDaoController.tab,
																		labelColor: RootColor.cam_nhat,
																		unselectedLabelColor: Colors.grey,
																		labelStyle: titleStyle,
																		tabs: [
																			Tab(text: "Global".tr,),
																			Tab(text: "Summary".tr,),
																			Tab(text: "Male".tr,),
																			Tab(text: "Female".tr,),
																		],
																	),
																),
																Container(
																	width:double.infinity,
																	child: AutoScaleTabBarView (
																		controller: cungHoangDaoController.tab,
																		children: [
																			Obx(() => Text(cungHoangDaoController.data[cungHoangDaoController.index.value]["Description"],style: CustomStyle(16, Colors.black, FontWeight.w400),textAlign: TextAlign.justify,)),
																			Obx(() => Text(cungHoangDaoController.data[cungHoangDaoController.index.value]["Summary"],style: CustomStyle(16, Colors.black, FontWeight.w400),textAlign: TextAlign.justify,)),
																			Obx(() => Text(cungHoangDaoController.data[cungHoangDaoController.index.value]["Male"],style: CustomStyle(16, Colors.black, FontWeight.w400),textAlign: TextAlign.justify,)),
																			Obx(() => Text(cungHoangDaoController.data[cungHoangDaoController.index.value]["Female"],style: CustomStyle(16, Colors.black, FontWeight.w400),textAlign: TextAlign.justify,)),
																		],
																	),
																)
															],
														),
													),
												)


											],
										),
									)),
							)


						),
					),
				),
			),
		);
	}
}