import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home/home.dart';

class SyncPage extends StatefulWidget {
	@override
	_SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
	int _progress = 0;

	@override
	void initState() {
		super.initState();
		_startSync();
	}

	void _startSync() async {
		for (int i = 0; i <= 100; i += 10) {
			await Future.delayed(Duration(milliseconds: 500));
			setState(() {
				_progress = i;
			});
		}
		// Khi đồng bộ hoàn tất, quay lại trang trước đăng nhập
		Navigator.pushReplacement(
			context,
			MaterialPageRoute(builder: (context) => HomePage()),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text('Đang đồng bộ')),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						CircularProgressIndicator(value: _progress / 100),
						SizedBox(height: 20),
						Text('Đã đồng bộ $_progress%'),
					],
				),
			),
		);
	}
}