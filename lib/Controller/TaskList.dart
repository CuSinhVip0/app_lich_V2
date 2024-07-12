import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Enum/Data.dart';
class TaskListController extends GetxController{

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
	@override
  	void onInit() {
		getTasks();
	    super.onInit();
  	}

	@override
	void onReady() {
		super.onReady();
	}

	Future<dynamic> _getTask() async{
		final res = await http.post(Uri.parse(ServiceApi.api+'/event/getTask'),
			headers: {"Content-Type": "application/json"},
			body: jsonEncode({
				"Ngay":selectedDate.day,
				"Thang":selectedDate.month,
				"Nam":selectedDate.year,
			}));
		Iterable result = jsonDecode(res.body)['result'];
		return result;
	}
	void getTasks() async{
		Iterable res = await _getTask();
		taskLists.assignAll(res);
	}
}