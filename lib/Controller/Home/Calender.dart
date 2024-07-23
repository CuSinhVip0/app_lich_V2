import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

import '../../Enum/Data.dart';
import '../../Styles/Colors.dart';
import '../../utils/lunar_solar_utils.dart';
import '../TaskList.dart';
class CalenderController extends GetxController {
	var taskListController  = Get.put(TaskListController());
	var addY = (DateTime.now().year);
	var addM =  DateTime.now().month;
	var addD = DateTime.now().day;
	List<int> listnext = [0, 1, 2];
	List<int> listprev = [-1, -2];
	var list = [-2, -1, 0, 1, 2].obs;
	int pointLeft = -2; // diem them items
	int pointRight = 2; // diem them item
	DateTime pick =  DateTime.now();
	List<GlobalKey> listOfGlobalKeys = List.generate(5, (index) {
		return GlobalKey();
	});
	var listBookmark = [].obs;
	var pages = [];
	var pagesprev = [];
	ScrollController controller = ScrollController();
	int initIndex = 0;


	void setPages(List<dynamic> e){
		pages = e;
		update();
	}
	void setPagePrev(List<dynamic> e){
		pagesprev = e;
		update();
	}

	void setPick(DateTime e){
		pick = e;
		update();
	}

	Future<dynamic> _getDateEventToSetBookmark(int month, int year,int key) async {
		final res = await http.post(Uri.parse(ServiceApi.api + '/event/getDateEventToSetBookmark'),
			headers: {"Content-Type": "application/json"},
			body: jsonEncode({
				"Thang": month,
				"Nam": year,
				"Key":key,
			}));
		Iterable result = jsonDecode(res.body);
		return result;
	}
	void getDateEventToSetBookmark(int month,int year)async {
		var list = await _getDateEventToSetBookmark( month, year,3);
		listBookmark.value = list;
		setPages(List.generate(listnext.length, (index) {
			GlobalKey key = listOfGlobalKeys[index + listprev.length];
			DateTime date = DateTime(addY, addM + listnext[index], addD);
			int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
			int f = Jiffy.parse("${date.year}-${date.month}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
			if (f == 1) f = 8;
			var items = list[1][index][1];
			return Padding(
				padding: EdgeInsets.symmetric(horizontal: 12),
				key: key,
				child: GridView.count(
					physics: NeverScrollableScrollPhysics(),
					crossAxisCount: 7,
					children: List.generate(n + f - 2, (index) {
						index += 1;
						if (index > f - 2) {
							List<dynamic> lunar = convertSolar2Lunar(index - f + 2, date.month,  date.year, 7.0);
							bool isNow = DateTime.now().day == index - f + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
							bool isHoangDao = getNgayHoangDao(index - f + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
							bool isSchedule =false;
							if(items.length>0 && items[0]['Ngay']==(index - f + 2)){
								isSchedule= true;
								items.removeAt(0);
							}
							return  Padding(
								padding: EdgeInsets.all(2),
								child: GetBuilder<CalenderController>(
									builder: (_)=> TextButton(
										onPressed: () {
											DateTime now = DateTime.now();
											DateTime selectedDate = DateTime(date.year, date.month, index - f + 2, now.hour, now.minute, now.second);
											setPick(selectedDate);
											taskListController.updateSelectedDate(selectedDate);
											taskListController.updateSelectedToDate(selectedDate);
											taskListController.getTasks();
										},
										style: TextButton.styleFrom(
											padding: EdgeInsets.zero,
											backgroundColor:(pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year ) ? Color(0xffff745c) : Get.isDarkMode ? RootColor.button_darkmode : Colors.white,
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12),
												side: BorderSide(
													color: isNow ? RootColor.cam_nhat : Colors.transparent,
													width: 2,
												)
											),
										),
										child: Stack(
											children: [
												SizedBox(
													child: Column(
														children: [
															Expanded(
																flex: 3,
																child: Center(
																	child: Text(
																		(index - f + 2).toString(),
																		style: TextStyle(fontSize: 16, color: (pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year ) ? Colors.white :  Get.isDarkMode ?  Colors.white: Colors.black ),
																	),
																)),
															Expanded(
																flex: 2,
																child: Text(
																	lunar[0] == 1 ? "${lunar[0]}/${lunar[1]}" : lunar[0].toString(),
																	style: TextStyle(
																		fontSize: 12,
																		color:  isHoangDao
																			?  Colors.green
																			:  (pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year )
																			? Colors.white
																			: Color(0xff7d7f86)),
																),
															),
														],
													),
												),
												/*   vị trí có lịch trình thì có đấu   */
												isSchedule
													? Positioned(
													top: -3,
													right:-5,
													child: Icon(Icons.bookmark_outlined,color: Colors.green,size: 20,)
												):SizedBox()
												/* end vị trí có lịch trình thì có đấu */
											],
										)
									)
								)
							);
						} else {
							return TextButton(
								onPressed: () {},
								child: SizedBox(),
							);
						}
					}),
				),
			);
		}));
		setPagePrev(List.generate(listprev.length, (index) {
			GlobalKey key = listOfGlobalKeys[index];
			DateTime date = DateTime(addY, addM + listprev[index], addD);
			int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
			int f = Jiffy.parse("${date.year}-${date.month}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
			if (f == 1) f = 8;
			var items = list[0][index][1];
			return Padding(
				padding: EdgeInsets.symmetric(horizontal: 12),
				key: key,
				child: GridView.count(
					physics: NeverScrollableScrollPhysics(),
					crossAxisCount: 7,
					children: List.generate(n + f - 2, (index) {
						index += 1;
						if (index > f - 2) {
							List<dynamic> lunar = convertSolar2Lunar(index - f + 2, date.month,  date.year, 7.0);
							bool isNow = DateTime.now().day == index - f + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
							bool isHoangDao = getNgayHoangDao(index - f + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
							bool isSchedule =false;
							if(items.length>0 && items[0]['Ngay']==(index - f + 2)){
								isSchedule= true;
								items.removeAt(0);
							}
							return  Padding(
								padding: EdgeInsets.all(2),
								child: GetBuilder<CalenderController>(
									builder: (_)=> TextButton(
										onPressed: () {
											DateTime now = DateTime.now();
											DateTime selectedDate = DateTime(date.year, date.month, index - f + 2, now.hour, now.minute, now.second);
											setPick(selectedDate);
											taskListController.updateSelectedDate(selectedDate);
											taskListController.updateSelectedToDate(selectedDate);
											taskListController.getTasks();
										},
										style: TextButton.styleFrom(
											padding: EdgeInsets.zero,
											backgroundColor:(pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year ) ? Color(0xffff745c) : Get.isDarkMode ? RootColor.button_darkmode : Colors.white,
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12),
												side: BorderSide(
													color: isNow ? RootColor.cam_nhat : Colors.transparent,
													width: 2,
												)
											),
										),
										child: Stack(
											children: [
												SizedBox(
													child: Column(
														children: [
															Expanded(
																flex: 3,
																child: Center(
																	child: Text(
																		(index - f + 2).toString(),
																		style: TextStyle(fontSize: 16, color: (pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year ) ? Colors.white :  Get.isDarkMode ?  Colors.white: Colors.black ),
																	),
																)),
															Expanded(
																flex: 2,
																child: Text(
																	lunar[0] == 1 ? "${lunar[0]}/${lunar[1]}" : lunar[0].toString(),
																	style: TextStyle(
																		fontSize: 12,
																		color:  isHoangDao
																			?  Colors.green
																			:  (pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year )
																			? Colors.white
																			: Color(0xff7d7f86)),
																),
															),
														],
													),
												),
												/*   vị trí có lịch trình thì có đấu   */
												isSchedule
													? Positioned(
													top: -3,
													right:-5,
													child: Icon(Icons.bookmark_outlined,color:  Colors.green,size: 20,)
												):SizedBox()
												/* end vị trí có lịch trình thì có đấu */
											],
										)
									)
								)
							);
						} else {
							return TextButton(
								onPressed: () {},
								child: SizedBox(),
							);
						}
					}),
				),
			);
		}));
	}

	void pageprev() async {
		list // xoa cuoi va them dau
			..insert(0, list.first - 1)
			..removeLast();
		initIndex = initIndex - 1; // giam vi tri cua page view di 1
		GlobalKey key = GlobalKey();
		listOfGlobalKeys
			..insert(0, key) // insert 1 key voi vao dau
			..removeLast();
		DateTime date = DateTime(addY, addM + list.first, addD);
		var items = await _getDateEventToSetBookmark( date.month,date.year,1);
		int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
		int f = Jiffy.parse("${date.year}-${date.month}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
		if (f == 1) f = 8;
		if (list.first + 1 == pointLeft) {
			pagesprev.add(Padding(
				padding: EdgeInsets.symmetric(horizontal: 12),
				key: key,
				child: GridView.count(
					physics: NeverScrollableScrollPhysics(),
					crossAxisCount: 7,
					children: List.generate(n + f - 2, (index) {
						index += 1;
						if (index > f - 2) {
							List<dynamic> lunar = convertSolar2Lunar(index - f + 2, date.month,  date.year, 7.0);
							bool isNow = DateTime.now().day == index - f + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
							bool isHoangDao = getNgayHoangDao(index - f + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
							bool isSchedule =false;
							if(items.length>0 && items[0]['Ngay']==(index - f + 2)){
								isSchedule= true;
								items.removeAt(0);
							}
							return  Padding(
								padding: EdgeInsets.all(2),
								child: GetBuilder<CalenderController>(
									builder: (_)=> TextButton(
										onPressed: () {
											DateTime now = DateTime.now();
											DateTime selectedDate = DateTime(date.year, date.month, index - f + 2, now.hour, now.minute, now.second);
											setPick(selectedDate);
											taskListController.updateSelectedDate(selectedDate);
											taskListController.updateSelectedToDate(selectedDate);
											taskListController.getTasks();
										},
										style: TextButton.styleFrom(
											padding: EdgeInsets.zero,
											backgroundColor:(pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year ) ? Color(0xffff745c) : Get.isDarkMode ? RootColor.button_darkmode : Colors.white,
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12),
												side: BorderSide(
													color: isNow ? RootColor.cam_nhat : Colors.transparent,
													width: 2,
												)
											),
										),
										child: Stack(
											children: [
												SizedBox(
													child: Column(
														children: [
															Expanded(
																flex: 3,
																child: Center(
																	child: Text(
																		(index - f + 2).toString(),
																		style: TextStyle(fontSize: 16, color: (pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year ) ? Colors.white : Get.isDarkMode ?  Colors.white: Colors.black ),
																	),
																)),
															Expanded(
																flex: 2,
																child: Text(
																	lunar[0] == 1 ? "${lunar[0]}/${lunar[1]}" : lunar[0].toString(),
																	style: TextStyle(
																		fontSize: 12,
																		color:  isHoangDao
																			?  Colors.green
																			:  (pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year )
																			? Colors.white
																			: Color(0xff7d7f86)),
																),
															),
														],
													),
												),
												/*   vị trí có lịch trình thì có đấu   */
												isSchedule
													? Positioned(
													top: -3,
													right:-5,
													child: Icon(Icons.bookmark_outlined,color: Colors.green,size: 20,)
												):SizedBox()
												/* end vị trí có lịch trình thì có đấu */
											],
										)
									)
								)
							);
						} else {
							return TextButton(
								onPressed: () {},
								child: SizedBox(),
							);
						}
					}),
				),
			));
			pointLeft = list.first;
		}
	}

	void pagenext() async {
		list // xoa dau va them cuoi
			..removeAt(0)
			..insert(list.length, list.last + 1);
		initIndex = initIndex + 1; // tang vi tri cua page view len 1
		GlobalKey key = GlobalKey();
		listOfGlobalKeys // xoa dau va them cuoi
			..removeAt(0)
			..insert(listOfGlobalKeys.length, key); // insert 1 key voi vao cuoi
		DateTime date = DateTime(addY, addM + list.last, addD);
		var items = await _getDateEventToSetBookmark( date.month,date.year,1);
		int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
		int f = Jiffy.parse("${date.year}-${date.month}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
		if (f == 1) f = 8;
		if (list.last - 1 == pointRight) {
			pages.add(Padding(
				padding: EdgeInsets.symmetric(horizontal: 12),
				key: key,
				child: GridView.count(
					physics: NeverScrollableScrollPhysics(),
					crossAxisCount: 7,
					children: List.generate(n + f - 2, (index) {
						index += 1;
						if (index > f - 2) {
							List<dynamic> lunar = convertSolar2Lunar(index - f + 2, date.month,  date.year, 7.0);
							bool isNow = DateTime.now().day == index - f + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
							bool isHoangDao = getNgayHoangDao(index - f + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
							bool isSchedule =false;
							if(items.length>0 && items[0]['Ngay']==(index - f + 2)){
								isSchedule= true;
								items.removeAt(0);
							}
							return  Padding(
								padding: EdgeInsets.all(2),
								child: GetBuilder<CalenderController>(
									builder: (_)=> TextButton(
										onPressed: () {
											DateTime now = DateTime.now();
											DateTime selectedDate = DateTime(date.year, date.month, index - f + 2, now.hour, now.minute, now.second);
											setPick(selectedDate);
											taskListController.updateSelectedDate(selectedDate);
											taskListController.updateSelectedToDate(selectedDate);
											taskListController.getTasks();
										},
										style: TextButton.styleFrom(
											padding: EdgeInsets.zero,
											backgroundColor:(pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year ) ? Color(0xffff745c) : Get.isDarkMode ? RootColor.button_darkmode : Colors.white,
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12),
												side: BorderSide(
													color: isNow ? RootColor.cam_nhat : Colors.transparent,
													width: 2,
												)
											),
										),
										child: Stack(
											children: [
												SizedBox(
													child: Column(
														children: [
															Expanded(
																flex: 3,
																child: Center(
																	child: Text(
																		(index - f + 2).toString(),
																		style: TextStyle(fontSize: 16, color: (pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year ) ? Colors.white : Get.isDarkMode ?  Colors.white: Colors.black ),
																	),
																)),
															Expanded(
																flex: 2,
																child: Text(
																	lunar[0] == 1 ? "${lunar[0]}/${lunar[1]}" : lunar[0].toString(),
																	style: TextStyle(
																		fontSize: 12,
																		color:  isHoangDao
																			?  Colors.green
																			:  (pick.day == (index - f + 2) && pick.month == date.month && pick.year == date.year )
																			? Colors.white
																			: Color(0xff7d7f86)),
																),
															),
														],
													),
												),
												/*   vị trí có lịch trình thì có đấu   */
												isSchedule
													? Positioned(
													top: -3,
													right:-5,
													child: Icon(Icons.bookmark_outlined,color: Colors.green,size: 20,)
												):SizedBox()
												/* end vị trí có lịch trình thì có đấu */
											],
										)
									)
								)
							);
						} else {
							return TextButton(
								onPressed: () {},
								child: SizedBox(),
							);
						}
					}),
				),
			));
			pointRight = list.last;
		}
	}

	@override
	void onInit() {
		// getDateEventToSetBookmark(addM,addY);
		super.onInit();
	}

	@override
 	 void onReady() {
		controller.addListener(() {
			// lang nghe su kien\
			final index = (controller.offset / 387.4).round() > initIndex // offset = full width cua list pages
			// lay ofset chia cho width cua tung widget de xac dinh vi tri cua no trong list pages
				? (controller.offset / 387.4).round().floor() // vuot phai
				: (controller.offset / 387.4).round().ceil(); // vuot trai
			if (index == initIndex) return;
			if (index > initIndex) {
				// vi tri lon hon vi tri hien tai
				pagenext();
			} else if (index < initIndex) {
				// vi tri lon hon vi tri hien tai
				pageprev();
			}
		});
		getDateEventToSetBookmark(addM,addY);
		super.onReady();
	}
}
