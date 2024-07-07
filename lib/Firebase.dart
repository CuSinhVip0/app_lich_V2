
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
	final firebaseMess = FirebaseMessaging.instance;
	Future<String?> initNoti() async {
		try{
			await firebaseMess.requestPermission();
			final FCMToken = await firebaseMess.getToken();
			return FCMToken;
		}
		catch(e){
			print(e);
			return null;
		}
	}
	void what() async{
		print(firebaseMess.toString());
	}

}
