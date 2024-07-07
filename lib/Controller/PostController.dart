import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luanvan/Services/Notification.dart';
import 'package:luanvan/utils/getRandomString.dart';
import 'package:http/http.dart' as http;

import '../Enum/Data.dart';

class PostController extends GetxController{
	List<File> imgFile = [];
	FirebaseStorage storage = FirebaseStorage.instance;
	var loading  = false.obs;

	void updateFileImage (String img) {
		imgFile.add(File(img));
		update();
	}
	void removeItemFileImage (File index) {
		imgFile.remove(index);
		update();
	}

	Future<String> uploadFile(File _image) async {
		Reference storageReference = storage
			.ref()
			.child('posts/${DateFormat('yyyy-MM-dd').format(DateTime.now())}/${getRandomString()}');
		UploadTask uploadTask = storageReference.putFile(_image);
		TaskSnapshot taskSnapshot = await uploadTask;
		return await taskSnapshot.ref.getDownloadURL();
	}

	Future<List<String>> UploadImageToFirebase () async {
		try{
			var imageUrls = await Future.wait(imgFile.map((_image) => uploadFile(_image)));
			return imageUrls;
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController loginFaceBook - try --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController loginFaceBook - try --");
			return [];
		}
	}

	Future<dynamic> updatePosttoDataBase (String title, List<String> urlImage,String Id_User,String Platform ) async {
		try {
			final res = await http.post(Uri.parse(ServiceApi.api + '/user/updatePosttoDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Title": title,
					'Type': 'normal',
					'UrlImages': urlImage,
					"Id_User":Id_User,
					"Platform":Platform
				}));
			dynamic result = jsonDecode(res.body);
			return result;
		}
		catch (e) {
			print("-- Lỗi xảy ra ở UserController updatePosttoDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController updatePosttoDataBase - catch --");
		}
	}

	Future<bool> uploadPost(String title,String Id_User,String Platform) async{
		List<String> urlImgs = [];
		if(imgFile.length>0){
			urlImgs = await UploadImageToFirebase();
			if(urlImgs.length==0){
				print("Lỗi xảy ra");
				return false;
			}
		}
		dynamic res = await updatePosttoDataBase(title,urlImgs,Id_User,Platform);
		if(res['status']=="error"){
			return false;
		}
		NotificationServices().showNotification(res['newId'], res['title']);
		return true;
	}

}