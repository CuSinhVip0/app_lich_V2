import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luanvan/Controller/DetailPostController.dart';
import 'package:luanvan/Controller/StatusController.dart';
import 'package:luanvan/Controller/UserController.dart';

import '../Styles/Colors.dart';
import '../Styles/Themes.dart';
import '../utils/formatTimeToString.dart';

class DetailPostPage extends StatelessWidget{
	DetailPostController detailPostController = Get.put(DetailPostController());
	StatusController statusController = Get.find();
	UserController userController = Get.find();
	var payload;
	DetailPostPage(this.payload);
	@override
 	 Widget build(BuildContext context) {
		detailPostController.payload.value = payload;
		return GestureDetector(
			onTap: () => FocusScope.of(context).unfocus(),
			child: Scaffold(
				appBar: AppBar(
					centerTitle: true,
					title: Text("detailpost".tr,style: AppBarTitleStyle(Colors.white),),
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
									physics: BouncingScrollPhysics(),
									child: Column(

										children: [
											/*  ----- ||   Bài viết   || ----- */
											Card(
												shape: RoundedRectangleBorder(
													side: BorderSide(
														color:Get.isDarkMode ? Colors.transparent : Color(0xffd5d5d5),
														width: 1.0,
													),
												),
												surfaceTintColor: Colors.white,
												margin: EdgeInsets.symmetric(horizontal: 0,vertical: 8),
												elevation: 2,
												shadowColor: Colors.transparent,
												child: Column(
													children: [
														ListTile(
															leading: CircleAvatar(
																backgroundColor: Colors.white,
																radius: 20.0,
																child: CircleAvatar(
																	backgroundImage:CachedNetworkImageProvider(detailPostController.payload['UrlPic'],),
																	radius: 100.0,
																),
															),
															title: Text(detailPostController.payload['Name']  ?? "",style: titleStyle,),
															subtitle: Text(FormatTimeToString(DateTime.now().difference(DateFormat("yyyy-MM-dd hh:mm:ss").parse(detailPostController.payload['CreateAt']))),style: subTitleStyle,),
														),
														SizedBox(height: 4,),
														Padding(
															padding: EdgeInsets.symmetric(horizontal: 14),
															child: Align(
																alignment: Alignment.centerLeft,
																child: Text(detailPostController.payload['Title']),
															),
														),
														SizedBox(height: 4,),
														detailPostController.payload['Url'] !=null ?Container(
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
																			image: CachedNetworkImageProvider(detailPostController.payload['Url'],), fit: BoxFit.cover),
																	),
																),
															),
														):SizedBox(),
														SizedBox(height: 4,),
														Divider(
															color: Color(0xffdddddd),
															height: 1,
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
																					init: DetailPostController(),
																					builder: (detailPostController) => GestureDetector(
																						onTap:(){
																							statusController.updatelistPort('like',payload['Id']);
																							statusController.updateLikeOfPosttoDataBase(payload['Id'],userController.userData['id']);
																							detailPostController.updatelistPort();
																						},
																						child: Icon(detailPostController.payload['IsLike']==0?FontAwesomeIcons.heart:FontAwesomeIcons.solidHeart,color: RootColor.cam_nhat,size: 24,),
																					),),
																				SizedBox(width: 4,),
																				Obx(() => Text(detailPostController.payload['NumLike'].toString(),style: subTitleStyle,),),
																				SizedBox(width: 12,),
																				Icon(FontAwesomeIcons.commentDots,color: RootColor.cam_nhat,size: 24,),
																				SizedBox(width: 4,),
																				Obx(() => Text(detailPostController.detailComment.length.toString(),style: subTitleStyle,),)
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
														),
														Divider(
															color: Color(0xffdddddd),
															height: 1,
														),
													],
												),
											),
											/*  ----- || End bài viết || ----- */

											/*  ----- || Comment || ----- */

											GetBuilder(
												init: DetailPostController(),
												builder:(detailPostController)=>detailPostController.showComment.value ? Column(
													children: detailPostController.detailComment.map(
															(i)=> ListTile(
															leading: CircleAvatar(
																backgroundColor: Colors.white,
																radius: 18.0,
																child: CircleAvatar(
																	backgroundImage: CachedNetworkImageProvider(i['UrlPic'],),
																	radius: 100.0,
																),
															),
															title: Text(i['Content']  ?? "",style: titleStyle,),
															subtitle: Row(
																children: [
																	Expanded(
																		flex: 7,
																		child: Row(
																		children: [
																			Expanded(
																				child: Text(FormatTimeToString(DateTime.now().difference(DateFormat("yyyy-MM-dd hh:mm:ss").parse(i['CreateAt']))),style: subTitleStyle,)),
																			Expanded(child: Row(
																				children: [
																					Expanded(
																						flex: 4,
																						child: GestureDetector(
																							onTap: (){
																								detailPostController.updatelikeComments(i['Id']);
																								detailPostController.updateLikeOfCommenttoDataBase(i['Id'],userController.userData['id']);
																							},
																							child: Text("like".tr,style:i['IsLike']==0 ? subTitleStyle : subLikeTitleStyle,),
																						)
																					),
																					Expanded(
																						flex:6,
																						child: GestureDetector(
																							child: Text("reply".tr,style: subTitleStyle,),
																						)
																					),
																				],
																			))
																		],
																	)),
																	Expanded(
																		flex: 1,
																		child: i['NumLike'] >0 ? Row(
																			children: [
																				Expanded(child: Icon(FontAwesomeIcons.solidHeart,color: RootColor.cam_nhat,size: 18,),),
																				SizedBox(width: 4,),
																				Expanded(child:Text(i['NumLike'].toString(),style: subTitleStyle,),)
																			],
																		) :SizedBox()
																	)
																],
															),
														)
													).toList(),
												):  Container(
														width: 100,
														height: 100,
														decoration: BoxDecoration(
															borderRadius: BorderRadius.circular(8)
														),
														child: Center(
															child: LoadingAnimationWidget.dotsTriangle(color: RootColor.cam_nhat, size:40),
														),
													),
											),

											/*  ----- || End comment || ----- */
											SizedBox(height: 50,),
										],
									),
								),
								Positioned(
									bottom: 0,
									left: 0,
									right: 0,
									child: Card(
										margin: EdgeInsets.all(0),
										shape: RoundedRectangleBorder(
											side: BorderSide(
												color:Get.isDarkMode ? Colors.transparent : Color(0xffd5d5d5),
												width: 1.0,
											),
										),
										elevation: 1,
										surfaceTintColor: Colors.white,
										child:ListTile(
											leading: GetBuilder(
												init: DetailPostController(),
												builder: (detailPostController)=> GestureDetector(
													onTap: ()async{
														// final ImagePicker picker = ImagePicker();
														// final XFile? img = await picker.pickImage(
														// 	source: ImageSource.gallery, // alternatively, use ImageSource.gallery
														// 	maxWidth: 400,
														// );
														// if (img == null) return;
														// postController.updateFileImage(img.path);
														// postController.refresh();
													},
													child:FaIcon(FontAwesomeIcons.camera,color: RootColor.cam_nhat),
												)),
											title: Row(
												children: [
													Expanded(child: TextFormField(
														controller: detailPostController.textEditingController,
														decoration: InputDecoration(
															isDense: true,
															hintText: "Viết bình luận ...",
															hintStyle:CustomStyle(16, Colors.black, FontWeight.w400) ,
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
														cursorColor: Colors.grey[400],
													)),
													SizedBox(width: 12),
													Obx(() =>!detailPostController.hideButton.value ? GestureDetector (
														onTap: () async{
															detailPostController.sending.value = true;
															await detailPostController.updateCommenttoDataBase(detailPostController.textEditingController.text,payload['Id'],userController.userData['id']);
															detailPostController.sending.value = false;
															FocusScope.of(context).unfocus();
															detailPostController.textEditingController.text='';
														},
														child:  FaIcon(Icons.send,color: detailPostController.sending.value ? RootColor.disable:RootColor.cam_nhat,),
													):SizedBox()) ,
												],
											),
										),

									),
								)
							],
						),
					),
				),
			),
		);
  	}
}