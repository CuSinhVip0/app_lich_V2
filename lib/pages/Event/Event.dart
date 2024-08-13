
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luanvan/Styles/Themes.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../Component/Event/ListEvent.dart';
import '../../Component/NoInternet.dart';
import '../../Controller/Component/SystemController.dart';
import '../../Enum/Data.dart';
import '../../Styles/Colors.dart';
import '../../utils/date_utils.dart';
import '../../utils/lunar_solar_utils.dart';
import 'package:http/http.dart' as http;

class EventPage extends StatefulWidget
{
	EventPage();
	@override
	State<EventPage> createState()
	=> _EventPageState();
}

class _EventPageState extends State<EventPage>
{
	SystemController systemController = Get.find();
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
		getEvents();
		subItems = List<dynamic>.from(mainItems);
	}
	Future<dynamic> _getEvents ()async {
		final res = await http.post(Uri.parse(ServiceApi.api+'/event/LV_getEvents'),
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
			WidgetsBinding.instance.addPostFrameCallback((_) {
				WidgetsBinding.instance.addPostFrameCallback((_) {
					if(itemScrollController! !=null )  itemScrollController.jumpTo(index: mainItems.indexWhere((element) => element["IsToday"]));
					Future.microtask(() {
						setState(() {
							show =true;
							currentindex = list['index'] as int;
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
		return Scaffold(
			backgroundColor: Colors.transparent,
			body: Container(
				padding: EdgeInsets.only(top: 16),
				child: GetBuilder(
					init: SystemController(),
					builder: (SystemController)=>(systemController.connectionStatus.contains(ConnectivityResult.mobile)  || systemController.connectionStatus.contains( ConnectivityResult.wifi) )
						?mainItems.length>0?  Stack(
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
																	try{
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
																	catch(e){
																		print(e);
																	}
																}
																return Row(
																	crossAxisAlignment: CrossAxisAlignment.center,
																	mainAxisAlignment: MainAxisAlignment.start,
																	children: [
																		Text( show ? 'Tháng ${monthSolar ?? ''} ${yearSolar??''}' :"",style:CustomStyle(14, Colors.black, FontWeight.w400),),
																		SizedBox(width: 4),
																		Text(show ? '(${getNameMonthLunarOfYear(monthLunar !=null ? monthLunar!: DateTime.now().year)} ${yearLunar??''} AL)':"",style:CustomStyle(12, Colors.black, FontWeight.w400)),
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
																	itemScrollController.jumpTo(index: mainItems.indexWhere((element) => element["IsToday"]));
																});
															});
														},
															style: TextButton.styleFrom(
																backgroundColor: Color(0xffff745c),
																foregroundColor: Colors.transparent,
																minimumSize: Size(80, 30),
																padding: EdgeInsets.zero
															),
															child: Text("Today".tr, style: TextStyle(color: Colors.white)))
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
								child:  ListEvent(
									itemScrollController:itemScrollController,
									mainItems: mainItems,
									mainKeys:mainKeys,
									show: show,
									subItems:subItems,
									itemPositionsListener:itemPositionsListener,
									yearPrev2:yearPrev!,
									yearNext2:yearNext!,
									subYear:(){
										setState(() {
											yearPrev= yearPrev - 1;
											print("yearPrev $yearPrev");
										});
									},
									addYear:(){
										setState(() {
											yearNext = yearNext + 1 ;
											print("yearNext $yearNext");
										});
									}
								)


							)
						],
					): Center(
						child: Container(
							width: 100,
							height: 100,
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(8)
							),
							child: Center(
								child: LoadingAnimationWidget.dotsTriangle(color: RootColor.cam_nhat, size:60),
							),
						),
					) :
					Center(
						child: NoInternet((){
							getEvents();
							subItems = List<dynamic>.from(mainItems);
						}),
					),)
			),);
	}
}