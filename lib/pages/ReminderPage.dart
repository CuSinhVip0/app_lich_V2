
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:luanvan/Common/CalendarV2.dart';
import 'package:luanvan/Common/CalendarV3.dart';
import 'package:luanvan/Common/Button/ConfirmButton.dart';
import 'package:luanvan/Common/Button/SmallButton.dart';
import 'package:luanvan/Component/Event/EventDetail.dart';
import 'package:luanvan/Component/Event/EventDetailV2.dart';
import 'package:luanvan/Component/Reminder/CreateTask.dart';
import 'package:luanvan/Component/Reminder/ListDetail.dart';
import 'package:luanvan/Controller/Task.dart';
import 'package:luanvan/Controller/TaskList.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/Styles/Themes.dart';
import '../Component/Event/ListEvent.dart';
import 'Event.dart';
import 'Extension.dart';
import 'StatusPage.dart';
import 'home.dart';
import 'dart:math' as math;


class ReminderPage extends StatelessWidget {
	TaskListController taskListController  = Get.put(TaskListController());
	var taskController = Get.put(TaskController());
	ReminderPage();
	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		return Scaffold(
			appBar: AppBar(
				toolbarHeight:85,
				automaticallyImplyLeading: false,
				title: Container(
					color: Colors.transparent,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text("Yourevent!".tr,style: headingStyle,),
							GetBuilder<TaskListController>(
								builder: (taskListController)=>Text(
									DateFormat.MMMMEEEEd('lan'.tr).format(taskListController.selectedDate),
									style: GoogleFonts.ubuntu(
										textStyle:TextStyle(
											fontSize: 20,
											fontWeight: FontWeight.w700,
											color:RootColor.cam_nhat
										),),
								)
							)
						],
					),
				),
				actions: [
					SmallButton(
						onTap: (){},
						widget: SizedBox(
							height: 40.0,
							width: 40.0,
							child:Icon(Icons.menu, size: 30.0,color: Colors.white,),
						)
					),
					SizedBox(width: 12,),
					SmallButton(
						onTap: (){},
						widget: SizedBox(
							height: 40.0,
							width: 40.0,
							child:Icon(Icons.add, size: 30.0,color: Colors.white,),
						)
					),
					SizedBox(width: 16,),
				],
			),
			body:SafeArea(
				child: Container(
					decoration: BoxDecoration(
						color: Get.isDarkMode? RootColor.den_body :Colors.white
					),
				  	child: Stack(
						children: [
							/*   lich   */
							Positioned(
								top: 0,
								left: 0,
								right: 0,
								child:  GetBuilder<TaskListController>(
									builder: (taskListController) => CalendarV3(onTap: (e){
																					taskListController.updateSelectedDate(e);
																					taskListController.getTasks();
																				}, selectedD: taskListController.selectedDate
									)
								)
							),
							/* end lich */

							/*   list task   */
							DraggableScrollableSheet(
								initialChildSize: (MediaQuery.of(context).size.height-400)/1000,
								minChildSize: (MediaQuery.of(context).size.height-400)/1000,     // Kích thước tối thiểu
								maxChildSize: 0.9,     // Kích thước tối đa
								builder: (context, scrollController) {
									return NotificationListener<DraggableScrollableNotification>(
										onNotification: (notification) {
											return true;
										},
										child: Container(
											padding: EdgeInsets.only(bottom: 65),
											decoration: BoxDecoration(
												color: Get.isDarkMode ? RootColor.den_appbar : Colors.white,
												borderRadius: BorderRadius.only(
													topLeft: Radius.circular(20),
													topRight: Radius.circular(20),
												),
												boxShadow: [
													BoxShadow(
														color: Colors.grey.withOpacity(0.5),
														spreadRadius: 2,
														blurRadius: 5,
														offset: Offset(0, 3),
													),
												],
											),
											child:Column(
												children: [
													Center(
														child:Container(
															margin: EdgeInsets.symmetric(vertical: 8),
															width: 75,
															height: 4,
															decoration: BoxDecoration(
																color: Colors.grey,
																borderRadius: BorderRadius.circular(10)
															),
														),
													),
													Expanded(
														child:Obx(()=>
															taskListController.taskLists.length==0
																? Column(
																		children: [
																			Container(width: 150,child: Image.asset('assets/notask.png'),),
																			Text("noworktoday".tr,style: subTitleStyle,)
																		],
																	)
																: ListView.builder(
																	physics: ClampingScrollPhysics(),
																	controller: scrollController,
																	itemCount: taskListController.taskLists.length,
																	itemBuilder: (context, index) {
																		return Row(
																			crossAxisAlignment: CrossAxisAlignment.start,
																			children: [
																				Expanded(
																					flex:2,
																					child:Container(
																						padding: EdgeInsets.symmetric(vertical: 8),
																						alignment: Alignment.center,
																						child: Text(taskListController.taskLists[index][0],style: titleStyle))
																				),
																				Expanded(
																					flex:9,
																					child: ListView.builder(
																						shrinkWrap: true,
																						physics: NeverScrollableScrollPhysics(),
																						itemCount: taskListController.taskLists[index][1].length,
																						itemBuilder: (context, i) {
																							var items = taskListController.taskLists[index][1][i];
																							return  Padding(
																								padding: const EdgeInsets.all(8.0),
																								child: GestureDetector(
																									onTap: (){
																										print(items);
																										taskController.setTask(items);
																										items['Id'] != 1
																											? Get.to(()=>TaskDetailPage())
																											: Get.to(()=>EventDetailPageV2(taskListController.selectedDate));
																									},
																									child: Container(
																										decoration: BoxDecoration(
																											color:Get.isDarkMode? RootColor.button_darkmode :RootColor.xam_nhat,
																											borderRadius: BorderRadius.circular(12)
																										),
																										child: ListTile(
																											contentPadding: EdgeInsets.only(top: 5,bottom: 5,right: 15),
																											minLeadingWidth : 4,
																											leading:Container(
																												margin: EdgeInsets.only(left: 15),
																												width: 5,
																												height: double.infinity,
																												decoration: BoxDecoration(
																													color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
																													borderRadius: BorderRadius.circular(10)
																												),
																											),
																											title: Row(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Expanded(
																														child:  Text(items["Ten"], style: headingStyle)),
																													Text(items["Name"], style: subTitleStyle)
																												],
																											),
																											subtitle:Text(items["ChiTiet"] ?? "", style: subTitleStyle ,overflow: TextOverflow.ellipsis, // Hiển thị dấu ba chấm khi văn bản tràn
																												maxLines: 2,),
																										),
																									),
																								),
																							);
																						})
																				)
																			],
																		);
																	},
																))


													)
												],
											)
										),
									);
								},
							),
							/* end list task */

							/*   nut tao   */
							Positioned(
								height: 75,
								bottom: 0,
								right: 0,
								left: 0,
								child: Container(
									child: Center(
										child: ConfirmButton(
											onTap: (){
												Get.to(()=>CreateTaskPage());
											},
											title: "Createevent",
										),
									),
								),
							),
							/* end nut tao */

						],
				  ),
				))
			);
	}
}


// gradient: LinearGradient(
// 	colors: [
// 		Colors.white,
// 		const Color(0xff9fcdf6),
// 	],
// 	begin: Alignment.topLeft,
// 	end: Alignment.bottomRight,
// 	stops: [0.0, 1.0],
// 	tileMode: TileMode.clamp),