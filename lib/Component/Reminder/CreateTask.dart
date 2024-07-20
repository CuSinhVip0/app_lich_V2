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
import 'package:luanvan/Controller/Remider/CreateTaskController.dart';
import 'package:luanvan/Services/Notification.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:provider/provider.dart';
import '../../Common/ErrorSnackBar.dart';
import '../../Common/Input/Input.dart';
import '../../Common/Button/MainButton.dart';
import '../../Common/SuccessSnackBar.dart';
import '../../Common/WarningSnackBar.dart';
import '../../Enum/Data.dart';
import '../../Controller/TaskList.dart';
import '../../Styles/Themes.dart';

class CreateTaskPage extends StatelessWidget {
	TaskListController _taskListController = Get.put(TaskListController());
	CreateTaskController createTaskController = Get.put(CreateTaskController());
	var payload;
	CreateTaskPage({this.payload});
	TextEditingController _title = TextEditingController();
	TextEditingController _content = TextEditingController();

	NotificationServices notifi = NotificationServices();
	List<dynamic> remind = [
		{
			"value":0,
			"label":"Không"
		},
		{
			"value":1,
			"label":"1 ngày"
		},
	];

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


	@override
  	Widget build(BuildContext context) {
		context.isDarkMode;
		if(payload != null){
			createTaskController.selectedDate= DateTime(int.parse(payload['date'][0]),int.parse(payload['date'][1]),int.parse(payload['date'][2]));
			createTaskController.selectedToDate= DateTime(int.parse(payload['date'][0]),int.parse(payload['date'][1]),int.parse(payload['date'][2]));
		}else{
			createTaskController.selectedDate = _taskListController.selectedDate;
			createTaskController.selectedToDate = _taskListController.selectedToDate;
		}
    	return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title:Text( "Tạo sự kiện mới" ,style: headingStyle,),
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
																							createTaskController.type.value= value;
																						},
																						children:createTaskController.typeEvent.map((i)=>Text(i['Name'] ??'')).toList(),
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
																child: Text(createTaskController.typeEvent.length == 0 ? 'Chọn loại': createTaskController.typeEvent[createTaskController.type.value]['Name'].toString(),style: subTitleStyle,),
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
									Obx(() => 	Input(title: "Nhắc trước", hint: remind[createTaskController.selectedRemind.value]['label'],
										icon: DropdownButton(
											icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey,),
											padding: EdgeInsets.only(right: 8),
											iconSize: 32,
											style: subTitleStyle,
											items: remind.map<DropdownMenuItem<dynamic>>((item){
												return DropdownMenuItem(
													value: item['value'].toString(),
													child: Text(item['label']),
												);
											}).toList(),
											underline: Container(height: 0,),
											onChanged:( newValues){
													createTaskController.selectedRemind.value = int.parse(newValues);
											},
										),
									),),
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
												DateTime time =  DateFormat.jm('vi').parse(createTaskController.startTime.toString());
												var myTime = DateFormat("HH:mm").format(time);
												notifi.scheduleNotification(
													0,
													"Công việc của bạn đã đến",
													_title.text,
													createTaskController.selectedDate.year,
													createTaskController.selectedDate.month,
													createTaskController.selectedDate.day,
													createTaskController.fullTime == true? 08 : int.parse(myTime.toString().split(":")[0]),
													createTaskController.fullTime == true? 00 :int.parse(myTime.toString().split(":")[1])
												);
												final snackBar = res['status'] == 'successfully' ? SuccessSnackBar(res['message']) : ErrorSnackBar(res['message']);
												ScaffoldMessenger.of(context).showSnackBar(snackBar);
												createTaskController.addTaskNoCallApi({
													"IdMain": res['id'],
													"Ten": _title.text,
													"Ngay": createTaskController.selectedDate.day,
													"Thang": createTaskController.selectedDate.month,
													"Nam": createTaskController.selectedDate.year,
													"ToDay":createTaskController.selectedToDate.day,
													"ToMonth":createTaskController.selectedToDate.month,
													"ToYear":createTaskController.selectedToDate.year,
													"GioBatDau": createTaskController.fullTime.value == true ?"00:00":createTaskController.startTime.value,
													"GioKetThuc": createTaskController.fullTime.value == true ?"24:00":createTaskController.endTime.value,
													"ChiTiet": _content.text,
													"HandleRepeat":createTaskController.selectedRepeat.value,
													"Remind":createTaskController.selectedRemind.value,
													"DuongLich":createTaskController.DuongLich.value,
													"Name":"Công việc"
												});
												Get.back();
											}
										},
										title: "Thêm sự kiện"),
								],
							),
						),
					],
				),
			));
  	}

}