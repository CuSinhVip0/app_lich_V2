
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:luanvan/Controller/DetailPostController.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../pages/DetailPostPage.dart';
class NotificationServices{
	FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
	final StreamController<String?> selectNotificationStream =StreamController<String?>.broadcast();
	init() async{
		_configureLocalTimeZone();
		final AndroidInitializationSettings  initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
		final InitializationSettings initializationSettings = InitializationSettings(
			android: initializationSettingsAndroid,
		);
		await flutterLocalNotificationsPlugin.initialize(
			initializationSettings,
			onDidReceiveNotificationResponse: onTapLocalNotification,
		);
	}

	void onTapLocalNotification(NotificationResponse notificationResponse) async {
		Get.toNamed('/detailPost' , parameters:{"payload":notificationResponse.payload!});
	}

	Future<void> showNotification(int id, String title) async {
		const AndroidNotificationDetails androidNotificationDetails =
		AndroidNotificationDetails('your channel id', 'your channel name',
			channelDescription: 'your channel description',
			importance: Importance.max,
			priority: Priority.high,
			ticker: 'ticker');
		const NotificationDetails notificationDetails =
		NotificationDetails(android: androidNotificationDetails);
		await flutterLocalNotificationsPlugin.show(
			id, 'Bài viết của bạn đã sẵn sàng', 'title', notificationDetails,
			payload: 'Default_Sound');
	}


	scheduleNotification (
		int id,
		String title,
		String body,
		int year,
		int month,
		int day,
		int hour,
		int minute
		) async{
		await flutterLocalNotificationsPlugin.zonedSchedule(
			id,
			title,
			body,
			convertTime(year,month,day,hour, minute),
			const  NotificationDetails(
				android: AndroidNotificationDetails(
					"chenal id",
					'channel name'
					'descriptions'
				)
			),
			androidAllowWhileIdle: true,
			uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
			matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
		);
	}
	tz.TZDateTime convertTime(int year, int month, int day, int hour, int minute){
		final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
		tz.TZDateTime schedule = tz.TZDateTime(tz.local,year, month,day,hour,minute);
		if(schedule.isBefore(now)){
			schedule = schedule.add(const Duration(days: 1));
		}
		return schedule;
	}

	Future<void> _configureLocalTimeZone() async {
		tz.initializeTimeZones();
		final timeZoneName = await FlutterTimezone.getLocalTimezone();
		tz.setLocalLocation(tz.getLocation(timeZoneName));
	}
}