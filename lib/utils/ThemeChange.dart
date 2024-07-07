import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:luanvan/Controller/UserController.dart';

class ThemeService {
	UserController userController = Get.find();
	final _storage = GetStorage();
	save (bool darkmode) => _storage.write("isDarkMode", darkmode);
	bool _loadThemeFromStorage ()=> _storage.read("isDarkMode")??false;
	ThemeMode get theme => _loadThemeFromStorage()?ThemeMode.dark : ThemeMode.light;
	void changeTheme(value){
		Get.changeThemeMode(!value?ThemeMode.light : ThemeMode.dark);
		userController.updateSetting('DarkMode', value);
		save(value);
	}
}