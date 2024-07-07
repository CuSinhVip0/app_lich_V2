import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luanvan/Controller/Navigator.dart';
import 'package:luanvan/Enum/Page.dart';

class NavigatorPage extends StatelessWidget {
	NavigatorController navigatorController = Get.find();
	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		return  GetX<NavigatorController>(
			builder: (navigatorController)=>Scaffold(
				body:Pages.pages[navigatorController.currentIndex.value],
				bottomNavigationBar: BottomNavigationBar(
					currentIndex: navigatorController.currentIndex.value,
					onTap: (index) {
						navigatorController.currentIndex.value = index;
					},
					selectedItemColor:Get.isDarkMode?Colors.white: Color(0xffff745c),
					unselectedItemColor: Colors.grey,
					showUnselectedLabels: false,
					showSelectedLabels: false,
					type: BottomNavigationBarType.fixed,
					items: [
						const BottomNavigationBarItem(label: "", icon: Icon(Icons.home_sharp)),
						const BottomNavigationBarItem(label: "", icon: Icon(Icons.calendar_month_sharp)),
						const BottomNavigationBarItem(label: "", icon: Icon(Icons.add)),
						const BottomNavigationBarItem(label: "", icon: Icon(Icons.apps_sharp)),
						const BottomNavigationBarItem(label: "", icon: Icon(Icons.account_circle_sharp)),
					],
				),
			)
		);
	}
}