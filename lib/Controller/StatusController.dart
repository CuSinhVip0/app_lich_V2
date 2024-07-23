import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart ' as http;
import 'package:luanvan/Controller/Component/UserController.dart';

import '../Enum/Data.dart';

class StatusController extends GetxController{
	UserController userController = Get.find();
	var listPost = [].obs;
	var  scrollController = ScrollController();
	var i = 0.obs;
	var finished = false.obs;

	void updatelistPort(String key, var id){
		var post = listPost.firstWhereOrNull((element) => element['Id'] == id);
		post = {
			...post,
			'NumLike':post['IsLike']==0?post['NumLike']+1:post['NumLike']-1,
			'IsLike': post['IsLike']==0?1:0
		};
		int index  = listPost.indexWhere((element) => element['Id'] == id);
		listPost[index] = post;
		update();
		listPost.refresh();
	}

	void updateTotalCommentPost(var id, {int key = 1}){ // key = 1 cộng , key = 2 xóa
		var post = listPost.firstWhereOrNull((element) => element['Id'] == id);
		post = {
			...post,
			'NumComment':key == 1 ? post['NumComment'] + 1 :  post['NumComment'] - 1,
			'IsLike': post['IsLike']==0?1:0
		};
		var index = listPost.indexWhere((element) => element['Id'] == id);
		listPost[index] = post;
		update();
		listPost.refresh();
	}

	void getPostFromDataBase(int index, int limit) async {
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/post/getPostFromDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"index":index,
					"limit":limit,
					"Id_User":userController.userData['id']
				}));
			dynamic result = jsonDecode(res.body);
			if(result['result'].length>0){
				listPost.addAll(result['result']);
				update();
				listPost.refresh();
				i = i + 1;
			}
			else{
				finished.value = true;
			}
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController getPostFromDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController getPostFromDataBase - catch --");
		}
	}

	Future<void> updateLikeOfPosttoDataBase (int id,String id_user) async {
		try {
			final res = await http.post(Uri.parse(ServiceApi.api + '/post/updateLikeOfPosttoDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_Post":id,
					"Id_User":id_user
				}));
			dynamic result = jsonDecode(res.body);
			return result;
		}
		catch (e) {
			print("-- Lỗi xảy ra ở UserController updateLikeOfPosttoDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController updateLikeOfPosttoDataBase - catch --");
		}
	}
	
	@override
  	void onReady() {
		getPostFromDataBase(0,5);
		scrollController.addListener(() {
			if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
				if(finished == false) getPostFromDataBase(i.value,5);
			}
		});
		super.onReady();
  	}
}