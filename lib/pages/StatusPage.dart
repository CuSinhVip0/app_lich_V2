import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:luanvan/Common/NonScrollableRefreshIndicatorV2.dart';
import 'package:luanvan/Component/AppBar/OptionsMenu.dart';
import 'package:luanvan/Controller/StatusController.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import 'package:luanvan/pages/CreatePostPage.dart';
import 'package:luanvan/pages/LoginPage.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../Component/NoInternet.dart';
import '../Component/PostV1.dart';
import '../Controller/Component/SystemController.dart';
import '../Styles/Themes.dart';

class StatusPage extends StatelessWidget{
	StatusController statusController = Get.put(StatusController());
	UserController userController = Get.find();
	TextEditingController username = TextEditingController();
	TextEditingController password = TextEditingController();
	SystemController systemController = Get.find();
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
						statusController.listPost.value = [];
						statusController.finished.value = false;
						statusController.i.value = 0;
						statusController.getPostFromDataBase(0,5);
					},
					child:GetBuilder(
						init: SystemController(),
						builder: (SystemController)=>(systemController.connectionStatus.contains(ConnectivityResult.mobile)  || systemController.connectionStatus.contains( ConnectivityResult.wifi) )
							?
						Container(
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
												userController.isLogin.value
												?Get.to(() => CreatePostPage())
													:Get.to(() =>LoginPage());
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
										builder: (statusController)=> Skeletonizer(
											enabled: !statusController.listPost.isNotEmpty,
											child:statusController.listPost.isNotEmpty ? Column(
												children: statusController.listPost.map((i)=>
													PostV1(i,(){
														statusController.updatelistPort('like',i['Id']);
														statusController.updateLikeOfPosttoDataBase(i['Id'],userController.userData['id']);
													})
												).toList(),
											):SizedBox()
										)
									),
									Obx (()=> statusController.finished.value == true
										? Center(
										child:  Text("Không còn bài viết",style: titleStyle,),
									)
										: SizedBox()
									)
								],
							)
						):
						Center(
							child: NoInternet((){

							}),
						),)
				),));
		}
}
