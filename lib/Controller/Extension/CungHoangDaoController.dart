import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import'package:http/http.dart' as http;
import 'package:luanvan/Controller/Component/UserController.dart';

import '../../Enum/Data.dart';
class CungHoangDaoController extends GetxController with GetSingleTickerProviderStateMixin{
	UserController userController = Get.find();
	var data =[].obs;
	var loading = false.obs;
	var index = 0.obs;
	 TabController? tab;
	Future<void> getInforCungHoangDao() async{
		loading.value =true;
		try{
			final res = await http.get(Uri.parse(ServiceApi.api+'/infor/LV_getInforCungHoangDao'));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke'){
				data.assignAll(result['data']);
			}
			loading.value = false;
			update();
		}
		catch(e){
			print("-- Lỗi xảy ra ở CungHoangDaoController LV_getInforCungHoangDao - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở CungHoangDaoController LV_getInforCungHoangDao - catch --");
		}
	}

	  @override
  	void onReady() {
		  getInforCungHoangDao();
		  tab = TabController(length: 4,initialIndex: 0, vsync: this);
   	 	super.onReady();
  	}
}