import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:luanvan/Controller/HomeController.dart';
import 'package:luanvan/Styles/Themes.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Common/Calendar.dart';
import '../Common/NonScrollableRefreshIndicator.dart';
import '../Component/CalendarPoster.dart';
import '../Component/NoInternet.dart';
import '../Provider/Internet.dart';
import '../utils/lunar_solar_utils.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
	HomePage();
	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	var homeController = Get.put(HomeController());
	final Connectivity _connectivity = Connectivity();
	late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
	Timer? _timer;
	bool hide =false;
	void handle(DateTime selectedDate){
		  	homeController.updateSelectedDate(selectedDate);
			homeController.lunarDate = convertSolar2Lunar(selectedDate.day,selectedDate.month,selectedDate.year,7.0);
			homeController.getData();
		handleShow();
	}
	void handleShow(){
		setState(() {
			hide =false;
		});
	}

	Future<void> initConnectivity() async {
		late List<ConnectivityResult> result;
		try {
			result = await _connectivity.checkConnectivity();
		} on PlatformException catch (e) {
			developer.log('Couldn\'t check connectivity status', error: e);
			return;
		}
		if (!mounted) {
			return Future.value(null);
		}
		return _updateConnectionStatus(result);
	}
	Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
			homeController.updateConnectionStatus(result);
			Provider.of<Internet>(context, listen: false).setHasInternet(result);
		print('Connectivity changed: ${homeController.connectionStatus}');
	}

	@override
	void initState() {
		initConnectivity();
		_connectivitySubscription =
			_connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
		_timer = Timer.periodic(
			const Duration(seconds: 1),
				(Timer timer) => setState(() {
				DateTime now = DateTime.now();
				homeController.updateSelectedDate(DateTime(homeController.selectedDate.year, homeController.selectedDate.month,
					homeController.selectedDate.day, now.hour, now.minute, now.second));
			}));
	}

	@override
	void dispose() {
		_timer?.cancel();
		_connectivitySubscription?.cancel();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
    	return Consumer<Internet>(
			builder: (context, internet, _){
			return Scaffold(
				backgroundColor: Colors.transparent,
				body: SafeArea(
					child: Container(
						decoration: BoxDecoration(
							image: DecorationImage(
								image: AssetImage("assets/${ getChiDay(jdn(homeController.selectedDate.day,homeController.selectedDate.month,homeController.selectedDate.year))}.png"),
								fit: BoxFit.cover,
							),
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
												elevation:6,
												child: Padding(
													padding: EdgeInsets.symmetric(horizontal: 12),
													child: Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [
															TextButton.icon(
																style: TextButton.styleFrom(
																	padding: EdgeInsets.zero,
																	foregroundColor: Colors.white,
																	iconColor:Get.isDarkMode? Colors.white: Colors.black,
																),
																onPressed: () {
																	setState(() {
																		hide = !hide;
																	});
																},
																icon: Icon(Icons.calendar_month_sharp),
																label: Text("Lịch vạn niên", style: titleStyle,),
															),
															GetBuilder(
																init: HomeController(),
																builder: (homeController)=>TextButton(onPressed: () {
																	DateTime now = DateTime.now();
																	homeController.updateSelectedDate(DateTime(now.year, now.month,now.day, now.hour, now.minute, now.second));
																	homeController.lunarDate = convertSolar2Lunar(homeController.selectedDate.day, homeController.selectedDate.month, homeController.selectedDate.year, 7.0);
																},
																	style: TextButton.styleFrom(
																		backgroundColor: Color(0xffff745c),
																		foregroundColor: Colors.transparent,
																		minimumSize: Size(80, 30),
																		padding: EdgeInsets.zero
																	),
																	child: Text("Hôm nay", style: TextStyle(color: Colors.white))))
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
									child: Padding(
										padding: EdgeInsets.symmetric(horizontal: 12),
										child: NonScrollableRefreshIndicator(
											onRefresh: () async{
												homeController.getData();
											},
											child:Column(
													mainAxisSize: MainAxisSize.max,
													children: [
												GetBuilder(
													init: HomeController(),
													builder: (homeController)=>GestureDetector(
															onHorizontalDragEnd: (DragEndDetails details) {
																if (details.primaryVelocity! > 0) {
																	homeController.updateSelectedDate(homeController.selectedDate.subtract(Duration(days: 1)));
																	homeController.lunarDate = convertSolar2Lunar(homeController.selectedDate.day, homeController.selectedDate.month, homeController.selectedDate.year, 7.0);
																}
																else if (details.primaryVelocity! < 0) {
																	homeController.updateSelectedDate(homeController.selectedDate.add(Duration(days: 1)));
																	homeController.lunarDate = convertSolar2Lunar(homeController.selectedDate.day, homeController.selectedDate.month, homeController.selectedDate.year, 7.0);
																}
																homeController.getData();
															},
															child: CalendarPoster(homeController.selectedDate, homeController.lunarDate)
														)),
														// xu ly phần kết nối mạng
														GetBuilder(
															init: HomeController(),
															builder: (homeController)=>(internet.getHasInternet.contains(ConnectivityResult.mobile)  || internet.getHasInternet.contains( ConnectivityResult.wifi) )
																?DataAPI():NoInternet(),
														)
													],
												),
										)
									),),
//calendar trên thanh header
								Positioned(
									top: 62,
									left: 0,
									right: 0,
									bottom: 0,
									child:GetBuilder(
										init: HomeController(),
										builder: (homeController)=> Visibility(
											visible: hide,
											maintainAnimation: true,
											maintainState: true,
											child: AnimatedOpacity(
												duration: const Duration(milliseconds: 100),
												curve: Curves.linear,
												opacity: hide ? 1 : 0,
												child:Column(
													children: [
														Calendar(handle,homeController.selectedDate),
														Expanded(flex: 6, child: GestureDetector(
															onTap: () {
																handleShow();
															},
														))
													])
											),
									))
								)
							],
						),
					),
				)
			);
		});
  	}

	Widget DataAPI(){
		return homeController.loading.value ? Loading(): Column(
			children: [
//cpn infor
				SizedBox(
					child: Card(
						elevation: 6,
						surfaceTintColor:Colors.white,
						child:Padding(
							padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
							child:Wrap(
								spacing: 8,
								runSpacing: 8,
								children:[
									Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Expanded(child: Text("Trực"),flex: 3,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.truc['Ten'] ??''),
													Text(homeController.truc['TinhChat'] ?? '')
												],
											),flex: 7,),
										]),
									Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Expanded(child: Text("Thần"),flex: 3,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.than['Ten'] ??''),
												],
											),flex: 7,),
										]),
									Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Expanded(child: Text("Sao"),flex: 3,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.sao['Ten'] ??''),
												],
											),flex: 7,),
										]),
									Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Expanded(child: Text("Năm"),flex: 3,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.menhNam['Ten'] ??''),
													Text(homeController.menhNam['Menh'] ??''),
													Text((homeController.menhNam['NguHanh'] ??'') + ' ('+ (homeController.menhNam['NghiaNguHanh'] ?? '')+ ')'),
												],
											),flex: 7,),
										]),
									Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Expanded(child: Text("Ngày"),flex: 3,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.menhNgay['Ten'] ??''),
													Text(homeController.menhNgay['Menh'] ??''),
													Text((homeController.menhNgay['NguHanh'] ??'') + ' ('+ (homeController.menhNgay['NghiaNguHanh'] ?? '')+ ')'),
												],
											),flex: 7,),
										]),
								]
							),
						),
					),
				),
//cpn xung khắc
				SizedBox(
					child: Card(
						surfaceTintColor:Colors.white,
						elevation: 6,
						child:Padding(
							padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
							child: Column(
								children: [
									Align(
										alignment: Alignment.centerLeft,
										child: Text("TUỔI XUNG KHẮC",style: TextStyle(fontWeight: FontWeight.bold),),
									),
									SizedBox(height: 8),
									Obx(() => Row(
										mainAxisAlignment: MainAxisAlignment.spaceAround,
										children:
										homeController.xungKhac.map((i){
											return Expanded(child:  Column(
												children: [
													Text(i['Ten']),
												]));
										}).toList()
									),)
								],
							)
						),
					)
				),
//cpn giờ hoàng đạo
				SizedBox(
					child: Card(
						surfaceTintColor:Colors.white,
						elevation: 6,
						child:Padding(
							padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
							child: Column(
								children: [
									Align(
										alignment: Alignment.centerLeft,
										child: Text("GIỜ HOÀNG ĐẠO",style: TextStyle(fontWeight: FontWeight.bold),),
									),
									SizedBox(height: 8),
									GridView.builder(
										physics: NeverScrollableScrollPhysics(),
										itemCount: homeController.listGioHoangDao.length,
										shrinkWrap: true,
										gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
											crossAxisCount: 2,
											childAspectRatio: 4,
											mainAxisSpacing: 8,
										),
										itemBuilder: (context, index) => Container(
											child:  Column(
												mainAxisSize: MainAxisSize.max,
												mainAxisAlignment: MainAxisAlignment.center,
												children: [
													Text(homeController.listGioHoangDao[index].split(" ")[0]),
													Text(homeController.listGioHoangDao[index].split(" ")[1])
												]
											),
										),
									),
								],
							))
					),
				),
//cpn hưỡng xuất hành
				SizedBox(
					child: Card(
						surfaceTintColor:Colors.white,
						elevation: 6,
						child: Padding(
							padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
							child: Column(
								children: [
									Align(
										alignment: Alignment.centerLeft,
										child: Text("HƯỚNG XUẤT HÀNH",style: TextStyle(fontWeight: FontWeight.bold),),
									),
									SizedBox(height: 8),
									Column(
										children: [
											Row(
												children: [
													Expanded(child:Align(
														alignment: Alignment.centerRight,
														child: Padding(
															padding: EdgeInsets.only(right: 20),
															child:  Text('Hỷ Thần'),
														),
													),flex: 1,),
													Expanded(child: Padding(
														padding: EdgeInsets.only(left:20),
														child: Text(homeController.xuathanh['hythan']??''),
													),flex: 1,),
												],
											)
										]
									),
									SizedBox(height: 4),
									Column(
										children: [
											Row(
												children: [
													Expanded(child:Align(
														alignment: Alignment.centerRight,
														child: Padding(
															padding: EdgeInsets.only(right: 20),
															child:  Text("Tài Thần"),
														),
													),flex: 1,),
													Expanded(child: Padding(
														padding: EdgeInsets.only(left:20),
														child: Text(homeController.xuathanh['taithan']??''),
													),flex: 1,),
												],
											)
										]
									),
									SizedBox(height: 4),
									Column(
										children: [
											Row(
												children: [
													Expanded(child:Align(
														alignment: Alignment.centerRight,
														child: Padding(
															padding: EdgeInsets.only(right: 20),
															child:  Text('Hạc Thần'),
														),
													),flex: 1,),
													Expanded(child: Padding(
														padding: EdgeInsets.only(left:20),
														child: Text(homeController.xuathanh['hacthan']??''),
													),flex: 1,),
												],
											)
										]
									),
								],
							),
						),
					),
				),
//cpn cát tinh
				SizedBox(
					child: Card(
						surfaceTintColor:Colors.white,
						elevation: 6,
						child:Padding(
							padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
							child: Column(
								children: [
									Align(
										alignment: Alignment.centerLeft,
										child: Text("CÁT TINH",style: TextStyle(fontWeight: FontWeight.bold),),
									),
									SizedBox(height: 8),
									Padding(
										padding: EdgeInsets.symmetric(horizontal: 10),
										child:Obx(()=>Wrap(
											spacing: 8,
											runSpacing: 8,
											children:homeController.catTinh.map((i){
												return Row(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Expanded(child: Text(i['Ten'] ?? ''),flex: 3,),
														Expanded(child: Text(i['Mota_TomTat'] ?? ''),flex: 7,),

													]);
											}).toList()
										),)
									),
								],
							))
					)
				),
//cpn hung tinh
				SizedBox(
					child: Card(
						surfaceTintColor:Colors.white,
						elevation: 6,
						child:Padding(
							padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
							child: Column(
								children: [
									Align(
										alignment: Alignment.centerLeft,
										child: Text("HUNG TINH",style: TextStyle(fontWeight: FontWeight.bold),),
									),
									SizedBox(height: 8),
									Padding(
										padding: EdgeInsets.symmetric(horizontal: 10),
											child: Obx(()=>Wrap(
												spacing: 8,
												runSpacing: 8,
												children:homeController.hungTinh.map((i){
													return Row(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Expanded(child: Text(i['Ten'] ?? ''),flex: 3,),
															Expanded(child: Text(i['Mota_TomTat'] ?? ''),flex: 7,),

														]);
												}).toList()
											),)
									)
								],
							))
					)
				)
			],
		);
	}
	Widget Loading(){
		return CircularProgressIndicator(
			valueColor:AlwaysStoppedAnimation(Color(0xffff745c))
		);
	}
}
