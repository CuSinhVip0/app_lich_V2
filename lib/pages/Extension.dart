import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:luanvan/pages/Extension/CungHoangDao.dart';
import 'package:luanvan/pages/ExtensionDetail.dart';
import 'package:provider/provider.dart';
import '../Controller/Extension/CungHoangDaoController.dart';
import '../Enum/Extentions/NgayTotXau.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';
import '../Styles/Themes.dart';

class ExtensionPage extends StatelessWidget{
	CungHoangDaoController cungHoangDaoController = Get.put(CungHoangDaoController());

	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: Text("Tiện ích", style: AppBarTitleStyle(Get.isDarkMode ? Colors.white : Colors.black),),

			),
			backgroundColor: Colors.transparent,
			body: SafeArea(
				child:SingleChildScrollView(
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
														child: Text("Xem ngày tốt xấu",style: titleStyle,),
													),
													SizedBox(
														width: double.infinity,
														child: Card(
															surfaceTintColor: Colors.white,
															color: Colors.white,
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
																				color: Colors.white,
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
														child: Text("Cung hoàng đạo",style: titleStyle,),
													),
													SizedBox(
														width: double.infinity,
														child: Card(
															surfaceTintColor: Colors.white,
															color: Colors.white,
															child:Column(
																children: [
																	Container(
																		child: Row(
																			children: [
																				Expanded(flex: 1,child: Padding(
																					padding: EdgeInsets.symmetric(vertical: 30,horizontal: 12),
																					child:GestureDetector(
																						onTap: (){
																							Get.to(()=>CungHoangDaoPage());
																						},
																						child:  Card(
																							surfaceTintColor: Colors.white,
																							color: Colors.white,
																							borderOnForeground: false,
																							shadowColor: Colors.transparent,
																							child: Container(
																								child: Column(
																									children: [
																										Iconify(EmojioneV1.aries,size: 28),
																										Align(
																											alignment: Alignment.topCenter,
																											child: Text("Cung hoàng đạo",style: subTitleStyle,textAlign: TextAlign.center, ),

																										),
																									],
																								)

																							),
																						)
																					),
																				)),
																				Expanded(flex: 1,child: Padding(
																					padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
																					child:GestureDetector(
																						onTap: (){

																						},
																						child:  Card(
																							surfaceTintColor: Colors.white,
																							color: Colors.white,
																							borderOnForeground: false,
																							shadowColor: Colors.transparent,
																							child: Container(

																								child: Column(
																									children: [
																									Iconify(EmojioneV1.cherry_blossom,size: 28),
																									Align(
																										alignment: Alignment.topCenter,
																										child: Text("Cung hoàng đạo trọn đời",style: subTitleStyle,textAlign: TextAlign.center, ),

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
				),
			));
	}
}


