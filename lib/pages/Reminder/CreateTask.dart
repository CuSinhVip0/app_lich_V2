import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:luanvan/Common/Input/PickInput.dart';
import 'package:luanvan/Controller/Component/SystemController.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import 'package:luanvan/Controller/Remider/CreateTaskController.dart';
import 'package:luanvan/Services/Notification.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/utils/lunar_solar_utils.dart';
import 'package:provider/provider.dart';
import '../../Common/ErrorSnackBar.dart';
import '../../Common/Input/Input.dart';
import '../../Common/Button/MainButton.dart';
import '../../Common/SuccessSnackBar.dart';
import '../../Common/WarningSnackBar.dart';
import '../../Enum/Data.dart';
import '../../Controller/TaskList.dart';
import '../../Styles/Themes.dart';
import '../LoginPage.dart';

class CreateTaskPage extends StatelessWidget {
	TaskListController _taskListController = Get.put(TaskListController());
	CreateTaskController createTaskController = Get.put(CreateTaskController());
	SystemController systemController = Get.find();
	var payload;
	CreateTaskPage({this.payload});
	TextEditingController _title = TextEditingController();
	TextEditingController _content = TextEditingController();
	UserController userController = Get.find();
	NotificationServices notifi = NotificationServices();

	FirebaseFirestore db =FirebaseFirestore.instance;
	Future<void> getAllEvent () async {
		final res = await http.get(Uri.parse(ServiceApi.api+'/event/getAllEvent'));
		dynamic result = jsonDecode(res.body);
		result.map((e)=>db.collection("events").doc(e["Id"].toString()).set({
			"Id":e["Id"],
			"Ten":e["Ten"],
			"DuongLich":e["DuongLich"],
			"Ngay": e["Ngay"].toString(),
			"Thang":e["Thang"].toString(),
			"ChiTiet":e['ChiTiet']
		})).toList();
	}

	var remind = ['Không',"1 phút","5 phút","10 phút","30 phút", "1 tiếng", "1 ngày"];

	@override
  	Widget build(BuildContext context) {
		context.isDarkMode;
		if(payload != null){
			dynamic date = [int.parse(payload['date'][0]),int.parse(payload['date'][1]),int.parse(payload['date'][2])];
			dynamic dateto = [int.parse(payload['date'][0]),int.parse(payload['date'][1]),int.parse(payload['date'][2])];
			if(payload['dateto']!= null ){
				 dateto = [int.parse(payload['dateto'][0]),int.parse(payload['dateto'][1]),int.parse(payload['dateto'][2])];
			}

			if(payload['DuongLich'] != null && payload['DuongLich'] == 0){
				date = convertLunar2Solar(int.parse(payload['date'][2]), int.parse(payload['date'][1]), int.parse(payload['date'][0]), 0, 7).reversed.toList();
				dateto = convertLunar2Solar(int.parse(payload['dateto'][2]), int.parse(payload['dateto'][1]), int.parse(payload['dateto'][0]), 0, 7).reversed.toList();
			}
			createTaskController.id.value = payload['Id']!=null?payload['Id']:0;
			createTaskController.selectedDate= DateTime(date[0],date[1],date[2]);
			createTaskController.selectedToDate= DateTime(dateto[0],dateto[1],dateto[2]);
			createTaskController.fullTime.value = payload['GioBatDau']=="00:00" && payload["GioKetThuc"]=="24:00"?true:false;
			createTaskController.DuongLich.value = payload['DuongLich']!=null?payload['DuongLich']:1;
			createTaskController.startTime.value = payload['GioBatDau']!=null?payload['GioBatDau']:"08:00";
			createTaskController.endTime.value = payload['GioKetThuc']!=null?payload['GioKetThuc']:"24:00";
			createTaskController.selectedRemind.value = payload['Remind']!=null?payload['Remind']:0;
			createTaskController.selectedRepeat.value = payload['HandleRepeat']!=null?payload['HandleRepeat']==1?true:false:true;
			createTaskController.type.value = payload['Type'] !=null ? systemController.typeEvent.firstWhereOrNull((element) => element['Id']== payload['Type'] )['Id'] :0;
			_title.text =  payload['Ten'] !=null ? payload['Ten']:"";
			_content.text =  payload['ChiTiet'] !=null ? payload['ChiTiet']:"";
		}else{
			createTaskController.selectedDate = _taskListController.selectedDate;
			createTaskController.selectedToDate = _taskListController.selectedToDate;
		}
    	return GestureDetector(
			onTap: () => FocusScope.of(context).unfocus(),
			child: Scaffold(
				appBar: AppBar(
					centerTitle: true,
					title:Text( payload != null && payload['key'] != null ? payload['key']  :"Tạo sự kiện mới" ,style: headingStyle,),
					actions: [
					],
				),
				body:SingleChildScrollView(
					physics: BouncingScrollPhysics(),
					child: Column(
						children: [
							Container(
								padding: EdgeInsets.all(20),
								child: Column(
									children: [
										/* tiêu đề */
										Input(title: "Tiêu đề", hint: "Công việc của bạn", textEditingController: _title),
										SizedBox(height: 12,),
										/* nội dung */
										Input(title: "Nội dung", hint: "Chi tiết công việc", textEditingController: _content),
										SizedBox(height: 20,),
										/*----- ||   Giới tính   || -----*/
										GetBuilder(
											init: CreateTaskController(),
											builder: (createTaskController) =>Container(
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Padding(padding: EdgeInsets.only(bottom: 8),
															child: Text(
																"Loại",
																style: titleStyle,
															),
														),
														GestureDetector(
															onTap:()async{
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
																						onSelectedItemChanged: (int value) {
																							createTaskController.type.value = systemController.typeEvent[value]['Id'];
																						},
																						scrollController: FixedExtentScrollController(initialItem: systemController.typeEvent.indexWhere((element) => element['Id'] == createTaskController.type.value)),
																						children:systemController.typeEvent.map((i)=>Text(i['Name'] ??'')).toList(),
																					)
																				),
																			],
																		),
																	));

															},
															child: Container(
																height: 52,
																width: double.infinity,
																padding:EdgeInsets.symmetric(horizontal: 12),
																decoration: BoxDecoration(
																	border: Border.all(
																		color: Colors.grey,
																		width: 1
																	),
																	borderRadius: BorderRadius.circular(12)
																),
																child: Obx(()=>Align(
																	alignment: Alignment.centerLeft,
																	child: Text(systemController.typeEvent.length == 0 ? 'Chọn loại': systemController.typeEvent.firstWhereOrNull((element) => element['Id'] == createTaskController.type.value) == null
																		? systemController.typeEvent[0]['Name']
																		: systemController.typeEvent.firstWhereOrNull((element) => element['Id'] == createTaskController.type.value)['Name'] ,style: subTitleStyle,),
																))
															),
														)
													],
												),
											)
										),

										/*----- || End Giới tính || -----*/
										SizedBox(height: 20,),
										/*   Dương lịch hay âm lịch   */
										GetBuilder<CreateTaskController>(
											builder: (createTaskController) => Row(
												children: [
													Expanded(
														child: Padding(
															padding: EdgeInsets.symmetric(horizontal: 12),
															child: GestureDetector(
																onTap: (){
																	createTaskController.DuongLich.value = 0;
																},
																child: Obx(()=>Container(
																	height:  45,
																	decoration: BoxDecoration(
																		borderRadius: BorderRadius.circular(50),
																		color:createTaskController.DuongLich.value ==0 ? RootColor.cam_nhat:Get.isDarkMode? RootColor.button_darkmode : Colors.white,
																		border: Border.all(
																			color: createTaskController.DuongLich.value ==0 ? RootColor.cam_nhat: Get.isDarkMode? RootColor.button_darkmode : Colors.grey[600]!,
																		)
																	),
																	child:Center(
																		child:Row (
																			children: [
																				Expanded(flex: 1, child: Icon(Icons.bedtime_outlined ,color:createTaskController.DuongLich.value==0? Colors.white:Colors.grey[600]!),),
																				Expanded(flex: 2, child: Text("Âm lịch", style: CustomStyle(14,createTaskController.DuongLich.value==1?Colors.grey[600]!:Colors.white,FontWeight.w600),),)
																			],
																		)
																	),
																),)
															),
														)
													),
													Expanded(
														child: Padding(
															padding: EdgeInsets.symmetric(horizontal: 12),
															child: GestureDetector(
																onTap: (){
																	createTaskController.DuongLich.value = 1;
																},
																child: Obx(()=>Container(
																	height:  45,
																	decoration: BoxDecoration(
																		borderRadius: BorderRadius.circular(50),
																		color:createTaskController.DuongLich.value==1? RootColor.cam_nhat:Get.isDarkMode? RootColor.button_darkmode : Colors.white,
																		border: Border.all(
																			color: createTaskController.DuongLich.value==1? RootColor.cam_nhat: Get.isDarkMode? RootColor.button_darkmode : Colors.grey[600]!,
																		)
																	),
																	child:Center(
																		child:Row (
																			children: [
																				Expanded(flex: 1, child: Icon(Icons.sunny_snowing ,color:createTaskController.DuongLich.value==1? Colors.white:Colors.grey[600]!),),
																				Expanded(flex: 2, child: Text("Dương lịch", style: CustomStyle(14,createTaskController.DuongLich.value==1?Colors.white:Colors.grey[600]!,FontWeight.w600),))
																			],
																		)
																	),
																),)
															),
														),
													)
												],
											)
										),
										SizedBox(height: 20,),
										/* end Dương lịch hay âm lịch */

										/*   ngày thực hiện   */
										Container(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(
														"Ngày thực hiện",
														style: titleStyle,
													),
													SizedBox(height: 8,),
													GetBuilder(
														init: CreateTaskController(), // INIT IT ONLY THE FIRST TIME
														builder: (createTaskController) => Row(
															crossAxisAlignment: CrossAxisAlignment.center,
															children: [
																Obx(() => Expanded(child: PickInput(
																	hint: DateFormat.yMMMMEEEEd('vi').format(createTaskController.selectedDate),
																	DuongLich: createTaskController.DuongLich.value == 1 ? true:false,
																	date: createTaskController.selectedDate,
																	onTap:() async {
																		DateTime? _datepick = await  showDatePicker(
																			context: context,
																			initialDate: DateTime.now(),
																			firstDate: DateTime(DateTime.now().year-50),
																			lastDate: DateTime(DateTime.now().year+50)
																		);
																		if(_datepick!=null){
																			createTaskController.updateSelectedDate(_datepick);
																		}
																	}
																)),),
																Icon(Icons.keyboard_double_arrow_right_rounded,color: Colors.grey[600],),
																Obx(() => Expanded(child: PickInput(
																	hint: DateFormat.yMMMMEEEEd('vi').format(createTaskController.selectedToDate),
																	DuongLich: createTaskController.DuongLich.value == 1 ? true:false,
																	date: createTaskController.selectedToDate,
																	onTap:() async {
																		DateTime? _datepick = await  showDatePicker(
																			context: context,
																			initialDate: DateTime.now(),
																			firstDate: DateTime(DateTime.now().year-50),
																			lastDate: DateTime(DateTime.now().year+50)
																		);
																		if(_datepick!=null){
																			createTaskController.updateSelectedToDate(_datepick);
																		}
																	}
																),))
															],
														)
													),
												],
											),
										),
										SizedBox(height: 12,),
										/* end ngày thực hiện */

										/*   thời gian bắt đầu và kết thúc   */
										Obx(() => Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												Text("Cả ngày",
													style: titleStyle,
												),
												CupertinoSwitch(
													value: createTaskController.fullTime.value,
													onChanged: (value) {
														createTaskController.fullTime.value = value;
													},
												),
											],
										),),
										Obx(() => createTaskController.fullTime.value == false
											? Padding(
											padding: const EdgeInsets.only(top:8.0),
											child: Row(
												children: [
													Expanded(child:Input(
														hint: createTaskController.startTime.value,
														icon: IconButton(
															icon: Icon(Icons.access_time_outlined,color: Colors.grey,),
															onPressed: () async {
																var picker = await showTimePicker(
																	initialEntryMode: TimePickerEntryMode.dial,
																	context: context,
																	initialTime: TimeOfDay(hour:int.parse( createTaskController.startTime.value.split(":")[0]), minute:int.parse(  createTaskController.startTime.value.split(":")[1])),
																	builder: (context, child) {
																		return MediaQuery(
																			data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
																			child: child ?? Container(),
																		);
																	},
																);
																if(picker !=null) {
																	final localizations = MaterialLocalizations.of(context);
																	String formattedTime = localizations.formatTimeOfDay(picker!, alwaysUse24HourFormat: true);
																	createTaskController.startTime.value = formattedTime;
																}
															}
														),
													)),
													Icon(Icons.keyboard_double_arrow_right_rounded,color: Colors.grey[600],),
													Expanded(child:Input(
														hint: createTaskController.endTime.value,
														icon: IconButton(
															icon: Icon(Icons.access_time_outlined,color: Colors.grey,),
															onPressed: () async {
																var picker = await showTimePicker(
																	initialEntryMode: TimePickerEntryMode.dial,
																	context: context,
																	initialTime: TimeOfDay(hour:int.parse( createTaskController.endTime.value.split(":")[0]), minute:int.parse( createTaskController.endTime.value.split(":")[1])),
																	builder: (context, child) {
																		return MediaQuery(
																			data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
																			child: child ?? Container(),
																		);
																	},
																);
																if(picker !=null) {
																	final localizations = MaterialLocalizations.of(context);
																	String formattedTime = localizations.formatTimeOfDay(picker!, alwaysUse24HourFormat: true);
																	createTaskController.endTime.value = formattedTime;
																}
															}
														),
													)),
												],
											),
										)
											: SizedBox()),
										SizedBox(height: 12,),
										/* end thời gian bắt đầu và kết thúc */

										/* lặp lại */

										GetBuilder(
											init: CreateTaskController(),
											builder: (createTaskController) =>Container(
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Padding(padding: EdgeInsets.only(bottom: 8),
															child: Text(
																"Nhắc trước",
																style: titleStyle,
															),
														),
														GestureDetector(
															onTap:()async{
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
																						onSelectedItemChanged: (int value) {
																							createTaskController.selectedRemind.value= value;
																						},
																						scrollController: FixedExtentScrollController(initialItem: createTaskController.selectedRemind.value),
																						children:remind.map((i)=>Text(i.toString())).toList(),
																					)
																				),
																			],
																		),
																	));

															},
															child: Container(
																height: 52,
																width: double.infinity,
																padding:EdgeInsets.symmetric(horizontal: 12),
																decoration: BoxDecoration(
																	border: Border.all(
																		color: Colors.grey,
																		width: 1
																	),
																	borderRadius: BorderRadius.circular(12)
																),
																child: Obx(()=>Align(
																	alignment: Alignment.centerLeft,
																	child: Text(remind[createTaskController.selectedRemind.value],style: subTitleStyle,),
																))
															),
														)
													],
												),
											)
										),
										// Obx(() => 	Input(title: "Nhắc trước", hint: remind[createTaskController.selectedRemind.value]['label'],
										// 	icon: DropdownButton(
										// 		icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey,),
										// 		padding: EdgeInsets.only(right: 8),
										// 		iconSize: 32,
										// 		style: subTitleStyle,
										// 		items: remind.map<DropdownMenuItem<dynamic>>((item){
										// 			return DropdownMenuItem(
										// 				value: item['value'].toString(),
										// 				child: Text(item['label']),
										// 			);
										// 		}).toList(),
										// 		underline: Container(height: 0,),
										// 		onChanged:( newValues){
										// 			createTaskController.selectedRemind.value = int.parse(newValues);
										// 		},
										// 	),
										// ),),
										SizedBox(height: 12,),
										/* báo lại */
										Obx(() => 	Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												Text("Lặp lại mỗi năm",
													style: titleStyle,
												),
												CupertinoSwitch(
													value: createTaskController.selectedRepeat.value,
													onChanged: (value) {
														createTaskController.selectedRepeat.value = value;
													},
												),
											],
										),),
										SizedBox(height: 20,),
										MainButton(
											onTap: () async {
												if(_title.text.isEmpty){
													final snackBar = WarningSnackBar('Hãy nhập tiêu đề 😊😊');
													ScaffoldMessenger.of(context).showSnackBar(snackBar);
												} else{
													final res = await createTaskController.insertEvent(_title.text,_content.text);
													if(res ){
														final snackBar =SuccessSnackBar("Sự kiện của bạn đã được lưu 😘");
														ScaffoldMessenger.of(context).showSnackBar(snackBar);
														Get.back();
													}
													else{
														final snackBar =ErrorSnackBar("Xảy ra lỗi, vui lòng thử lại 😥");
														ScaffoldMessenger.of(context).showSnackBar(snackBar);
													}
												}
											},
											title: payload != null && payload['key'] != null ? payload['key']:"Thêm sự kiện"),
									],
								),
							),
						],
					),
				)),
		);
  	}

}