import 'package:flutter/material.dart';
class Item {
	String? title;
	String? route;

	Item(this.title, this.route);
}

class NgayTotXau{
	static List<Item> item =[
		new Item('Ngày kết hôn', '/ngay-ket-hon'),
	];
}
