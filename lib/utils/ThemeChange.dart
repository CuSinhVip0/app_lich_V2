import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:luanvan/Controller/Component/UserController.dart';

class ThemeService {
	final _storage = GetStorage();
	save (bool darkmode) => _storage.write("isDarkMode", darkmode);
	bool loadThemeFromStorage ()=> _storage.read("isDarkMode")??false;
	ThemeMode get theme => loadThemeFromStorage()?ThemeMode.dark : ThemeMode.light;
	void changeTheme(value){
		Get.changeThemeMode(!value?ThemeMode.light : ThemeMode.dark);
		save(value);
	}

	savelanguage (String language)=>_storage.write("language", language);
	String loadLanguageFromStorage ()=>_storage.read("language")??'Vie';
	void changelanguage(language){
		var locale = language == "Eng" ? Locale('en', 'US'): Locale('vi', 'VN');
		Get.updateLocale(locale);
		savelanguage(language);
	}

}