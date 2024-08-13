
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:luanvan/Component/Reminder/ListDetail.dart';
import 'package:luanvan/Controller/DetailPostController.dart';
import 'package:luanvan/Controller/Task.dart';
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
			onDidReceiveNotificationResponse: (NotificationResponse response) {
				handleNotificationTap(response.payload);
			},
		);
	}

	@pragma('vm:entry-point')
	void notificationTapBackground(NotificationResponse response) {
		// Gọi hàm xử lý chung
		handleNotificationTap(response.payload);
	}
	void handleNotificationTap(String? payload) {
		print("payload ${payload.toString()}");
		Get.to(()=>TaskDetailPage(payload: payload,));
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
		int minute,
		dynamic full,
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
			matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
			payload: full.toString()
		);
	}

	// Future<void> scheduleNotification(int minutes) async {
	// 	var androidPlatformChannelSpecifics = AndroidNotificationDetails(
	// 		'reminder_channel_id',
	// 		'Reminders',
	// 		channelDescription: 'Channel for reminder notifications',
	// 		importance: Importance.high,
	// 		priority: Priority.high,
	// 	);
	// 	var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
	// 	var platformChannelSpecifics = NotificationDetails(
	// 		android: androidPlatformChannelSpecifics,
	// 		iOS: iOSPlatformChannelSpecifics,
	// 	);
	//
	// 	await flutterLocalNotificationsPlugin.zonedSchedule(
	// 		0,
	// 		'Nhắc nhở',
	// 		'Đây là thông báo nhắc nhở của bạn',
	// 		tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes)),
	// 		platformChannelSpecifics,
	// 		androidAllowWhileIdle: true,
	// 		uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
	// 	);
	// }



	tz.TZDateTime convertTime(int year, int month, int day, int hour, int minute) {
		final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
		tz.TZDateTime schedule = tz.TZDateTime(tz.local, year, month, day, hour, minute);
		if (schedule.isBefore(now)) {
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