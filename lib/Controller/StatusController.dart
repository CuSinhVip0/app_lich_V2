import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart ' as http;

import '../Enum/Data.dart';

class StatusController extends GetxController{
	var listPost = [].obs;


	void getPostFromDataBase(int index, int limit) async {
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/getPostFromDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"index":index,
					"limit":limit
				}));
			dynamic result = jsonDecode(res.body);
			listPost.assignAll(result['result']);
			update();
			listPost.refresh();
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController getPostFromDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController getPostFromDataBase - catch --");
		}
	}

	@override
  	void onReady() {
		getPostFromDataBase(0,2);
		super.onReady();
  	}

}