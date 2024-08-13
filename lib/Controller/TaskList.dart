import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:luanvan/Controller/Component/UserController.dart';
import '../Enum/Data.dart';
import '../Services/Notification.dart';
class TaskListController extends GetxController{
	UserController userController = Get.find();
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
	var taskLists = [].obs;

	Future<dynamic> _getTask() async{
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/event/LV_getTaskfromDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Ngay":selectedDate.day,
					"Thang":selectedDate.month,
					"Nam":selectedDate.year,
					"IdUser":userController.userData['id']
				}));
			Iterable result = jsonDecode(res.body)['result'];
			return result;
		}
		catch (e) {
			print("-- Lỗi xảy ra ở TaskListController LV_getTaskfromDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở TaskListController LV_getTaskfromDatabase - catch --");
		}
	}

	Future<dynamic> deleteTaskFromDb(int id,int type) async{
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/event/LV_removeTaskfromDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id":id
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke'){
				taskLists[type][1].removeWhere((element) => element['IdMain']==id);
				taskLists.refresh();
				await NotificationServices().flutterLocalNotificationsPlugin.cancel(id);
				return true;
			}
			return result;
		}
		catch (e) {
			print("-- Lỗi xảy ra ở TaskListController deleteTaskFromDb - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở TaskListController deleteTaskFromDb - catch --");
			return false;
		}
	}

	void getTasks() async{
		Iterable res = await _getTask();
		taskLists.assignAll(res);
		refresh();
	}
	@override
	void onReady() {
		getTasks();
		super.onReady();
	}
	@override
	void onInit() {
		getTasks();
		super.onInit();
	}
}