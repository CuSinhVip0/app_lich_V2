import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luanvan/Controller/Component/SystemController.dart';
import 'package:luanvan/Controller/Home/Calender.dart';
import 'package:luanvan/Controller/TaskList.dart';
import 'package:http/http.dart' as http;
import 'package:luanvan/Controller/Component/UserController.dart';
import 'package:luanvan/utils/lunar_solar_utils.dart';

import '../../Enum/Data.dart';
import '../../Services/Notification.dart';
class CreateTaskController extends GetxController{
	CalenderController calenderController = Get.find();
	TaskListController taskListController = Get.find();
	SystemController systemController = Get.find();
	UserController userController = Get.find();
	var id = 0.obs;
	var fullTime = true.obs;
	var DuongLich = 1.obs;
	var startTime = "08:00".obs;
	var endTime = "20:00".obs;
	var selectedRemind = 0.obs;
	var selectedRepeat = true.obs;
	var type = 0.obs;
	DateTime selectedDate = DateTime.now();
	DateTime selectedToDate = DateTime.now();
	NotificationServices notifi = NotificationServices();

	void updateSelectedDate (DateTime x){
		selectedDate = x;
		update();
	}
	void updateSelectedToDate (DateTime x){
		selectedToDate = x;
		update();
	}

	void addTaskNoCallApi (Map<String, dynamic> element){
		if(!(taskListController.selectedDate.day == element['Ngay']
			&&  taskListController.selectedDate.month == element['Thang']
			&&  taskListController.selectedDate.year == element['Nam'])) return;
		if(element['GioBatDau'] == "00:00" && element['GioKetThuc']=='24:00'){
			if(taskListController.taskLists.firstWhereOrNull((element) => element[0]=="Cả ngày")==null) {
				taskListController.taskLists.add(["Cả ngày",[element]]);
				taskListController.taskLists.refresh();
				return;
			}
			taskListController.taskLists[0][1].add(element);
			taskListController.taskLists.refresh();
			return;
		}
		var listTaskInHour =  taskListController.taskLists.firstWhereOrNull((e) => e[0] == element['GioBatDau']);
		if((listTaskInHour!=null)) {
			for (int i = 0; i < taskListController.taskLists.length; i++) {
				if (taskListController.taskLists[i][0] != element['GioBatDau']) continue;
				taskListController.taskLists[i][1].add(element);
				taskListController.refresh();
				break;
			}
		}
		else  {
			taskListController.taskLists.add([ element['GioBatDau'] == "00:00" && element['GioKetThuc'] == "24:00" ? "Cả ngày": element['GioBatDau'],[element]]);
			taskListController.refresh();
		}
		update();
		refresh();
	}

	Future <dynamic> insertEvent(String title, String content) async{
		try{
			print(systemController.typeEvent.firstWhereOrNull((element) => element['Id'] == type.value));
			var lunar = convertSolar2Lunar(int.parse(selectedDate.day.toString()), int.parse(selectedDate.month.toString()), int.parse(selectedDate.year.toString()),  7);
			var lunarto = convertSolar2Lunar(int.parse(selectedToDate.day.toString()), int.parse(selectedToDate.month.toString()), int.parse(selectedToDate.year.toString()),  7);
			final res = await http.post(Uri.parse(ServiceApi.api+'/event/LV_insertEventtoDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id":id.value,
					"Ten":title,
					"Ngay":DuongLich.value == 1 ? selectedDate.day : (lunar[0]),
					"Thang":DuongLich.value == 1 ? selectedDate.month : (lunar[1]),
					"Nam": DuongLich.value == 1 ? selectedDate.year: (lunar[2]),
					"ToDay":DuongLich.value == 1 ?selectedToDate.day:(lunarto[0]),
					"ToMonth":DuongLich.value == 1 ?selectedToDate.month:(lunarto[1]),
					"ToYear":DuongLich.value == 1 ?selectedToDate.year:(lunarto[2]),
					"GioBatDau":fullTime.value == true ? "00:00" : startTime.value,
					"GioKetThuc":fullTime.value == true ? "24:00" : endTime.value,
					"ChiTiet":content,
					"HandleRepeat":selectedRepeat.value,
					"Remind":selectedRemind.value,
					"DuongLich":DuongLich.value,
					"Type":systemController.typeEvent.firstWhere((element) => element['Id'] == type.value)["Id"],
					"Id_User":userController.userData['id'],
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke'){
				DateTime time =  DateFormat.jm('vi').parse(startTime.toString());
				var myTime = DateFormat("HH:mm").format(time);
				if(	id.value == 0 ){
					addTaskNoCallApi({
						"IdMain": result['id'],
						"Ten": title,
						"Ngay": selectedDate.day,
						"Thang": selectedDate.month,
						"Nam": selectedDate.year,
						"ToDay":selectedToDate.day,
						"ToMonth":selectedToDate.month,
						"ToYear":selectedToDate.year,
						"GioBatDau": fullTime.value == true ?"00:00":startTime.value,
						"GioKetThuc": fullTime.value == true ?"24:00":endTime.value,
						"ChiTiet": content,
						"HandleRepeat":selectedRepeat.value,
						"Remind":selectedRemind.value,
						"DuongLich":DuongLich.value,
						"Name":systemController.typeEvent.firstWhere((element) => element['Id'] == type.value)["Name"],
						"EventSystem":0
					});
					notifi.scheduleNotification(
						result['id'] as int,
						"Công việc của bạn đã đến",
						title,
						selectedDate.year,
						selectedDate.month,
						selectedDate.day,
						fullTime.value == true? 08 : int.parse(myTime.toString().split(":")[0]),
						fullTime.value == true? 00 :int.parse(myTime.toString().split(":")[1]),
						result['id']
					);
				}
				else{
					taskListController.getTasks();
				}
				calenderController.getDateEventToSetBookmark(selectedDate.month,selectedDate.year);
				return true;
			}
			return false;
		}
		catch(e){
			print("-- Lỗi xảy ra ở CreateTaskController LV_insertEventtoDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở CreateTaskController LV_insertEventtoDatabase - catch --");
			return false;
		}
	}
	Future <void> getTypeEvent() async{
		try{
			final res = await http.get(Uri.parse(ServiceApi.api+'/system/getLoaiSuKien'));
			dynamic result = jsonDecode(res.body);
			systemController.typeEvent.assignAll(result['data']);
			type.value = result['data'][0]["Id"];
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