import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luanvan/Common/Button/ConfirmButton.dart';
import 'package:luanvan/Common/Button/MainButton.dart';
import 'package:luanvan/Common/Input/Input.dart';
import 'package:luanvan/Controller/DetailPostController.dart';
import 'package:luanvan/Controller/Extension/ExtensionDetailController.dart';
import 'package:luanvan/Controller/StatusController.dart';
import 'package:luanvan/Controller/UserController.dart';

import '../Component/Reminder/CreateTask.dart';
import '../Styles/Colors.dart';
import '../Styles/Themes.dart';
import '../utils/formatTimeToString.dart';
import '../utils/lunar_solar_utils.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';
class ExtensionDetail extends StatelessWidget{
	ExtensionDetailController extensionDetailController = Get.put(ExtensionDetailController());
	UserController userController = Get.find();
	TextEditingController textEditingController = TextEditingController();
	var payload;
	ExtensionDetail(this.payload);
	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () => FocusScope.of(context).unfocus(),
			child: Scaffold(
				appBar: AppBar(
					centerTitle: true,
					title: Text(payload['title'],style: AppBarTitleStyle(Colors.white),),
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
							child: Column(
								children: [
									/*  ----- ||   input   || ----- */
									Padding(
										padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
										child: Card(
											surfaceTintColor: Colors.white,
											margin: EdgeInsets.symmetric(horizontal: 0,vertical: 8),
											elevation: 2,
											shadowColor: Colors.transparent,
											child: Column(
												children: [
													GestureDetector(
														onTap: () async{
															var a = await showCupertinoModalPopup(
																context: context,
																builder: (_) => Container(
																	height: 190,
																	color: Color.fromARGB(255, 255, 255, 255),
																	child: Column(
																		children: [
																			Container(
																				height: 180,
																				child: CupertinoDatePicker(
																					mode: CupertinoDatePickerMode.date,
																					initialDateTime: DateTime.now(),
																					onDateTimeChanged: (val) {
																						extensionDetailController.birth.value =  val.toString().split(' ')[0];
																					}),
																			),
																		],
																	),
																));
														},
														child:Obx(
															()=>Container(
															child: Row(
																children: [
																	Expanded(child: ListTile(
																		leading: CircleAvatar(
																			backgroundColor: Colors.white,
																			radius: 20.0,
																			child: CircleAvatar(
																				backgroundImage:CachedNetworkImageProvider(userController.userData['picture']['data']['url'],),
																				radius: 100.0,
																			),
																		),
																		title: Text(userController.userData['name']  ?? "",style: titleStyle,),
																		 subtitle:extensionDetailController.birth.value ==""? null: Text(DateFormat.yMd('vi').format(DateTime(int.parse(extensionDetailController.birth.value.split("-")[0]),int.parse(extensionDetailController.birth.value.split("-")[1]),int.parse(extensionDetailController.birth.value.split("-")[2]))),style: subTitleStyle,),
																	),),
																	IntrinsicWidth(
																		child:Padding(
																			padding: EdgeInsets.only(right: 30),
																			child: Icon(FluentIcons.person_edit_20_regular,size: 28,),
																		),
																	)
																],
															),
														)),
													),
													SizedBox(height: 8,),
													GestureDetector(
														onTap: () async{
															var a = await showCupertinoModalPopup(
																context: context,
																builder: (_) => Container(
																	height: 190,
																	color: Color.fromARGB(255, 255, 255, 255),
																	child: Column(
																		children: [
																			Container(
																				height: 180,
																				child: CupertinoPicker(
																					backgroundColor: Colors.white,
																					itemExtent: 30,
																					scrollController: FixedExtentScrollController(
																						initialItem: 1
																					),
																					onSelectedItemChanged: (int value) {
																						extensionDetailController.updateOptions(value);
																					},
																					children: [
																						Text("Tuần này"),
																						Text("Tuần sau"),
																						Text("7 ngày tới"),
																						Text("15 ngày tới"),
																						Text("30 ngày tới"),
																						Text("3 tháng tới"),
																					],

																				)
																			),
																		],
																	),
																));
														},
														child: Padding(
															padding: EdgeInsets.symmetric(horizontal: 20,),
															child: Container(
																decoration: BoxDecoration(
																	border: Border.all(
																		color: Colors.grey,
																		width: 1
																	),
																	borderRadius: BorderRadius.circular(8)
																),
																padding: EdgeInsets.symmetric(vertical: 12),
																child: Row(
																	children: [
																		IntrinsicWidth(child: Padding(
																			padding:EdgeInsets.symmetric(horizontal: 12),
																			child: Icon(FluentIcons.clock_20_regular,size: 24,),
																		)),
																		Obx((){
																			var timeS = extensionDetailController.timeStart.value.split("-");
																			var timeE = extensionDetailController.timeEnd.value.split("-");
																			return Expanded(child: Text(DateFormat.yMd('vi').format(DateTime(int.parse(timeS[0]),int.parse(timeS[1]),int.parse(timeS[2])))+" - "+DateFormat.yMd('vi').format(DateTime(int.parse(timeE[0]),int.parse(timeE[1]),int.parse(timeE[2]))) + " (AL)",style: titleStyle,textAlign: TextAlign.center,));
																		}),
																		IntrinsicWidth(child:  Padding(
																			padding: EdgeInsets.symmetric(horizontal: 12),
																			child: Icon(FluentIcons.chevron_down_20_regular,size: 24,),
																		)),
																	],
																),
															),
														),

													),
													SizedBox(height: 8,),
													Obx(()=>CupertinoButton(
														color: RootColor.cam_nhat,
														onPressed:extensionDetailController.loading.value == true ? null : ()async{
															extensionDetailController.getGoodDay(userController.userData['id'],payload['key']);
														},
														disabledColor: RootColor.disable,
														child: Text("Kết quả",style: buttonLableStyle,),
													),),
													SizedBox(height: 8,),
												],
											),
										),
									),
									/*  ----- || End input || ----- */
									GetBuilder(
										init: ExtensionDetailController(),
										builder: (extensionDetailController)=> extensionDetailController.listData.length==0
											? Padding(
												padding: EdgeInsets.symmetric(horizontal: 20),
												child: Text(payload['des'] ??"",style: subTitleStyle,textAlign: TextAlign.justify,),
											)
											: SizedBox()
									),
									GetBuilder(
										init: ExtensionDetailController(),
										builder: (extensionDetailController)=>extensionDetailController.loading == false ? Column(
											children: extensionDetailController.listData.map(
												(i){
													var item = i['SonarDate'].split('-');
													DateTime x = new DateTime(int.parse(item[0]),int.parse(item[1]),int.parse(item[2]));
													var lunar = convertSolar2Lunar(int.parse(item[2]), int.parse(item[1]), int.parse(item[0]), 7);
													return GestureDetector(
														onTap: (){
															Get.to(()=>CreateTaskPage(payload: {
																"date":item
															},));
														},
														child: Container(
															color: Colors.white,
															padding: EdgeInsets.symmetric(horizontal: 12),
															child:Row(
																children: [
																	Expanded(child: ListTile(
																		leading: getIcon(item),
																		title: Text(DateFormat.yMMMMEEEEd('vi').format(x),style: titleStyle,),
																		subtitle: Text('Ngày ${getCanDay(jdn(int.parse(item[2]), int.parse(item[1]), int.parse(item[0])))}, ${lunar[1]}/${lunar[1]} năm ${getCanChiYear(lunar[2])}',style: subTitleStyle,)
																	),),
																	IntrinsicWidth(
																		child:Padding(
																			padding:EdgeInsets.only(right: 12),
																			child: Icon(FluentIcons.ios_chevron_right_20_filled),
																		),
																	)
																],
															)
														),
													);
												}
											).toList(),
										): Container(
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
								],
							),
						),
					),
				),
			),
		);



	}

	Widget getIcon(item){
		int i =  getChiDay(jdn(int.parse(item[2]), int.parse(item[1]), int.parse(item[0])));
		switch (i){
			case 1:
				return Iconify(EmojioneV1.mouse_face);
			case 2:
				return Iconify(EmojioneV1.cow_face);
			case 3:
				return Iconify(EmojioneV1.tiger_face);
			case 4:
				return Iconify(EmojioneV1.cat_face);
			case 5:
				return Iconify(EmojioneV1.dragon_face);
			case 6:
				return Iconify(EmojioneV1.snake);
			case 7:
				return Iconify(EmojioneV1.horse_face);
			case 8:
				return Iconify(EmojioneV1.goat);
			case 9:
				return Iconify(EmojioneV1.monkey_face);
			case 10:
				return Iconify(EmojioneV1.front_facing_baby_chick);
			case 11:
				return Iconify(EmojioneV1.dog_face);
			case 12:
				return Iconify(EmojioneV1.pig_face);
			default: return SizedBox();
		}

	}
}