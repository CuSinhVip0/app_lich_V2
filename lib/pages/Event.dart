
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:luanvan/Styles/Themes.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../Component/Event/ListEvent.dart';
import '../Enum/Data.dart';
import '../Provider/Date.dart';
import '../utils/date_utils.dart';
import '../utils/lunar_solar_utils.dart';
import 'package:http/http.dart' as http;

import 'Extension.dart';
import 'ReminderPage.dart';
import 'StatusPage.dart';
import 'Home/home.dart';

class EventPage extends StatefulWidget
{
	int index;
	EventPage(this.index);
	@override
	State<EventPage> createState()
	=> _EventPageState();
}

class _EventPageState extends State<EventPage>
{
	int yearPrev =DateTime.now().year;
	int yearNext=DateTime.now().year;
	bool hide =false;
	bool loading = false;
	Timer? _timer;
	DateTime _selectedDate = DateTime.now();
	List<dynamic> lunarDate =[];

	ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
	ItemScrollController itemScrollController  = ItemScrollController();
	List<dynamic> mainItems = [];
	List<GlobalKey> mainKeys = [];
	List<dynamic> subItems = [];

	bool show = false;
	//copy
	int currentindex = 0;
	List<dynamic> copyMainItems = [];
	List<GlobalKey> copyMainKeys = [];
	@override
	void initState() {
		_timer = Timer.periodic(
			const Duration(seconds: 1),
				(Timer timer) => setState(() {
				DateTime now = DateTime.now();
				_selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
					_selectedDate.day, now.hour, now.minute, now.second);

			}));
		/* End Real Time */
		lunarDate = convertSolar2Lunar(_selectedDate.day,_selectedDate.month,_selectedDate.year,7);
		yearPrev = _selectedDate.year-1;
		yearNext = _selectedDate.year+1;
		getEvents();
		subItems = List<dynamic>.from(mainItems);
	}
	Future<dynamic> _getEvents ()async {
		final res = await http.post(Uri.parse(ServiceApi.api+'/event/getEvents'),
			headers: {"Content-Type": "application/json"},
			body: jsonEncode({
				"nam":_selectedDate.year,
			}));
		dynamic result = jsonDecode(res.body);
		return result;
	}

	void getEvents ()async{
		final list = await _getEvents();
		for (var i = 0; i < list['data'].length; i++) {
			mainItems.add(list['data'][i]);
			mainKeys.add(GlobalKey());
			copyMainItems.add(list['data'][i]);
			copyMainKeys.add(GlobalKey());
		}
		Future.delayed(const Duration(seconds: 1)).then((value) {
			setState(() {});
			WidgetsBinding.instance.addPostFrameCallback((_) {
				WidgetsBinding.instance.addPostFrameCallback((_) {
					itemScrollController?.jumpTo(index: list['index'] as int??0);
					Future.microtask(() {
						setState(() {
							show =true;
							currentindex = list['index'] as int;
							Provider.of<DateToday>(context, listen: false).listEvent = mainItems;
						});
					});
				});
			});
		});

	}

	@override
	void dispose() {
		_timer?.cancel();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Consumer<DateToday>(
			builder: (context, datetoday, _){
				return Scaffold(
					backgroundColor: Colors.transparent,
					body: Container(
						padding: EdgeInsets.only(top: 16),
						decoration: BoxDecoration(
							// gradient: LinearGradient(
							// 	colors: [
							// 		Colors.white,
							// 		const Color(0xff9fcdf6),
							// 	],
							// 	begin: Alignment.topLeft,
							// 	end: Alignment.bottomRight,
							// 	stops: [0.0, 1.0],
							// 	tileMode: TileMode.clamp),
						),
						child: Stack(
							clipBehavior: Clip.none,
							children: [
//header
								Positioned(
									top: 0,
									left: 0,
									right: 0,
									child: Padding(
										padding: EdgeInsets.all(12),
										child: SizedBox(
											width: MediaQuery
												.of(context)
												.size
												.width,
											height: 50,
											child: Card(
												surfaceTintColor: Colors.white,
												elevation: 6,
												child: Padding(
													padding: EdgeInsets.symmetric(horizontal: 12),
													child: Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [
															Expanded(child: ValueListenableBuilder<Iterable<ItemPosition>>(
																valueListenable: itemPositionsListener.itemPositions,
																builder: (context, positions, child) {
																	int? monthSolar;
																	int? monthLunar;
																	int? yearSolar;
																	int? yearLunar;
																	int? positionItemTop;
																	dynamic? itemTop;
																	if (positions.isNotEmpty) {
																		//lấy thông tin của item vị trí phía trên cùng màn hình
																		positionItemTop = positions.where((ItemPosition position) => position.itemTrailingEdge > 0)
																							.reduce((ItemPosition min, ItemPosition position) =>
																						position.itemTrailingEdge < min.itemTrailingEdge
																							? position
																							: min)
																							.index;
																		itemTop = mainItems[positionItemTop];
																		//set thông tin
																		monthLunar= itemTop['ThangAm'];
																		yearLunar= itemTop['NamAm'];
																		monthSolar = itemTop['ThangDuong'];
																		yearSolar= itemTop['NamDuong'];
																	}
																	return Row(
																		crossAxisAlignment: CrossAxisAlignment.center,
																		mainAxisAlignment: MainAxisAlignment.start,
																		children: [
																			Text( show ? 'Tháng ${monthSolar ?? ''} ${yearSolar??''}' :"",style:CustomStyle(14, Colors.black, FontWeight.w400),),
																			SizedBox(width: 4),
																			Text(show ? '(${getNameMonthLunarOfYear(monthLunar!)} ${yearLunar??''} AL)':"",style:CustomStyle(12, Colors.black, FontWeight.w400)),
																		],
																	);
																},
															),),
															// set lai mảng copy
															TextButton(onPressed: () {
																	setState(() {
																		mainItems = copyMainItems;
																		mainKeys = copyMainKeys;
																		yearPrev = DateTime.now().year;
																		yearNext = DateTime.now().year;
																		subItems = List<dynamic>.from(copyMainItems);
																	});

																	//sau khi render xong thi nhay ve vi tri ban dau
																	WidgetsBinding.instance.addPostFrameCallback((_) {
																		WidgetsBinding.instance.addPostFrameCallback((_) {
																			itemScrollController.jumpTo(index: currentindex);
																		});
																	});
																},
																	style: TextButton.styleFrom(
																		backgroundColor: Color(0xffff745c),
																		foregroundColor: Colors.transparent,
																		minimumSize: Size(80, 30),
																		padding: EdgeInsets.zero
																	),
																	child: Text("Hôm nay", style: TextStyle(color: Colors.white)))
														],
													),
												),
											)
										),
									),
								),
//main
								Positioned(
									top: 75,
									left: 0,
									right: 0,
									bottom: 0,
									child: ListEvent(
										itemScrollController:itemScrollController,
										mainItems: mainItems,
										mainKeys:mainKeys,
										show: show,
										subItems:subItems,
										itemPositionsListener:itemPositionsListener,
										yearPrev:yearPrev!,
										yearNext:yearNext!,
										subYear:(){
											setState(() {
												yearPrev--;
											});
										},
										addYear:(){
											setState(() {
												yearNext--;
											});
										}
									)
								)
							],
						),
					),);
			});
	}
}


