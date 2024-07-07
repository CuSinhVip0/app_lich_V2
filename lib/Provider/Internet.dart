import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Internet extends ChangeNotifier{
	List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
	List<ConnectivityResult> get getHasInternet => _connectionStatus;

	setHasInternet(List<ConnectivityResult> value) {
		_connectionStatus = value;
		notifyListeners();
  	}


}