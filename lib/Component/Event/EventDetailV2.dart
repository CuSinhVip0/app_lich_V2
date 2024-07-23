import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Controller/Task.dart';
import '../../pages/Home/home.dart';
import '../../utils/date_utils.dart';
import '../../utils/lunar_solar_utils.dart';

class EventDetailPageV2 extends StatelessWidget{
	DateTime date;
	TaskController taskController = Get.find();
	EventDetailPageV2(this.date);
	@override
  	Widget build(BuildContext context) {
    	return Scaffold(
			extendBodyBehindAppBar: true,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				iconTheme: IconThemeData(color: Colors.white),
			),
			body: SingleChildScrollView(
				physics: BouncingScrollPhysics(),
				child: Container(
					child: Column(
						children: [
							Image.asset('assets/Tet-nguyen-dan-2022-1.jpg'),
							Padding(
								padding:EdgeInsets.symmetric(horizontal: 16,vertical: 14),
								child: Align(
									alignment: Alignment.centerLeft,
									child: Text(taskController.task['Ten'] ,style: TextStyle(fontSize: 22),),
								),
							),
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
												// Navigator.push(context,
												// 	MaterialPageRoute(builder: (context)=> HomePage(DateTime(taskController.task['NamDuong'],taskController.task['ThangDuong'],taskController.task['NgayDuong'])))
												// );
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
							Container(
								child: Column(
									children: [
										ListTile(
											leading: Icon(Icons.timer_sharp),
											title: (taskController.task['DuongLich']==0) ?
											Text('${taskController.task['Ngay']}/${taskController.task['Thang']}, năm ${getCanChiYear(convertSolar2Lunar(date.day,date.month, date.year, 7)[2])}')
												:Text(DateFormat.yMMMMEEEEd('vi').format((DateTime(DateTime.now().year,taskController.task['Thang'],taskController.task['Ngay'])))),
											subtitle: (taskController.task['DuongLich']==0) ? Text(DateFormat.yMMMMd('vi').format(date)) : null,
										),
										ListTile(
											leading: Icon(Icons.book_outlined),
											titleAlignment: ListTileTitleAlignment.top,
											title: Text(taskController.task['ChiTiet']??'Chưa cập nhật')
										)
									],
								),
							)
						],
					),
				),
			)
		);

  	}
}