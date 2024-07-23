
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import '../utils/ThemeChange.dart';
import '../utils/date_utils.dart';
import '../utils/lunar_solar_utils.dart';

class CalendarPoster extends StatelessWidget {
	UserController userController = Get.find();
	DateTime? _selectedDate;
	List<dynamic> lunarDate ;
	CalendarPoster(this._selectedDate,this.lunarDate);
	@override
	Widget build(BuildContext context) {
		return Container(
				alignment: Alignment.topCenter,
				child:Column(
					mainAxisSize: MainAxisSize.max,
					children: [
						SizedBox(height:350,),
						Stack(
							clipBehavior: Clip.none,
							alignment: Alignment.topCenter,
							children: [
								Positioned(child: Card(
									elevation: 6,
									surfaceTintColor: Colors.white,
									child: Container(
										padding: EdgeInsets.only(left: 8,right: 8,bottom: 20,top: 4),
										width: MediaQuery.of(context).size.width,
										constraints: BoxConstraints(
											minHeight: 200,
										),
										child: Column(
											children: [
												Container(
													padding: EdgeInsets.symmetric(horizontal: 4,vertical: 14),
													child: Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [
															Text(DateFormat.EEEE(userController.setting['Language'] == "Vie"?'vi':'en').format(_selectedDate!),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold ,fontFamily: 'mulish')),
															Text(_selectedDate!.year.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,fontFamily: 'mulish'),),
														],),
												),
												Row(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Expanded(flex: 1,child: Column(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Text(getNgayHoangDao(_selectedDate!.day, _selectedDate!.month, _selectedDate!.year),style: TextStyle(fontFamily: 'mulish')),
																SizedBox(height: 8),
																Text("Tiết Khí: "+getTietKhi(jdn(_selectedDate!.day,_selectedDate!.month,_selectedDate!.year)),style: TextStyle(fontFamily: 'mulish')),

															],
														)),
														Expanded(flex:1,child: Container(
															margin: EdgeInsets.symmetric(horizontal: 4),
															decoration: BoxDecoration(
																border: Border.symmetric(vertical: BorderSide(width: 1,color: Colors.grey))
															),
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.center,
																children: [
																	Text("Tháng "+lunarDate![1].toString()+" (AL)",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'mulish'),),
																	SizedBox(height: 4),
																	Text(lunarDate![0].toString(),style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,fontFamily: 'mulish'),),
																	SizedBox(height: 8),
																	Text(userController.setting['Language']!= "Vie"
																		?getBeginHour(_selectedDate!.hour, jdn(_selectedDate!.day,_selectedDate!.month,_selectedDate!.year)) + " Hour"
																		:"Giờ "+getBeginHour(_selectedDate!.hour, jdn(_selectedDate!.day,_selectedDate!.month,_selectedDate!.year)),style: TextStyle(fontFamily: 'mulish')),
																	GetBuilder(
																		init:UserController(),
																		builder: (userController)=>Text(DateFormat(userController.setting['StyleTime'] == '24h' ? "HH:mm:ss" : "hh:mm:ss a",userController.setting['Language'] == "Vie"?'vi':'en').format(_selectedDate!),style: TextStyle(fontSize: 18,fontFamily: 'mulish')))
																],
															),
														)),
														Expanded(flex: 1,child: Column(
															crossAxisAlignment: CrossAxisAlignment.end,
															mainAxisAlignment: MainAxisAlignment.start,
															children: [
																Text(userController.setting['Language']!= "Vie"
																	?getCanChiYear(_selectedDate!.year)+" "+'year'.tr
																	:'year'.tr+" "+ getCanChiYear(_selectedDate!.year),style: TextStyle(fontFamily: 'mulish'),),
																SizedBox(height: 8),
																Text(userController.setting['Language']!= "Vie"
																	? getCanChiMonth(lunarDate![1], lunarDate![2]) +" "+ 'month'.tr  : 'month'.tr+" "+getCanChiMonth(lunarDate![1], lunarDate![2]),style: TextStyle(fontFamily: 'mulish')),
																SizedBox(height: 8),
																Text(userController.setting['Language']!= "Vie"
																	?getCanDay(jdn(_selectedDate!.day,_selectedDate!.month,_selectedDate!.year))+" "+'day'.tr
																	:"day".tr+" "+getCanDay(jdn(_selectedDate!.day,_selectedDate!.month,_selectedDate!.year)),style: TextStyle(fontFamily: 'mulish'))
															],
														)),
													],
												)
											],
										),
									),
								)),
								Positioned(
									top: -50,
									child: Container(
										decoration: BoxDecoration(
											color: Color(0xffff745c),
											borderRadius: BorderRadius.circular(20),
											boxShadow: [
												BoxShadow(
													color: Colors.grey.withOpacity(0.5),
													spreadRadius: 2,
													blurRadius: 7,
													offset: Offset(0, 3), // changes position of shadow
												),
											]
										),
										width: 150,
										height: 100,
										child: Column(
											children: [
												Expanded(flex: 7,child: Text(_selectedDate!.day.toString(),style: TextStyle(height: 1.2,color: Colors.white,fontSize: 60,fontWeight: FontWeight.bold,fontFamily: 'mulish'))),
												Expanded(flex:3,child: Text(userController.setting['Language']!= "Vie"
													? DateFormat.MMMM('en').format(_selectedDate!)
													:getNameMonthOfYear(_selectedDate!.month),style:   TextStyle(height: 1.2,color: Colors.white,fontSize: 16,fontFamily: 'mulish'),))
											],
										),
									))
							],
						)
					]
				),


		);
	}


}