import 'package:flutter/material.dart';

class DateToday extends ChangeNotifier{
	int? Day = DateTime.now().day;
	int? Month = DateTime.now().month;
	int? Year = DateTime.now().year;
	int indexEvent=0;
	List<dynamic> listEvent=[];

}