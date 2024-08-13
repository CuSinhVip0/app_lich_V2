import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luanvan/Controller/StatusController.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/Styles/Themes.dart';
import 'package:luanvan/pages/DetailPostPage.dart';
import 'package:luanvan/utils/formatTimeToString.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Controller/Component/UserController.dart';
import '../pages/LoginPage.dart';
class PostV1 extends StatelessWidget{
	StatusController statusController = Get.find();
	var payload;
	Function handleLike;
	PostV1(this.payload,this.handleLike);
	UserController userController = Get.find();
	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
    	return GetBuilder(
			init: StatusController(),
			builder: (statusController)=>GestureDetector(
				onTap: (){
					userController.isLogin.value
					?Get.to(()=>DetailPostPage(payload))
						:Get.to(() =>LoginPage());

				},
				child:  Card(
					margin: EdgeInsets.symmetric(vertical: 8),
					surfaceTintColor: Colors.white,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(8.0),
						side: BorderSide(
							color:Get.isDarkMode ? Colors.transparent : Color(0xffd5d5d5),
							width: 1.0,
						),
					),
					elevation: 2,
					shadowColor: Colors.transparent,
					child: Column(
						children: [
							ListTile(
								leading: CircleAvatar(
									backgroundColor: Colors.white,
									radius: 20.0,
									child: CircleAvatar(
										backgroundImage: CachedNetworkImageProvider(payload['UrlPic'],),
										radius: 100.0,
									),
								),
								title: Text(payload['Name'] ?? "",style: titleStyle,),
								subtitle: Text(FormatTimeToString(DateTime.now().difference(DateFormat("yyyy-MM-dd hh:mm:ss").parse(payload['CreateAt']))),style: subTitleStyle,),
							),
							SizedBox(height: 4,),
							Padding(
								padding: EdgeInsets.symmetric(horizontal: 14),
								child: Align(
									alignment: Alignment.centerLeft,
									child: Text(payload['Title'],style: titleStyle,),
								),
							),
							SizedBox(height: 4,),
							payload['Url'] !=null ?Container(
								padding: EdgeInsets.symmetric(horizontal: 14,vertical: 12),
								child: InkWell(
									onTap: (){
										// Navigator.push(context, MaterialPageRoute(builder: (c)=> FullImage));
									},
									child: Container(
										height: 300,
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(8.0),
											image: DecorationImage(
												image: CachedNetworkImageProvider(payload['Url']), fit: BoxFit.cover),
											// image: AssetImage('assets/Tet-nguyen-dan-2022-1.jpg'), fit: BoxFit.cover,),
										),
									),
								),
							):SizedBox(),
							Divider(
								height: 1,
								indent: 14,
								endIndent: 14,
							),
							Container(
								padding: EdgeInsets.symmetric(horizontal: 14,vertical: 8),
								child: Row(
									children: [
										Expanded(
											flex: 1,
											child:Row(
												children: [
													GetBuilder(
														init: StatusController(),
														builder: (statusController) => GestureDetector(
															onTap:(){
																userController.isLogin.value
																	?handleLike()
																	:Get.to(() =>LoginPage());

															},
															child: Icon(payload['IsLike']==0?FontAwesomeIcons.heart:FontAwesomeIcons.solidHeart,color: RootColor.cam_nhat,size: 24,),
														),),
													SizedBox(width: 4,),
													Text(payload['NumLike'].toString(),style: subTitleStyle,),
													SizedBox(width: 12,),
													Icon(FontAwesomeIcons.commentDots,color: RootColor.cam_nhat,size: 24,),
													SizedBox(width: 4,),
													Text(payload['NumComment'].toString(),style: subTitleStyle,),
												],
											)
										),
										Expanded(
											flex: 1,
											child:Align(
												alignment: Alignment.centerRight,
												child: GestureDetector(
													onTap: (){},
													child: Icon(FontAwesomeIcons.bookmark,color: RootColor.cam_nhat,size: 24,),
												),
											)
										)
									],
								),
							)
						],
					),
				),
			));
  	}
}