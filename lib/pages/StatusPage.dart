import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luanvan/Component/AppBar/OptionsMenu.dart';
import 'package:luanvan/Controller/StatusController.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/pages/CreatePostPage.dart';
import 'package:provider/provider.dart';
import '../Common/NonScrollableRefreshIndicator.dart';
import '../Component/PostV1.dart';
import '../Provider/Internet.dart';
import '../Styles/Themes.dart';
import '../utils/lunar_solar_utils.dart';
import 'Event.dart';
import 'Extension.dart';
import 'ReminderPage.dart';
import 'home.dart';
class StatusPage extends StatelessWidget{

	StatusController statusController = Get.put(StatusController());
	TextEditingController username = TextEditingController();
	TextEditingController password = TextEditingController();

	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		print(statusController.listPost.toString());
		return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: Text('community'.tr, style: AppBarTitleStyle(Get.isDarkMode ? Colors.white : Colors.black),),

			),
			drawer: OptionsMenu(),
			backgroundColor: Colors.transparent,
			body: SafeArea(
				child: NonScrollableRefreshIndicator(
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

								Column(
									children: statusController.listPost.map((i)=>
										PostV1(i)
									).toList(),
								)


							],
						)
					)
				)
			));
	}
}


//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class StatusPage extends StatefulWidget{
// 	StatusPage();
// 	@override
// 	State<StatusPage> createState() {
// 		return _StatusPage();
// 	}
// }
//
// class _StatusPage extends State<StatusPage>  {
//
// 	@override
// 	Widget build(BuildContext context) {
// 		return Container(
// 			child: new Scaffold(
// 				appBar: AppBar(
// 					title: Text('Developine App Bar'),
// 				),
// 				drawer: Drawer(
// 				elevation: 20.0,
// 				child: ListView(
// 					padding: EdgeInsets.zero,
// 					children: <Widget>[
// 						ListTile(
// 							leading: Icon(Icons.account_circle),
// 							title: Text('Drawer layout Item 1'),
// 							onTap: () {
// 								// This line code will close drawer programatically....
// 								Navigator.pop(context);
// 							},
// 						),
// 						Divider(
// 							height: 2.0,
// 						),
// 						ListTile(
// 							leading: Icon(Icons.accessibility),
// 							title: Text('Drawer layout Item 2'),
// 							onTap: () {
// 								Navigator.pop(context);
// 							},
// 						),
// 						Divider(
// 							height: 2.0,
// 						),
// 						ListTile(
// 							leading: Icon(Icons.account_box),
// 							title: Text('Drawer layout Item 3'),
// 							onTap: () {
// 								Navigator.pop(context);
// 							},
// 						)
// 					],
// 				)),
// 		));
// 	}
// }