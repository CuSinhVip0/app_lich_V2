import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luanvan/Controller/Home/HomeController.dart';
import 'package:luanvan/Controller/Navigator.dart';
import 'package:luanvan/Controller/Task.dart';
import 'package:luanvan/Controller/TaskList.dart';
import '../../Styles/Colors.dart';
import '../../Styles/Themes.dart';
import '../../pages/Reminder/CreateTask.dart';
import '../../utils/lunar_solar_utils.dart';

class TaskDetailPage extends StatelessWidget{
	String? payload;
	TaskDetailPage({this.payload});
	TaskController taskController = Get.find();
	NavigatorController navigatorController = Get.find();
	HomeController homeController = Get.find();
	TaskListController taskListController  = Get.put(TaskListController());
	var remind = ['Không',"1 phút","5 phút","10 phút","30 phút", "1 tiếng", "1 ngày"];
	@override
  	Widget build(BuildContext context) {
		if(payload!=null) {
			taskController.LV_getInforTaskfromDatabase(payload);
		}
    	return Scaffold(
			extendBodyBehindAppBar: true,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				iconTheme: IconThemeData(color: Colors.white),
			),
			body:  GetBuilder(
			init: TaskController(),
				builder: (taskController) => !taskController.task.isEmpty
			?SingleChildScrollView(
				child: Container(
					child:GetBuilder<TaskController>(
						builder: (taskController)=> Column(
							children: [
								/*   title   */
								Stack(
									children: [
										Image.asset(taskController.task['Id']==1?'assets/ngay-le.jpg':taskController.task['Id']==2?'assets/cong-viec.jpg':'assets/sinh-nhat.jpg',height: 250,width: double.infinity, fit: BoxFit.cover,),
										Positioned(
											bottom: 8,
											left: 12,
											child: Container(
												decoration:  BoxDecoration(
													shape: BoxShape.rectangle,
													color: Colors.black,
													borderRadius: BorderRadius.circular(12)
												),
												padding: EdgeInsets.symmetric(vertical: 4, horizontal: 14),
												child: Text(taskController.task['Name'], style:subTitleStyle),
											))
									],
								),
								Padding(
									padding:EdgeInsets.symmetric(horizontal: 16,vertical: 14),
									child:Column(
										children: [
											Align(
												alignment: Alignment.centerLeft,
												child: Text(taskController.task['Ten'], style:heading1Style),
											),
											SizedBox(height: 8),
											taskController.task['ChiTiet'] != null && taskController.task['ChiTiet'] != ""
												? Align(
												alignment: Alignment.centerLeft,
												child:Text(taskController.task['ChiTiet'], style: subTitleStyle)
											) : SizedBox()
										],
									)
								),
								/* end title */
								/*   options   */
								Container(
									height: 80,
									child: Row(
										children: [
											Expanded(flex: 1,child: ElevatedButton(
												style: ElevatedButton.styleFrom(
													padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
													shape: BeveledRectangleBorder(),
													foregroundColor: Colors.black,
													textStyle: TextStyle(fontWeight: FontWeight.normal)
												),
												onPressed: (){
													navigatorController.currentIndex.value = 0;
													homeController.updateSelectedDate(DateTime(taskController.task['Nam'],taskController.task['Thang'],taskController.task['Ngay']));
													homeController.updateLunarDate(convertSolar2Lunar(taskController.task['Ngay'], taskController.task['Thang'], taskController.task['Nam'],7));
													Get.back();
												},
												child:Column(
													mainAxisAlignment: MainAxisAlignment.center,
													children: [
														Icon(FluentIcons.book_information_24_regular),
														Text("DateInformation".tr,style: subTitleStyle,)
													]
												)
											)),
											Expanded(flex: 1,child: ElevatedButton(
												style: ElevatedButton.styleFrom(
													padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
													shape: BeveledRectangleBorder(),
													foregroundColor: Colors.black,
													textStyle: TextStyle(fontWeight: FontWeight.normal)
												),
												onPressed: (){
													showCupertinoModalPopup<void>(
														context: context,
														builder: (BuildContext context) => CupertinoActionSheet(
															actions: <CupertinoActionSheetAction>[
																CupertinoActionSheetAction(
																	child: const Text("Sửa"),
																	onPressed: () {
																		Get.to(()=>CreateTaskPage(payload: {
																			"Id":taskController.task["IdMain"],
																			"date":[taskController.task['Nam'].toString(),taskController.task['Thang'].toString(),taskController.task['Ngay'].toString()],
																			"dateto":[taskController.task['ToYear'].toString(),taskController.task['ToMonth'].toString(),taskController.task['ToDay'].toString()],
																			"Ten":taskController.task["Ten"],
																			"ToDay":taskController.task["ToDay"],
																			"ToMonth":taskController.task["ToMonth"],
																			"ToYear":taskController.task["ToYear"],
																			"GioBatDau":taskController.task["GioBatDau"],
																			"GioKetThuc":taskController.task["GioKetThuc"],
																			"ChiTiet":taskController.task["ChiTiet"],
																			"HandleRepeat":taskController.task["HandleRepeat"],
																			"Remind":taskController.task["Remind"],
																			"DuongLich":taskController.task["DuongLich"],
																			"Type":taskController.task["Id"],
																			"key":"Cập nhật sự kiện"
																		},));
																	},
																),
																CupertinoActionSheetAction(
																	child: const Text('Xóa',style: TextStyle(color: Colors.red),),
																	onPressed: ()async {
																		bool res = await taskListController.deleteTaskFromDb(taskController.task['IdMain'],taskListController.taskLists.indexWhere((element) => element[0] ==( taskController.task['GioBatDau'] == "00:00" && taskController.task['GioKetThuc']=='24:00' ?"Cả ngày":taskController.task['GioBatDau'] )));
																		if(!res){
																			Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
																		}
																		else{
																			Get.back();
																			Get.back();
																		}
																	},
																)
															],
														),
													);
												},
												child:Column(
													mainAxisAlignment: MainAxisAlignment.center,
													children: [
														Icon(FluentIcons.notepad_edit_20_regular),
														Text("Mở rộng",style: subTitleStyle,)
													]
												)
											))
										],
									),
								),
								/* end options */

								/*   subdetail   */
								Container(
									child: Column(
										children: [
											ListTile(
												leading: Icon(Icons.access_time_outlined),
												title: Text(DateFormat.yMMMMEEEEd('vi').format(DateTime(taskController.task['Nam'],taskController.task['Thang'],taskController.task['Ngay'])),style: titleStyle,)
											),
											ListTile(
												leading: Icon(Icons.timer_sharp),
												title: !(taskController.task['GioBatDau']== "00:00" && taskController.task['GioKetThuc'] == '24:00') ? Row(
													children: [
														Text(taskController.task['GioBatDau']??"Chưa cập nhật", style: titleStyle,),
														Icon(Icons.keyboard_double_arrow_right_outlined),
														Text(taskController.task['GioKetThuc']??"Chưa cập nhật",  style: titleStyle,),
													],
												) : Text("Cả ngày" , style: titleStyle,),
											),
											ListTile(
												leading: Icon(Icons.refresh),
												title: Text(taskController.task['HandleRepeat'] == 1 ? "Hàng năm" : "Không lặp", style: titleStyle,)
											) ,
											ListTile(
												leading: Icon(Icons.notifications_active_outlined),
												title: Text("Nhắc trước ${remind[taskController.task['Remind']]}", style: titleStyle,)
											)

										],
									),
									/* end subdetail */
								)
							],
						),
					)
				),

		)
			:  Center(
			child: Container(
				width: 100,
				height: 100,
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(8)
				),
				child: Center(
					child: LoadingAnimationWidget.dotsTriangle(color: RootColor.cam_nhat, size:60),
				),
			),
		))
		);
  	}
}

