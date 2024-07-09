import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:luanvan/Controller/StatusController.dart';
import 'package:luanvan/Controller/UserController.dart';

import '../Enum/Data.dart';


class DetailPostController extends GetxController{
	UserController userController = Get.find();
	StatusController statusController = Get.find();
	var payload = {}.obs;
	var sending = false.obs;
	var detailComment = [].obs;
	var textEditingController = TextEditingController();
	var hideButton = true.obs;
	var showComment = false.obs;

	Future<bool> updateCommenttoDataBase (String content, int Id_Post,String Id_User ) async {
		try {
			final res = await http.post(Uri.parse(ServiceApi.api + '/post/updateCommenttoDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Content": content,
					'Level': 1,
					'Id_Post': Id_Post,
					"Id_User":Id_User,
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke'){
				detailComment.insert(0,{
					'Id':result['newId'],
					"Content": content,
					'Level': 1,
					'Id_Post': Id_Post,
					"Id_User":Id_User,
					"NumLike":0,
					"IsLike":0,
					"CreateAt":DateTime.now().toString(),
				});
				statusController.updateTotalCommentPost(payload['Id']);
				update();
				detailComment.refresh();
				return true;
			}
			return false;
		}
		catch (e) {
			print("-- Lỗi xảy ra ở UserController updatePosttoDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController updatePosttoDataBase - catch --");
			return false;
		}
	}

	Future<dynamic> getCommentFromDataBase (int Id_Post, String Id_User) async {
		try {
			final res = await http.post(Uri.parse(ServiceApi.api + '/post/getCommentFromDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					'Id_Post': Id_Post,
					'Id_User': Id_User,
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke'){
				detailComment.assignAll(result['result']);
				showComment.value = true;
				update();
				detailComment.refresh();
			}
		}
		catch (e) {
			print("-- Lỗi xảy ra ở UserController getCommentFromDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController getCommentFromDataBase - catch --");
		}
	}

	void updatelistPort(){
		payload.value["NumLike"] = payload['IsLike'] == 0 ? payload.value['NumLike'] + 1 : payload.value['NumLike'] - 1;
		payload.value['IsLike'] = payload['IsLike'] == 0 ? 1 : 0;
		update();
		payload.refresh();
	}

	Future<void> updateLikeOfCommenttoDataBase (int id,String id_user) async {
		try {
			final res = await http.post(Uri.parse(ServiceApi.api + '/post/updateLikeOfCommenttoDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_Comment":id,
					"Id_User":id_user
				}));
			dynamic result = jsonDecode(res.body);
			return result;
		}
		catch (e) {
			print("-- Lỗi xảy ra ở UserController updateLikeOfCommenttoDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController updateLikeOfCommenttoDataBase - catch --");
		}
	}

	void updatelikeComments(var id){
		var comment = detailComment.firstWhereOrNull((element) => element['Id'] == id);
		comment = {
			...comment,
			'NumLike':comment['IsLike']==0?comment['NumLike']+1:comment['NumLike']-1,
			'IsLike': comment['IsLike']==0 ? 1 : 0
		};
		int index  = detailComment.indexWhere((element) => element['Id'] == id);
		detailComment[index] = comment;
		update();
		detailComment.refresh();
	}

	@override
  	void onReady() {
		textEditingController.addListener(() {
			if(textEditingController.text != ''){
				hideButton.value = false;
			}
			else hideButton.value = true;
		});
		getCommentFromDataBase(payload['Id'],userController.userData['id']);
    	super.onReady();
	}
}