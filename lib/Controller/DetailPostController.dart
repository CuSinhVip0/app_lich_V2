import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Enum/Data.dart';


class DetailPostController extends GetxController{
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
					"CreateAt":DateTime.now().toString(),
				});
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

	Future<dynamic> getCommentFromDataBase (int Id_Post) async {
		try {
			final res = await http.post(Uri.parse(ServiceApi.api + '/post/getCommentFromDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					'Id_Post': Id_Post,
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

	@override
  	void onReady() {
		textEditingController.addListener(() {
			if(textEditingController.text != ''){
				hideButton.value = false;
			}
			else hideButton.value = true;
		});
		getCommentFromDataBase(payload['Id']);
    	super.onReady();
	}
}