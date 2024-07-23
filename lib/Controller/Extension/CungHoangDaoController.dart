import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import'package:http/http.dart' as http;
import 'package:luanvan/Controller/Component/UserController.dart';

import '../../Enum/Data.dart';
class CungHoangDaoController extends GetxController{
	UserController userController = Get.find();
	var data =[].obs;
	var loading = false.obs;
	var index = 0.obs;

	Future<void> getInforCungHoangDao() async{
		loading.value =true;
		try{
			final res = await http.get(Uri.parse(ServiceApi.api+'/infor/getInforCungHoangDao'));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke'){
				data.assignAll(result['data']);
			}
			loading.value = false;
			update();
		}
		catch(e){
			print("-- Lỗi xảy ra ở CungHoangDaoController getInforCungHoangDao - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở CungHoangDaoController getInforCungHoangDao - catch --");
		}
	}


	  @override
  	void onReady() {
		getInforCungHoangDao();

   	 	super.onReady();
  	}
}