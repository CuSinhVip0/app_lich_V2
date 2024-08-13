import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:luanvan/pages/Extension/CungHoangDao.dart';
import 'package:luanvan/pages/Extension/CungHoangDaoTronDoi.dart';
import '../../Component/NoInternet.dart';
import '../../Controller/Component/SystemController.dart';
import '../../Controller/Extension/CungHoangDaoController.dart';
import '../../Enum/Extentions/NgayTotXau.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';
import '../../Styles/Themes.dart';
import 'ExtensionDetail.dart';

class ExtensionPage extends StatelessWidget{
	CungHoangDaoController cungHoangDaoController = Get.put(CungHoangDaoController());
	SystemController systemController = Get.find();
	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: Text("Extensions".tr, style: AppBarTitleStyle(Get.isDarkMode ? Colors.white : Colors.black),),
			),
			backgroundColor: Colors.transparent,
			body: SafeArea(
				child: GetBuilder(
					init: SystemController(),
					builder: (SystemController)=>(systemController.connectionStatus.contains(ConnectivityResult.mobile)  || systemController.connectionStatus.contains( ConnectivityResult.wifi) )
						?SingleChildScrollView(
						physics: BouncingScrollPhysics(),
						child:  Container(
							child:  Padding(
								padding: EdgeInsets.symmetric(horizontal: 12),
								child:Card(
									shadowColor: Colors.transparent,
									elevation: 0,
									surfaceTintColor: Colors.white,
									borderOnForeground: false,
									child: Column(
										mainAxisSize: MainAxisSize.max,
										children: [
											SizedBox(
												width: double.infinity,
												child: Column(
													children: [
														Align(
															alignment: Alignment.centerLeft,
															child: Text("Seegoodandbaddays".tr,style: titleStyle,),
														),
														SizedBox(
															width: double.infinity,
															child: Card(
																elevation: 4,
																surfaceTintColor: Colors.white,
																child:Padding(
																	padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
																	child:GridView.builder(
																		physics: NeverScrollableScrollPhysics(),
																		itemCount: NgayTotXau.item.length,
																		shrinkWrap: true,
																		gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
																			crossAxisCount: 3,
																			mainAxisSpacing: 8,
																			mainAxisExtent: 100,
																		),
																		itemBuilder: (context, index) =>
																			GestureDetector(
																				onTap: (){
																					Get.to(()=>ExtensionDetail(NgayTotXau.item[index].payload!));
																				},
																				child:  Card(
																					surfaceTintColor: Colors.white,
																					borderOnForeground: false,
																					shadowColor: Colors.transparent,
																					child: Container(
																						child:  Column(
																							mainAxisAlignment: MainAxisAlignment.center,
																							children: [
																								Expanded(flex: 1,child: NgayTotXau.item[index].icon!),
																								Expanded( flex: 1,child: Align(
																									alignment: Alignment.topCenter,
																									child: Text( NgayTotXau.item[index].title!,style: subTitleStyle,textAlign: TextAlign.center, ),
																								))
																							]
																						),

																					),
																				)
																			),
																	),
																)),
														),
														SizedBox(height: 10,),
														Align(
															alignment: Alignment.centerLeft,
															child: Text("zodiacinfo".tr,style: titleStyle,),
														),
														SizedBox(
															width: double.infinity,
															child: Card(
																elevation: 4,
																surfaceTintColor: Colors.white,
																child:Column(
																	children: [
																		Container(
																			child: Row(
																				children: [
																					Expanded(flex: 1,child: Padding(
																						padding: EdgeInsets.symmetric(vertical: 15,horizontal: 12),
																						child:GestureDetector(
																							onTap: (){
																								Get.to(()=>CungHoangDaoPage());
																							},
																							child:  Card(
																								surfaceTintColor: Colors.white,
																								borderOnForeground: false,
																								shadowColor: Colors.transparent,
																								child: Container(
																									padding: EdgeInsets.symmetric(vertical: 12),
																									child: Column(
																										children: [
																											Iconify(EmojioneV1.aries,size: 28),
																											Align(
																												alignment: Alignment.topCenter,
																												child: Text("zodiac".tr,style: subTitleStyle,textAlign: TextAlign.center, ),

																											),
																										],
																									)

																								),
																							)
																						),
																					)),
																					Expanded(flex: 1,child: Padding(
																						padding: EdgeInsets.symmetric(vertical: 15,horizontal: 12),
																						child:GestureDetector(
																							onTap: (){
																								Get.to(()=>CungHoangDaoTronDoiPage());
																							},
																							child:  Card(
																								surfaceTintColor: Colors.white,
																								borderOnForeground: false,
																								shadowColor: Colors.transparent,
																								child: Container(
																									child: Column(
																										children: [
																											Iconify(EmojioneV1.cherry_blossom,size: 28),
																											Align(
																												alignment: Alignment.topCenter,
																												child: Text("zodiaclt".tr,style: subTitleStyle,textAlign: TextAlign.center, ),
																											),
																										],
																									)

																								),
																							)
																						),
																					)),
																					Expanded(flex: 1,child:SizedBox())
																				],
																			),
																		)
																	],
																)
															),
														)
													],
												),
											),
										],
									),
								)
							)
						),
					):Center(
						child: NoInternet((){

						}),
					),),
			));
	}
}


