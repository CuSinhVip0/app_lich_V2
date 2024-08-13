
import 'package:flutter/material.dart';

import '../pages/Event/Event.dart';
import '../pages/Extension/Extension.dart';
import '../pages/Reminder/ReminderPage.dart';
import '../pages/StatusPage.dart';
import '../pages/Home/home.dart';
class Pages {
	static List<Widget> pages = [
		HomePage(),
		EventPage(),
		ReminderPage(),
		ExtensionPage(),
		StatusPage()
	];
}