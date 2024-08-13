import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../../Enum/Data.dart';
import '../../utils/DbHelper.dart';
class UserController extends GetxController{
	var setting = {
		"DarkMode": false,
		"Language":"Vie",
		"StyleTime":"24h"
	};
	var isLogin  = false.obs;
	var typeLogin = ''.obs;
	var test  = 'Hello'.obs;
	AccessToken? accessToken;
	var userData = {};
	GoogleSignIn googleSignIn = GoogleSignIn();
	//#region  login
	void checkLogin ()async{
		try{
			final token = await FacebookAuth.instance.accessToken;
			var userGoogle = await FirebaseAuth.instance.currentUser;
			if(token != null){
				userData =  await FacebookAuth.instance.getUserData();
				accessToken = token;
				isLogin.value = true;
				typeLogin.value = "FB";
				update();
				return;
			}
			if( userGoogle !=null) {
				userData = {
					'id' : userGoogle?.uid,
					'name':userGoogle.displayName,
					'email':userGoogle.email,
					'picture': {
						"data":{
							"url":userGoogle.photoURL,
						}
					}
				};
				isLogin.value = true;
				typeLogin.value = "GG";
				update();
				return;
			}
		}catch(e){
			print(e);
		}
	}

	Future<bool> loginFaceBook() async{
		try {
			final LoginResult res =  await FacebookAuth.instance.login();
			if(res.status == LoginStatus.success){
				accessToken = res.accessToken;
				userData =  await FacebookAuth.instance.getUserData();
				isLogin.value = true;
				typeLogin.value = "FB";
				update();
				return true;
			}else{
				print("-- Lỗi xảy ra ở UserController loginFaceBook - try --");
				print(res.status);
				print(res.message);
				print("-- End Lỗi xảy ra ở UserController loginFaceBook - try --");
				return false;
			}
		}
		catch (e){
			print("-- Lỗi xảy ra ở UserController loginFaceBook - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController loginFaceBook - catch --");
			return false;
		}
	}

	Future<bool> signInWithGoogle() async {
		try {
			final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
			final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
			final AuthCredential credential = GoogleAuthProvider.credential(
				accessToken: googleSignInAuthentication.accessToken,
				idToken: googleSignInAuthentication.idToken,
			);

			final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
			final User? user = userCredential.user;
			userData = {
				'id' : user?.uid,
				'name':user?.displayName,
				'email':user?.email,
				'picture': {
					"data":{
						"url":user?.photoURL,
					}
				}
			};
			isLogin.value = true;
			typeLogin.value = "GG";
			update();
			return true;
		} catch (e) {
			print("-- Lỗi xảy ra ở UserController signInWithGoogle - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController signInWithGoogle - catch --");
			return false;
		}
	}

	Future<bool> logoutFaceBook() async{
		try{
			await FacebookAuth.instance.logOut();
			accessToken = null;
			userData = {};
			isLogin.value = false;
			typeLogin.value	="";
			update();

			return true;
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController logoutFaceBook - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController logoutFaceBook - catch --");
			return false;
		}
	}

	Future<bool> logoutGoogle() async{
		try{
			await FirebaseAuth.instance.signOut();
			accessToken = null;
			userData = {};
			isLogin.value = false;
			typeLogin.value	="";
			update();
			return true;
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController logoutGoogle - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController logoutGoogle - catch --");
			return false;
		}
	}



	Future<bool> LV_spGetInforFromDatabase(String id_platform, String platform,String name,String urlPic, String email ) async{
		try {
			final res = await http.post(Uri.parse(ServiceApi.api + '/user/LV_spGetInforFromDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_Platform": id_platform,
					'Platform': platform,
					'Name': name,
					'UrlPic': urlPic,
					'Email': email,
				}));
			dynamic result = jsonDecode(res.body);
			if (result['status'] == 'oke'){
				setting = {
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
				return true;
			}
			return false;
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController LV_spGetInforFromDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController LV_spGetInforFromDatabase - catch --");
			return false;
		}
	}

	//#endregion

	//#region update setting
	void updateSetting (String param , dynamic value) async {
		try{
			var res =  await updateSettingtoDataBase(param,value);
		}catch (e){
			print(e);
		}
		setting[param] = value;
		update();
	}

	Future<dynamic> updateSettingtoDataBase (String type , dynamic value) async {
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/LV_updateSettingtoDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Type":type,
					'Value':value,
					"Id_Platform": userData['id'],
				}));
			dynamic result = jsonDecode(res.body);
			return result;
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController LV_updateSettingtoDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController LV_updateSettingtoDataBase - catch --");
		}
	}

	Future<bool> LV_resetSettingtoDataBase () async {
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/LV_resetSettingtoDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_User": userData['id'],
				}));
			dynamic result = jsonDecode(res.body);
			return	(result['status']=='oke')?true:false;
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController LV_resetSettingtoDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController LV_resetSettingtoDataBase - catch --");
			return false;
		}
	}

	//#endregion

	@override
	void onInit() async {
		Map<String, dynamic>? settings = await DbHelper.getSettings().then((value)  {
			setting = {
				"DarkMode": value?['darkmode'] == 1 ? true:false,
				"Language":value?['language'],
				"StyleTime":value?['styletime']
			};
			update();
			refresh();
			print(value);
			var local =value?['language'] =='Vie' ? Locale('vi', 'VN') : Locale('en', 'US');
			Get.updateLocale(local);
			Get.changeThemeMode(value?['darkmode']==0?ThemeMode.light : ThemeMode.dark);
		});
		checkLogin();
		super.onInit();
	}
}


// Future<dynamic> insertInforToDatabase(String id_platform, String platform,String name,String urlPic, String email ) async{
// 	try{
// 		final res = await http.post(Uri.parse(ServiceApi.api+'/user/insertInforToDatabase'),
// 			headers: {"Content-Type": "application/json"},
// 			body: jsonEncode({
// 				"Id_Platform":id_platform,
// 				'Platform':platform,
// 				'Name': name,
// 				'UrlPic':urlPic,
// 				'Email':email,
// 			}));
// 		dynamic result = jsonDecode(res.body);
// 		return result;
// 	}
// 	catch(e){
// 		print("-- Lỗi xảy ra ở UserController insertInforToDatabase - catch --");
// 		print(e);
// 		print("-- End Lỗi xảy ra ở UserController insertInforToDatabase - catch --");
// 	}
// }

// void  getSettingFromDataBase(String id) async {
// 	try{
// 		final res = await http.post(Uri.parse(ServiceApi.api+'/user/getSettingFromDataBase'),
// 			headers: {"Content-Type": "application/json"},
// 			body: jsonEncode({
// 				"Id_Platform":id,
// 			}));
// 		dynamic result = jsonDecode(res.body);
// 		if(result['status']=='oke'){
// 			 setting = {
// 				"DarkMode": result['result']['DarkMode'],
// 				"Language": result['result']['Language'],
// 				"StyleTime":result['result']['StyleTime']
// 			};
// 			 await DbHelper.updateSetting('language',result['result']['DarkMode']);
// 			 await DbHelper.updateSetting('darkmode', result['result']['Language']);
// 			 await DbHelper.updateSetting('styletime',result['result']['StyleTime']);
// 			 var local = result['result']['Language']=="Vie" ? Locale('vi', 'VN') : Locale('en', 'US');
// 			 Get.updateLocale(local);
// 			 Get.changeThemeMode(result['result']['DarkMode']==false?ThemeMode.light : ThemeMode.dark);
// 			update();
// 		}
// 		Get.changeThemeMode(result['result']['DarkMode'] == true ? ThemeMode.dark : ThemeMode.light);
// 	}
// 	catch(e){
// 		print("-- Lỗi xảy ra ở UserController getSettingFromDataBase - catch --");
// 		print(e);
// 		print("-- End Lỗi xảy ra ở UserController getSettingFromDataBase - catch --");
// 	}
// }