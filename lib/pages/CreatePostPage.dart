import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luanvan/Common/Button/SmallButton.dart';
import 'package:luanvan/Controller/PostController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luanvan/Controller/UserController.dart';
import 'package:luanvan/Services/Notification.dart';

import '../Styles/Colors.dart';
import '../Styles/Themes.dart';

class CreatePostPage extends StatelessWidget{
	TextEditingController textEditingController = TextEditingController();
	PostController postController = Get.put(PostController());
	UserController userController = Get.find();
	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		return GestureDetector(
			onTap: () => FocusScope.of(context).unfocus(),
			child:  Scaffold(
				appBar: AppBar(
					centerTitle: true,
					title: Text("Tạo bài viết", style: AppBarTitleStyle(Colors.black),),
					shadowColor: Colors.transparent,
					elevation: 0,
					actions: [
						Container(
							margin: EdgeInsets.only(right: 12),
							child:	Obx(()=> SmallButton(onTap:postController.loading.value ? (){} : () async{
								NotificationServices().showNotification(1, "a");
									// postController.loading.value =true;
									// bool res = await postController.uploadPost(textEditingController.text,userController.userData['id'],userController.typeLogin.value);
									// if(res == true){
									// 	Get.back();
									//
									// }
									// else Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
									// postController.loading.value =false;
								}, widget: Container(
									padding: EdgeInsets.symmetric(vertical: 6,horizontal: 12),
									child: Text("Đăng",style: buttonLableStyle,),
								),
									disable:postController.loading.value ,
							)),
						)
					],
				),

				body: GestureDetector(
					onTap: () => FocusScope.of(context).unfocus(),
					onHorizontalDragUpdate: (details) {
						if (details.delta.dx > 30) {
							Get.back();
						}
					},
						child: Stack(
							children: [
								Container(
									height: double.infinity,
									child: Stack(
										children: [
											SingleChildScrollView(
												padding: EdgeInsets.only(bottom: 150),
												physics: BouncingScrollPhysics(),
												child: Container(
													child: Column(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [
															Padding(
																padding: EdgeInsets.all(12),
																child: Card(
																	shadowColor: Colors.transparent,
																	surfaceTintColor: Colors.white,
																	child: Padding(
																		padding: EdgeInsets.symmetric(horizontal: 8),
																		child: TextFormField(
																			controller: textEditingController,
																			cursorColor: Colors.grey[400],
																			minLines: 1, // any number you need (It works as the rows for the textarea)
																			keyboardType: TextInputType.multiline,
																			style: CustomStyle(16, Colors.black, FontWeight.w400),
																			maxLines: null,
																			decoration: InputDecoration(
																				isDense: true,
																				hintText: "Hãy viết gì đó vào đây",
																				hintStyle: subTitleStyle ,
																				focusedBorder: UnderlineInputBorder(
																					borderSide: BorderSide(
																						color:Colors.transparent,
																						width: 0
																					)
																				),
																				enabledBorder: UnderlineInputBorder(
																					borderSide: BorderSide(
																						color:Colors.transparent,
																						width: 0
																					)
																				),
																				disabledBorder: UnderlineInputBorder(
																					borderSide: BorderSide(
																						color:Colors.transparent,
																						width: 0
																					)
																				),
																			),
																		),
																	),
																),
															),
															GetBuilder(
																init: PostController(),
																builder: (postController) =>Column(
																	children:postController.imgFile.map((e) => Stack(
																		children: [
																			Container(
																				margin: EdgeInsets.only(bottom: 12),
																				child: Image.file(e,fit: BoxFit.fitWidth,width: double.infinity,),
																			),
																			Positioned(
																				top: 0,
																				right: 0,
																				child:GestureDetector(
																					onTap: (){
																						postController.removeItemFileImage(e);
																						postController.refresh();
																					},
																					child:  Container(
																						padding: EdgeInsets.all(12),
																						child: FaIcon(FontAwesomeIcons.xmark,color: Colors.white,),
																					),
																				)
																			)
																		],
																	)).toList(),
																)
															)

														],
													),
												),
											),
											Positioned(
												bottom: 0,
												left: 0,
												right: 0,
												child: Card(
													shape: RoundedRectangleBorder(),
													elevation: 4,
													margin: EdgeInsets.zero,
													surfaceTintColor: Colors.white,
													child: Container(
														padding: EdgeInsets.symmetric(vertical: 12),
														child: Row(
															children: [
																GetBuilder(
																	init: PostController(),
																	builder: (postController)=>Expanded(
																		flex: 1,
																		child: GestureDetector(
																			onTap: ()async{
																				final ImagePicker picker = ImagePicker();
																				final XFile? img = await picker.pickImage(
																					source: ImageSource.gallery, // alternatively, use ImageSource.gallery
																					maxWidth: 400,
																				);
																				if (img == null) return;
																				postController.updateFileImage(img.path);
																				postController.refresh();
																			},
																			child: Align(
																				alignment: Alignment.center,
																				child: FaIcon(FontAwesomeIcons.solidImages,color: RootColor.cam_nhat),
																			),
																		)
																	)),
																GetBuilder(
																	init: PostController(),
																	builder: (postController)=>Expanded(
																		flex: 1,
																		child: GestureDetector(
																			onTap: ()async{
																				final ImagePicker picker = ImagePicker();
																				final XFile? img = await picker.pickImage(
																					source: ImageSource.camera, // alternatively, use ImageSource.gallery
																					maxWidth: 400,
																				);
																				if (img == null) return;
																				postController.updateFileImage(img.path);
																				postController.refresh();
																			},
																			child: Align(
																				alignment: Alignment.center,
																				child: FaIcon(FontAwesomeIcons.camera,color: RootColor.cam_nhat),
																			),
																		)
																	) )
															],
														),
													),
												))
										],
									),
								),
								Obx(()=> postController.loading.value == true
									? Positioned(
									top: 0,
									bottom: 0,
									left: 0,
									right: 0,
									child: Container(
										child: Center(
											child:Card(
												child:  Container(
													width: 100,
													height: 100,
													decoration: BoxDecoration(
														borderRadius: BorderRadius.circular(8)
													),
													child: Center(
														child: LoadingAnimationWidget.dotsTriangle(color: RootColor.cam_nhat, size:40),
													),
												),
											)
										),
									),
								)
									: SizedBox())
							],
						)
					)
			),
		);
	}
}