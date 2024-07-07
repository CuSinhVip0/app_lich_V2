
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
	final _firebaseMess = FirebaseMessaging.instance;
	Future<void> initNoti() async {
		await _firebaseMess.requestPermission();
		final FCMToken = await _firebaseMess.getAPNSToken();
		print(FCMToken);
	}
}
