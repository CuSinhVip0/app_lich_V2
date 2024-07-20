import 'dart:convert';

import 'package:get/get.dart';
import 'package:luanvan/Controller/TaskList.dart';
import 'package:http/http.dart' as http;
import 'package:luanvan/Controller/UserController.dart';

import '../../Enum/Data.dart';
class CreateTaskController extends GetxController{
	TaskListController taskListController = Get.find();
	UserController userController = Get.find();
	var fullTime = true.obs;
	var DuongLich = 1.obs;
	var startTime = "08:00".obs;
	var endTime = "20:00".obs;
	var selectedRemind = 0.obs;
	var selectedRepeat = true.obs;
	var type = 0.obs;
	var typeEvent = [].obs;
	DateTime selectedDate = DateTime.now();
	DateTime selectedToDate = DateTime.now();
	void updateSelectedDate (DateTime x){
		selectedDate = x;
		update();
	}
	void updateSelectedToDate (DateTime x){
		selectedToDate = x;
		update();
	}

	void addTaskNoCallApi (Map<String, dynamic> element){
		var listTaskInHour =  taskListController.taskLists.firstWhereOrNull((e) => e[0] == element['GioBatDau']);
		(listTaskInHour!=null) ? listTaskInHour[1].add(element)
			: taskListController.taskLists.add([ element['GioBatDau'] == "00:00" && element['GioKetThuc'] == "24:00" ? "Cả ngày": element['GioBatDau'],[element]]);
		taskListController.taskLists.refresh();
	}

	Future <dynamic> insertEvent(String title, String content) async{
		final res = await http.post(Uri.parse(ServiceApi.api+'/event/insertEvent'),
			headers: {"Content-Type": "application/json"},
			body: jsonEncode({
				"Ten":title,
				"Ngay":selectedDate.day,
				"Thang":selectedDate.month,
				"Nam":selectedDate.year,
				"ToDay":selectedToDate.day,
				"ToMonth":selectedToDate.month,
				"ToYear":selectedToDate.year,
				"GioBatDau":fullTime.value == true ? "00:00" : startTime.value,
				"GioKetThuc":fullTime.value == true ? "24:00" : endTime.value,
				"ChiTiet":content,
				"HandleRepeat":selectedRepeat.value,
				"Remind":selectedRemind.value,
				"DuongLich":DuongLich.value,
				"Type":typeEvent[type.value]["Id"],
				"Id_User":userController.userData['id'],
			}));
		dynamic result = jsonDecode(res.body);
		return result;
	}
	Future <void> getTypeEvent() async{
		try{
			final res = await http.get(Uri.parse(ServiceApi.api+'/system/getLoaiSuKien'));
			dynamic result = jsonDecode(res.body);
			print(result['data']);
			typeEvent.assignAll(result['data']);
			update();
		}
		catch(e){
			print("-- Lỗi xảy ra ở CreateTaskController getTypeEvent - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở CreateTaskController getTypeEvent - catch --");
		}
	}

	@override
  	void onInit() {
    	getTypeEvent();
  	}
}