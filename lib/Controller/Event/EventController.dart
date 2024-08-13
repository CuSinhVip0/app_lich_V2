import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../Enum/Data.dart';
import '../../utils/lunar_solar_utils.dart';

class EventController extends GetxController{
	var yearPrev =(DateTime.now().year-1).obs;
	var yearNext=(DateTime.now().year+1).obs;
	var hide =false.obs;
	var loading = false.obs;
	DateTime selectedDate = DateTime.now();
	List<dynamic> lunarDate =convertSolar2Lunar(DateTime.now().day,DateTime.now().month,DateTime.now().year,7);
	List<dynamic> mainItems = [];
	List<GlobalKey> mainKeys = [];
	List<dynamic> subItems = [];
	var show = false.obs;
	ItemScrollController itemScrollController  = ItemScrollController();

	//copy
	var currentindex = 0.obs;
	List<dynamic> copyMainItems = [];
	List<GlobalKey> copyMainKeys = [];

	var Day = DateTime.now().day.obs;
	var Month = DateTime.now().month.obs;
	var Year = DateTime.now().year.obs;
	var indexEvent = 0.obs;
	List<dynamic> listEvent=[];


	Future<dynamic> _getEvents ()async {
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/event/LV_getEvents'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"nam":selectedDate.year,
				}));
			dynamic result = jsonDecode(res.body);
			return result;
		}
		catch(e){
			print(e);
		}
	}

	void getEvents ()async{
		final list = await _getEvents();
		for (var i = 0; i < list['data'].length; i++) {
			mainItems.add(list['data'][i]);
			mainKeys.add(GlobalKey());
			copyMainItems.add(list['data'][i]);
			copyMainKeys.add(GlobalKey());
			update();
			refresh();
		}

		// Future.delayed(const Duration(seconds: 2)).then((value) {
		// 	WidgetsBinding.instance.addPostFrameCallback((_) {
		// 		WidgetsBinding.instance.addPostFrameCallback((_) {
		// 			itemScrollController.jumpTo(index: list['index'] as int ==null?0:list['index'] as int);
		// 			Future.microtask(() {
		// 					show.value = true;
		// 					currentindex.value = list['index'];
		// 					listEvent.assignAll(mainItems);
		// 					update();
		// 			});
		// 		});
		// 	});
		// });

	}
	@override
 	 void onInit() {
    	super.onInit();
  	}

	  @override
  void onReady() {
		  getEvents();
		  subItems = List<dynamic>.from(mainItems);
		  update();
		  refresh();
    super.onReady();
  }

}