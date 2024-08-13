import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import'package:http/http.dart' as http;
import 'package:luanvan/Controller/Component/UserController.dart';

import '../../Enum/Data.dart';
class ExtensionDetailController extends GetxController{
	UserController userController = Get.find();
	var payload = {}.obs;
	var birth = "".obs;
	var datePick = DateTime.now().toString().split(" ")[0].obs;
	var timeStart = DateTime.now().add(Duration(days: (DateTime.daysPerWeek-DateTime.now().weekday) + 1 )).toString().split(" ")[0].obs;
	var timeEnd = DateTime.now().add(Duration(days: (DateTime.daysPerWeek-DateTime.now().weekday) + 7)).toString().split(" ")[0].obs;
	var listData = [];
	var loading = false.obs;
	void updateOptions (int value ){
		if(value == 0){
			timeStart.value = DateTime.now().add(Duration(days: DateTime.now().weekday - 1)).toString().split(" ")[0];
			timeEnd.value = DateTime.now().add(Duration(days: (DateTime.daysPerWeek-DateTime.now().weekday))).toString().split(" ")[0];
		}
		else if (value == 1){
			timeStart.value = DateTime.now().add(Duration(days: (DateTime.daysPerWeek-DateTime.now().weekday) + 1 )).toString().split(" ")[0];
			timeEnd.value = DateTime.now().add(Duration(days: (DateTime.daysPerWeek-DateTime.now().weekday) + 7)).toString().split(" ")[0];
		}
		else if (value == 2) {
			timeStart.value = DateTime.now().toString().split(" ")[0];
			timeEnd.value =  DateTime.now().add(Duration(days: 7)).toString().split(" ")[0];
		}
		else if (value == 3) {
			timeStart.value = DateTime.now().toString().split(" ")[0];
			timeEnd.value =  DateTime.now().add(Duration(days: 15)).toString().split(" ")[0];
		}
		else if (value == 4) {
			timeStart.value = DateTime.now().toString().split(" ")[0];
			timeEnd.value =  DateTime.now().add(Duration(days: 30)).toString().split(" ")[0];
		}
		else if (value == 5) {
			timeStart.value = DateTime.now().toString().split(" ")[0];
			timeEnd.value =  DateTime(DateTime.now().year, DateTime.now().month + 3,DateTime.now().day).toString().split(" ")[0];
		}
	}

	Future<void> getGoodDay(String id, int Id_Su) async{
		loading.value =true;
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/infor/LV_getGoodDay'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_User":id,
					"Id_Su":Id_Su,
					"TimeStart":timeStart.value,
					"TimeEnd":timeEnd.value,
				}));
			dynamic result = jsonDecode(res.body);

			if(result['status']=='oke'){
				listData.assignAll(result['result']);
			}
			loading.value = false;
			update();
		}
		catch(e){
			print("-- Lỗi xảy ra ở ExtensionDetailController LV_getGoodDay - catch --");
			print(e);loading.value = false;
			print("-- End Lỗi xảy ra ở ExtensionDetailController LV_getGoodDay - catch --");
		}
	}
	Future<void> getBirth() async{
		loading.value =true;
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/system/LV_getBirthforUser'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"UserId":userController.userData['id'],
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke'){
				if(result['data'][0]["Birth"] == null){
					loading.value = false;
					return;
				}
				birth.value = result['data'][0]["Birth"];
			}
			loading.value = false;
			update();
		}
		catch(e){
			print("-- Lỗi xảy ra ở ExtensionDetailController LV_getBirthforUser - catch --");
			print(e);
			loading.value = false;
			print("-- End Lỗi xảy ra ở ExtensionDetailController LV_getBirthforUser - catch --");
		}
	}

	  @override
  	void onReady() {
		getBirth();
   	 	super.onReady();
  	}
}