import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:luanvan/Services/Notification.dart';
import 'package:luanvan/Styles/Themes.dart';
import 'package:luanvan/pages/NavigatorPage.dart';
import 'package:luanvan/utils/Translates.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Controller/Navigator.dart';
import 'Controller/UserController.dart';
import 'Firebase.dart';
import 'Provider/Date.dart';
import 'Provider/Internet.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
	tz.initializeTimeZones();
	WidgetsFlutterBinding.ensureInitialized();
	// await ImageUtils.svgPrecacheImage();
	NotificationServices().init();
	await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
	final FCMToken = await FirebaseApi().initNoti();
	await FirebaseFirestore.instance.collection("fcmtokens").doc(FCMToken).set({"token_device":FCMToken}).then((value) => print("Lưu token thành công"));
	initializeDateFormatting('vi');
	Get.put<UserController>(UserController());

	runApp(MyApp());
}
class MyApp extends StatelessWidget {
	MyApp({super.key});
	UserController userController = Get.find();
	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				ChangeNotifierProvider<Internet>(create: (_)=>Internet()),
				ChangeNotifierProvider<DateToday>(create: (_)=>DateToday()),
			],
			child: GetMaterialApp(
				localizationsDelegates: [
					GlobalMaterialLocalizations.delegate,
					GlobalCupertinoLocalizations.delegate,
					DefaultWidgetsLocalizations.delegate,
				],
				supportedLocales: [
					const Locale('vi', 'VN'),
					const Locale('en', 'US'),
				],
				translations: Messages(), // your translations
				locale: Locale('vi', 'VN'), // translations will be displayed in that locale
				fallbackLocale: Locale('vi', 'VN'),
				theme: Themes.light,
				darkTheme: Themes.dark,
				themeMode:userController.setting["DarkMode"] == true ? ThemeMode.dark:ThemeMode.light,
				debugShowCheckedModeBanner: false,
				initialRoute: '/',
				getPages: [
					GetPage(
						name: '/',
						page: () => NavigatorPage(),
						binding: BindingsBuilder(() {
							Get.lazyPut<NavigatorController>(() => NavigatorController());
						}),
					),



					// //You can define a different page for routes with arguments, and another without arguments, but for that you must use the slash '/' on the route that will not receive arguments as above.
					// GetPage(
					// 	name: '/profile/:user',
					// 	page: () => UserProfile(),
					// ),
					// GetPage(
					// 	name: '/third',
					// 	page: () => Third(),
					// 	transition: Transition.cupertino
					// ),
				],
			),
		);
	}
}



