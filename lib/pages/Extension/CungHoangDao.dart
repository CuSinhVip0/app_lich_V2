import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../Controller/Extension/CungHoangDaoController.dart';
import '../../Styles/Colors.dart';
import '../../Styles/Themes.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';
class CungHoangDaoPage extends StatelessWidget{
	CungHoangDaoController cungHoangDaoController = Get.find();
	UserController userController = Get.find();

	CungHoangDaoPage();
	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () => FocusScope.of(context).unfocus(),
			child: Scaffold(
				appBar: AppBar(
					centerTitle: true,
					title: Text("Cung hoàng đạo",style: AppBarTitleStyle(Colors.white),),
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
						color: RootColor.bg_body,
						height: double.infinity,
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
													shadowColor: Colors.transparent,
													elevation: 0,
													surfaceTintColor: Colors.white,
													borderOnForeground: false,
													child: Container(
														padding: EdgeInsets.all(12),
														width: double.infinity,
														child: Column(
															children: [
																Container(
																	child: Row(
																		children: [
																			IntrinsicWidth(child: Iconify(EmojioneV1.glowing_star),),
																			SizedBox(width: 12,),
																			Text("Sự may mắn",style: titleStyle,),
																		],
																	),
																),
																Container(
																	child: Row(
																		mainAxisAlignment: MainAxisAlignment.spaceBetween,
																		children: [
																			Text("Màu may mắn",style: CustomStyle(16,Colors.grey[600]!, FontWeight.w400),textAlign: TextAlign.start,),
																			SizedBox(width: 12,),
																			Obx(() => Text(cungHoangDaoController.data.length>0 ?cungHoangDaoController.data[cungHoangDaoController.index.value]['ColorLucky']:"",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),),)
																		],
																	),
																),
																Container(
																	child: Row(
																		mainAxisAlignment: MainAxisAlignment.spaceBetween,
																		children: [
																			Text("Sao hợp",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),textAlign: TextAlign.start,),
																			SizedBox(width: 12,),
																			Obx(() => Text(cungHoangDaoController.data.length>0 ?cungHoangDaoController.data[cungHoangDaoController.index.value]['SaoLucky']:"",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),),)
																		],
																	),
																),
																Container(
																	child: Row(
																		mainAxisAlignment: MainAxisAlignment.spaceBetween,
																		children: [
																			Text("Số may mắn",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),textAlign: TextAlign.start,),
																			SizedBox(width: 12,),
																			SizedBox(width: 12,),
																			Obx(() => Text(cungHoangDaoController.data.length>0 ?cungHoangDaoController.data[cungHoangDaoController.index.value]['NumberLucky']:"",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),),)
																		],
																	),
																),
																Container(
																	child: Row(
																		mainAxisAlignment: MainAxisAlignment.spaceBetween,
																		children: [
																			Text("Đàm phán thành công",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),textAlign: TextAlign.start,),
																			SizedBox(width: 12,),
																			SizedBox(width: 12,),
																			Obx(() => Text(cungHoangDaoController.data.length>0 ?cungHoangDaoController.data[cungHoangDaoController.index.value]['DamPhanTC'].toString():"",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),),)
																		],
																	),
																)
															],
														),
													)
												),
												Card(
													shadowColor: Colors.transparent,
													elevation: 0,
													surfaceTintColor: Colors.white,
													borderOnForeground: false,
													child: Container(
														padding: EdgeInsets.all(12),
														width: double.infinity,
														child: Column(
															children: [
																Container(
																	child: Row(
																		mainAxisAlignment: MainAxisAlignment.spaceBetween,
																		children: [
																			Expanded(flex:1,child: Container(
																				child: Row(
																					children: [
																						IntrinsicWidth(child: Iconify(EmojioneV1.money_bag),),
																						SizedBox(width: 12,),
																						Text("Sự nghiệp",style: titleStyle,),
																					],
																				),
																			),),
																			Expanded(
																				flex: 1,
																				child: Obx(()=>Container(
																					child:cungHoangDaoController.data.length>0 ? Row(
																						mainAxisAlignment: MainAxisAlignment.end,
																						children:  [1,2,3,4,5].map((i){
																							return i>cungHoangDaoController.data[cungHoangDaoController.index.value]['ChiSoSuNghiep']
																								?Icon(FluentIcons.star_20_regular,size: 22,color: RootColor.cam_nhat,)
																								:Icon(FluentIcons.star_20_filled,size: 22,color: RootColor.cam_nhat,);
																						}).toList() ,
																					): SizedBox(),
																				),)
																			)
																		],
																	),
																),
																SizedBox(height: 8,),
																Container( child: Obx(() => Text(cungHoangDaoController.data.length>0 ?cungHoangDaoController.data[cungHoangDaoController.index.value]['SuNghiep']??"":"",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),),)),

															],
														),
													)
												),
												Card(
													shadowColor: Colors.transparent,
													elevation: 0,
													surfaceTintColor: Colors.white,
													borderOnForeground: false,
													child: Container(
														padding: EdgeInsets.all(12),
														width: double.infinity,
														child: Column(
															children: [
																Container(
																	child: Row(
																		mainAxisAlignment: MainAxisAlignment.spaceBetween,
																		children: [
																			Expanded(flex:1,child: Container(
																				child: Row(
																					children: [
																						IntrinsicWidth(child: Iconify(EmojioneV1.love_letter),),
																						SizedBox(width: 12,),
																						Text("Tình cảm",style: titleStyle,),
																					],
																				),
																			)),
																			Expanded(
																				flex: 1,
																				child: Obx(()=>Container(
																					child: cungHoangDaoController.data.length>0 ? Row(
																						mainAxisAlignment: MainAxisAlignment.end,
																						children: [1,2,3,4,5].map((i){
																							return i>cungHoangDaoController.data[cungHoangDaoController.index.value]['ChiSoTinhCam']
																								?Icon(FluentIcons.star_20_regular,size: 22,color: RootColor.cam_nhat,)
																								:Icon(FluentIcons.star_20_filled,size: 22,color: RootColor.cam_nhat,);
																						}).toList(),
																					):SizedBox(),
																				),)
																			)
																		],
																	),
																),
																SizedBox(height: 8,),
																Container( child: Obx(() => Text(cungHoangDaoController.data.length>0 ?cungHoangDaoController.data[cungHoangDaoController.index.value]['TinhCam']??"":"",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),),)),

															],
														),
													)
												),
												Card(
													shadowColor: Colors.transparent,
													elevation: 0,
													surfaceTintColor: Colors.white,
													borderOnForeground: false,
													child: Container(
														padding: EdgeInsets.all(12),
														width: double.infinity,
														child: Column(
															children: [
																Container(
																	child:Row(
																		children: [
																			Expanded(flex:1,child: Container(
																				child: Row(
																					children: [
																						IntrinsicWidth(child: Iconify(EmojioneV1.face_blowing_a_kiss),),
																						SizedBox(width: 12,),
																						Text("Tâm trạng",style: titleStyle,),
																					],
																				),
																			)),
																				Expanded(child: Obx(()=>Container(
																					child: cungHoangDaoController.data.length>0 ? Row(
																						mainAxisAlignment: MainAxisAlignment.end,
																						children: [1,2,3,4,5].map((i){
																							return i>cungHoangDaoController.data[cungHoangDaoController.index.value]['ChiSoTamTrang']
																								?Icon(FluentIcons.star_20_regular,size: 22,color: RootColor.cam_nhat,)
																								:Icon(FluentIcons.star_20_filled,size: 22,color: RootColor.cam_nhat,);
																						}).toList(),
																					):SizedBox(),
																				),),flex: 1,)

																		],
																	)

																),
																SizedBox(height: 8,),
																Container( child: Obx(() => Text(cungHoangDaoController.data.length>0 ? cungHoangDaoController.data[cungHoangDaoController.index.value]['TamTrang'] ??"":"",style: CustomStyle(15,Colors.grey[600]! , FontWeight.w400),),)),

															],
														),
													)
												),

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