import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../Enum/Data.dart';
import '../Services/Notification.dart';
class UserController extends GetxController{
	var setting = {
		"DarkMode": false,
		"Language": "Vie",
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
		final token = await FacebookAuth.instance.accessToken;
		var userGoogle = await FirebaseAuth.instance.currentUser;
		if(token != null){
			userData =  await FacebookAuth.instance.getUserData();
			accessToken = token;
			isLogin.value = true;
			typeLogin.value = "FB";
			getSettingFromDataBase(userData['id'].toString());
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
			getSettingFromDataBase(userData['id'].toString());
			isLogin.value = true;
			typeLogin.value = "GG";
			update();
			return;
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
				getSettingFromDataBase(userData['id']);
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
			getSettingFromDataBase(userData['id']);
			update();
			return true;
		} catch (e) {
			print("-- Lỗi xảy ra ở UserController loginFaceBook - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController loginFaceBook - catch --");
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

	Future<dynamic> updateInforToDatabase(String id_platform, String platform ) async{
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/updateInforToDatabase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_Platform":id_platform,
					'Platform':platform
				}));
			dynamic result = jsonDecode(res.body);
			return result;
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController updateInforToDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController updateInforToDatabase - catch --");
		}
	}

	//#endregion

	//#region update setting
	void updateSetting (String param , dynamic value) async {
		var res =  await updateSettingtoDataBase(param,value);
		setting[param] = value;
		update();
	}

	Future<dynamic> updateSettingtoDataBase (String type , dynamic value) async {
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/updateSettingtoDataBase'),
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
			print("-- Lỗi xảy ra ở UserController updateSettingtoDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController updateSettingtoDataBase - catch --");
		}

	}

	void  getSettingFromDataBase(String id) async {
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/getSettingFromDataBase'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_Platform":id,
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke'){
				 setting = {
					"DarkMode": result['result']['DarkMode'],
					"Language": result['result']['Language'],
					"StyleTime":result['result']['StyleTime']
				};
				update();
			}
			Get.changeThemeMode(result['result']['DarkMode'] == true ? ThemeMode.dark : ThemeMode.light);
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController getSettingFromDataBase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController getSettingFromDataBase - catch --");
		}
	}
	//#endregion

	@override
	void onInit()  {
		checkLogin();
		super.onInit();
	}
}