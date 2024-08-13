import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luanvan/Controller/Home/Calender.dart';
import 'package:luanvan/Controller/TaskList.dart';
import 'package:luanvan/utils/lunar_solar_utils.dart';

import '../Enum/Data.dart';
import '../Services/Notification.dart';
import '../utils/DbHelper.dart';
import 'Component/UserController.dart';
import 'package:http/http.dart' as http;
class LoginController extends GetxController{
	UserController userController = Get.find();
	CalenderController  calenderController = Get.find();
	TaskListController taskListController = Get.find();
	var errorMessage= "".obs;
	var showPass = true.obs;
	var success = 1.obs;
	var showSyncDialog = false.obs;
	//0 : ko dong bo
	//1 : dong bo
	//2 : loi
	Future<int> LV_spGetInforFromDatabase( type) async {

		try {
			final res = await http.post(Uri.parse(ServiceApi.api + '/user/LV_spGetInforFromDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_Platform": userController.userData['id'],
					'Platform': type,
					'Name': userController.userData['name'],
					'UrlPic': userController.userData['picture']['data']['url'],
					'Email': userController.userData['email'],
				}));
			dynamic result = jsonDecode(res.body);
			if (result['status'] == 'oke'){
				if(result['type']== 1 ){
					return 0;
				}
				if(result['type']== 0){
					userController.setting = {
						"DarkMode": result['result']['DarkMode'],
						"Language": result['result']['Language'],
						"StyleTime": result['result']['StyleTime']
					};
					await DbHelper.updateSetting('darkmode', result['result']['DarkMode'] ==true ?1:0);
					await DbHelper.updateSetting('language', result['result']['Language']);
					await DbHelper.updateSetting('styletime', result['result']['StyleTime']);
					var local = result['result']['Language'] == "Vie" ? Locale('vi', 'VN') : Locale('en', 'US');
					Get.updateLocale(local);
					Get.changeThemeMode(result['result']['DarkMode'] == false ? ThemeMode.light : ThemeMode.dark);
					update();
					calenderController.getDateEventToSetBookmark(taskListController.selectedDate.month,taskListController.selectedDate.year);
					taskListController.getTasks();
					if(result['result']['Events']!=null){
						var items = jsonDecode(result['result']['Events']);
						var now = DateTime.now();
						items.forEach((i){
							var time = DateTime(i['Nam'],i['Thang'],i['Ngay'],int.parse(i['GioBatDau'].split(":")[0]),int.parse(i['GioBatDau'].split(":")[1]));
							if(i['DuongLich']==0){
								var lunar = convertLunar2Solar(i['Ngay'], i['Thang'], i['Nam'], 0, 7);
								time = DateTime(lunar[2],lunar[1],lunar[0],int.parse(i['GioBatDau'].split(":")[0]),int.parse(i['GioBatDau'].split(":")[1]));
							}

							if(time.compareTo(now)>=0){
								NotificationServices().scheduleNotification(
									0,
									"Công việc của bạn đã đến",
									i['Ten'],
									i['Nam'],
									i['Thang'],
									i['Ngay'],
									int.parse(i['GioBatDau'].split(":")[0]),
									int.parse(i['GioBatDau'].split(":")[1]),
									i
								);
							}
						});
					}
					return 1;
				}
			}
			return 2;
		} catch (e) {
			print("-- Lỗi xảy ra ở UserController LV_spGetInforFromDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController LV_spGetInforFromDatabase - catch --");
			return 2;
		}
	}

}