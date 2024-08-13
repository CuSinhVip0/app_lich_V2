import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Enum/Data.dart';
class TaskController extends GetxController{
	Map<String, dynamic> task = {};
	void setTask (Map<String, dynamic> e){
		task = e;
		update();
	}
	Future<dynamic> LV_getInforTaskfromDatabase(id) async{
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/event/LV_getInforTaskfromDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id": id,
					"Type":0//0:user_event   1:eventsystem
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status'] == 'oke'){
				setTask(result['data']);
				update();
				refresh();
				return true;
			}
			return false;
		}
		catch (e) {
			print("-- Lỗi xảy ra ở TaskController LV_getInforTaskfromDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở TaskController LV_getInforTaskfromDatabase - catch --");
			return false;
		}
	}
}