import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luanvan/Controller/Navigator.dart';
import 'package:luanvan/Controller/Task.dart';
import 'package:luanvan/Enum/Reminder/remindListOption.dart';
import '../../Common/Button/SmallButton.dart';
import '../../Styles/Colors.dart';
import '../../Styles/Themes.dart';
import '../../pages/Home/home.dart';
import '../../utils/date_utils.dart';
import '../../utils/lunar_solar_utils.dart';


class TaskDetailPage extends StatelessWidget{
	TaskController taskController = Get.find();
	NavigatorController navigatorController = Get.find();
	@override
  	Widget build(BuildContext context) {
    	return Scaffold(
			extendBodyBehindAppBar: true,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				iconTheme: IconThemeData(color: Colors.white),
			),
			body:SingleChildScrollView(
				child: Container(
					child:GetBuilder<TaskController>(
						builder: (taskController)=> Column(
							children: [
								/*   title   */
								Image.asset('assets/Tet-nguyen-dan-2022-1.jpg'),
								Padding(
									padding:EdgeInsets.symmetric(horizontal: 16,vertical: 14),
									child:Column(
										children: [
											Align(
												alignment: Alignment.centerLeft,
												child: Text(taskController.task['Ten'] ,style:heading1Style),
											),
											SizedBox(height: 8),
											Align(
												alignment: Alignment.centerLeft,
												child:Text(taskController.task['ChiTiet'] ?? "",style: subTitleStyle)
											)

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
													Get.back();
												},
												child:Column(
													mainAxisAlignment: MainAxisAlignment.center,
													children: [
														Icon(Icons.calendar_month_sharp),
														Text("Thông tin ngày")
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
												onPressed: (){},
												child:Column(
													mainAxisAlignment: MainAxisAlignment.center,
													children: [
														Icon(Icons.more_horiz),
														Text("Mở rộng")
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
												title: Text(DateFormat.yMMMMEEEEd('vi').format(DateTime(taskController.task['Nam'],taskController.task['Thang'],taskController.task['Ngay'])))
											),
											ListTile(
												leading: Icon(Icons.timer_sharp),
												title: Row(
													children: [
														Text(taskController.task['GioBatDau']??"Chưa cập nhật"),
														Icon(Icons.keyboard_double_arrow_right_outlined),
														Text(taskController.task['GioKetThuc']??"Chưa cập nhật"),
													],
												)
											),
											taskController.task['Id'] != 1
												? ListTile(
													leading: Icon(Icons.refresh),
													title: Text(taskController.task['HandleRepeat'] == 1 ? "Hàng năm" : "Không lặp")
												) : SizedBox(),
											taskController.task['Id'] != 1
												?ListTile(
														leading: Icon(Icons.notifications_active_outlined),
														title: Text("Nhắc trước ${remind[taskController.task['Remind']]['label']}")
													)
												: SizedBox()
										],
									),
								/* end subdetail */
								)
							],
						),
					)
				),
			)
		);

  	}
}

