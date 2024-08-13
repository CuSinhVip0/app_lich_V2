import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import '../../Enum/Data.dart';
class SystemController extends GetxController{
	var typeEvent = [].obs;
	var connectionStatus = [ConnectivityResult.none];
	final Connectivity connectivity = Connectivity();
	late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
	void updateConnectionStatus (List<ConnectivityResult> e ){
		connectionStatus = e;
		update();
	}

	Future<void> initConnectivity() async {
		late List<ConnectivityResult> result;
		try {
			result = await connectivity.checkConnectivity();
		} on PlatformException catch (e) {
			developer.log('Couldn\'t check connectivity status', error: e);
			return;
		}

		return _updateConnectionStatus(result);
	}
	Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
		updateConnectionStatus(result);
		print('Connectivity changed: ${connectionStatus}');
	}
	Future <void> getTypeEvent() async{
		try{
			final res = await http.get(Uri.parse(ServiceApi.api+'/system/getLoaiSuKien'));
			dynamic result = jsonDecode(res.body);
			typeEvent.assignAll(result['data']);
			update();
		}
		catch(e){
			print("-- Lỗi xảy ra ở CreateTaskController getTypeEvent - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở CreateTaskController getTypeEvent - catch --");
		}
	}

	@override
  	void onInit() {
		initConnectivity();
		connectivitySubscription =
			connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
		getTypeEvent();
    	super.onInit();
	}
}