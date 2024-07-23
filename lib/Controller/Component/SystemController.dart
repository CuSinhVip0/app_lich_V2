import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
class SystemController extends GetxController{
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

	@override
  	void onInit() {
		initConnectivity();
		connectivitySubscription =
			connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    	super.onInit();
	}
}