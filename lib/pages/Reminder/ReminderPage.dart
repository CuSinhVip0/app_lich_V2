
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luanvan/Common/CalendarV3.dart';
import 'package:luanvan/Common/Button/ConfirmButton.dart';
import 'package:luanvan/Common/Button/SmallButton.dart';
import 'package:luanvan/Controller/Home/Calender.dart';
import 'package:luanvan/pages/Event/EventDetailV2.dart';
import 'package:luanvan/pages/Reminder/CreateTask.dart';
import 'package:luanvan/Component/Reminder/ListDetail.dart';
import 'package:luanvan/Controller/Task.dart';
import 'package:luanvan/Controller/TaskList.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/Styles/Themes.dart';
import 'package:luanvan/pages/LoginPage.dart';
import '../../Component/NoInternet.dart';
import '../../Controller/Component/SystemController.dart';
import 'dart:math' as math;
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../Controller/Component/UserController.dart';


class ReminderPage extends StatelessWidget {
	UserController userController = Get.find();
	TaskListController taskListController  = Get.put(TaskListController());
	var taskController = Get.put(TaskController());
	SystemController systemController = Get.find();
	CalenderController calendarController = Get.put(CalenderController());
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
									DateFormat.yMMMMEEEEd('lan'.tr).format(taskListController.selectedDate),
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
				// actions: [
				// 	Container(
				// 		padding: EdgeInsets.only(right: 12),
				// 		child: TextButton(onPressed: () {
				// 			calendarController.addY = (DateTime.now().year);
				// 			calendarController.addM =  DateTime.now().month;
				// 			calendarController.addD = DateTime.now().day;
				// 			calendarController.listnext = [0, 1, 2];
				// 			calendarController.listprev = [-1, -2];
				// 			calendarController.list.value = [-2, -1, 0, 1, 2];
				// 			calendarController.pointLeft = -2; // diem them items
				// 			calendarController.pointRight = 2; // diem them item
				// 			calendarController.pick =  DateTime.now();
				// 			calendarController.listOfGlobalKeys =List.generate(5, (index) {
				// 				return GlobalKey();
				// 			});
				// 			calendarController.listBookmark = [].obs;
				// 			calendarController.pages = [];
				// 			calendarController.pagesprev = [];
				// 			calendarController.controller = ScrollController();
				// 			calendarController.initIndex = 0;
				//
				// 			calendarController.getDateEventToSetBookmark(DateTime.now().month, DateTime.now().year);
				// 			calendarController.update();
				// 			calendarController.refresh();
				// 			taskListController.selectedDate = DateTime.now();
				// 			taskListController.update();
				// 			taskListController.refresh();
				//
				// 		},
				// 			style: TextButton.styleFrom(
				// 				backgroundColor: Color(0xffff745c),
				// 				foregroundColor: Colors.transparent,
				// 				minimumSize: Size(80, 30),
				// 				padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16)
				// 			),
				// 			child: Text("Today".tr, style: TextStyle(color: Colors.white))),
				// 	)
				// ],
			),
			body:SafeArea(
				child:  GetBuilder(
					init: SystemController(),
					builder: (SystemController)=>(systemController.connectionStatus.contains(ConnectivityResult.mobile)  || systemController.connectionStatus.contains( ConnectivityResult.wifi) )
						? Container(
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
										builder:(taskListController) => CalendarV3(onTap: (e){
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
															child:GetBuilder(
																init:TaskListController(),
																builder:(taskListController)=>
																taskListController.taskLists.length==0
																	? ListView.builder(
																	physics: BouncingScrollPhysics(),
																	controller: scrollController,
																	itemCount: 1,
																	itemBuilder: (context, index) {
																		return Column(
																			children: [
																				Container(width: 150,child: Image.asset('assets/notask.png'),),
																				Text("noworktoday".tr,style: subTitleStyle,)
																			],
																		);
																	}
																)
																	: ListView.builder(
																	physics: BouncingScrollPhysics(),
																	controller: scrollController,
																	itemCount: taskListController.taskLists.length,
																	itemBuilder: (context, index) {
																		if(taskListController.taskLists[index][1].length==0){
																			return SizedBox();
																		}
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
																							return Slidable(
																								key: UniqueKey(),
																								endActionPane: ActionPane(
																									motion: ScrollMotion(),
																									children: [
																										SlidableAction(
																											onPressed: (context) async {
																												bool res = await taskListController.deleteTaskFromDb(items['IdMain'],index);
																												if(!res){
																													Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
																												}
																											},
																											backgroundColor: Colors.red,
																											foregroundColor: Colors.white,
																											icon: Icons.delete,
																											label: 'Xóa',
																										),

																										SlidableAction(
																											onPressed: (context){
																												Get.to(()=>CreateTaskPage(payload: {
																													"Id":items["IdMain"],
																													"date":[items['Nam'].toString(),items['Thang'].toString(),items['Ngay'].toString()],
																													"dateto":[items['ToYear'].toString(),items['ToMonth'].toString(),items['ToDay'].toString()],
																													"Ten":items["Ten"],
																													"ToDay":items["ToDay"],
																													"ToMonth":items["ToMonth"],
																													"ToYear":items["ToYear"],
																													"GioBatDau":items["GioBatDau"],
																													"GioKetThuc":items["GioKetThuc"],
																													"ChiTiet":items["ChiTiet"],
																													"HandleRepeat":items["HandleRepeat"],
																													"Remind":items["Remind"],
																													"DuongLich":items["DuongLich"],
																													"Type":items["Type"],
																													"key":"Cập nhật sự kiện"
																												},));
																											},
																											backgroundColor: Color(0xFF21B7CA),
																											foregroundColor: Colors.white,
																											icon: Icons.edit,
																											label: 'Edit',
																										),
																									],
																								),
																								child: Padding(
																									padding: const EdgeInsets.all(8.0),
																									child: GestureDetector(
																										onTap: (){
																											taskController.setTask(items);

																											items['EventSystem'] == 0
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
																								)
																							) ;
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
												onTap: () async{
													if(userController.isLogin.value){
														Get.to(()=>CreateTaskPage());
													}else {
														try{
															var data = await Get.to(()=>LoginPage());
															if(data == true) Get.to(()=>CreateTaskPage());
														}catch(e){}
													}
	},
												title: "Createevent",
											),
										),
									),
								),
								/* end nut tao */

							],
						),
					)
						:Center(
						child: NoInternet((){
							taskListController.getTasks();
						}),
					),)
			),);
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