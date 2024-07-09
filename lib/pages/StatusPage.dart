import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luanvan/Common/NonScrollableRefreshIndicatorV2.dart';
import 'package:luanvan/Component/AppBar/OptionsMenu.dart';
import 'package:luanvan/Controller/StatusController.dart';
import 'package:luanvan/Controller/UserController.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/pages/CreatePostPage.dart';
import '../Common/NonScrollableRefreshIndicator.dart';
import '../Component/PostV1.dart';
import '../Styles/Themes.dart';

class StatusPage extends StatelessWidget{
	StatusController statusController = Get.put(StatusController());
	UserController userController = Get.find();
	TextEditingController username = TextEditingController();
	TextEditingController password = TextEditingController();

	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: Text('community'.tr, style: AppBarTitleStyle(Get.isDarkMode ? Colors.white : Colors.black),),

			),
			drawer: OptionsMenu(),
			backgroundColor: Colors.transparent,
			body: SafeArea(
				child: NonScrollableRefreshIndicatorV2(
					scrollController: statusController.scrollController,
					onRefresh: () async {
						print(1);
					},
					child: Container(
						padding: EdgeInsets.all(12),
						child: Column(
							children: [
								/*----- ||   Button tạo bài   || -----*/
								Card(
									surfaceTintColor: Colors.white,
									elevation: 2,
									shadowColor: Colors.transparent,
									child: GestureDetector(
										onTap: () {
											Get.to(() => CreatePostPage());
										},
										child: ListTile(
											leading: FaIcon(FontAwesomeIcons.penToSquare),
											title: Text("startadiscussion".tr, style: titleStyle,),
										),
									)
								),
								/*----- || End button tạo bài || -----*/

								GetBuilder(
									init: StatusController(),
									builder: (statusController)=>Column(
										children: statusController.listPost.map((i)=>
											PostV1(i,(){
												statusController.updatelistPort('like',i['Id']);
												statusController.updateLikeOfPosttoDataBase(i['Id'],userController.userData['id']);
											})
										).toList(),
								)),
								Obx (()=> statusController.finished.value == true
										? Center(
										child:  Text("Không còn bài viết",style: titleStyle,),
									)
										: SizedBox()
								)
							],
						)
					)
				)
			));
	}
}
