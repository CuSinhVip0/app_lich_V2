import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:luanvan/Controller/UserController.dart';

import '../Enum/Data.dart';
class InformationDetailController extends GetxController{
	UserController userController = Get.find();
	var loading = false.obs;
	var InforUser = {};
	var endLoading = true.obs;

	void updateInforUser (String key, var value){
		InforUser[key] = value;
		update();
	}

	Future<void> getInforFromDatabase(String id ) async{
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/getInforFromDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_User":id,
				}));
			dynamic result = jsonDecode(res.body);
			print(result['result']);
			InforUser.assignAll(result['result']);
			update();
		}
		catch(e){
			print("-- Lỗi xảy ra ở InformationDetailController getInforFromDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở InformationDetailController getInforFromDatabase - catch --");
		}
	}

	Future<void> updateInforToDatabase(String key,String id,var value ) async{
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/updateInforToDatabase/'+key),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_User":id,
					"Value":value
				}));
			dynamic result = jsonDecode(res.body);
			print(result['result']);
			InforUser.assignAll(result['result']);
			update();
		}
		catch(e){
			print("-- Lỗi xảy ra ở InformationDetailController getInforFromDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở InformationDetailController getInforFromDatabase - catch --");
		}
	}

	Future<bool> updateInforToDatabase_V2() async{
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/updateInforToDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_User":userController.userData['id'],
					'UrlPic':InforUser['UrlPic'],
					'Birth':InforUser['Birth'],
					'Name':InforUser['Name'],
					'Gender':InforUser['Gender'],
					'NguHanh':InforUser['NguHanh'],
					'CungMenh':InforUser['CungMenh']
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke')
				return true;
			return false;
		}
		catch(e){
			print("-- Lỗi xảy ra ở InformationDetailController updateInforToDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở InformationDetailController updateInforToDatabase - catch --");
			return false;
		}
	}



	@override
  	void onInit() {
    	getInforFromDatabase(userController.userData['id']);
		endLoading.value= false;
    	super.onInit();
  	}
}