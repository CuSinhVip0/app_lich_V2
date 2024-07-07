
import 'package:flutter/material.dart';

import '../pages/Event.dart';
import '../pages/Extension.dart';
import '../pages/ReminderPage.dart';
import '../pages/StatusPage.dart';
import '../pages/home.dart';
class Pages {
	static List<Widget> pages = [
		HomePage(),
		EventPage(1),
		ReminderPage(),
		ExtensionPage(),
		StatusPage()
	];
}