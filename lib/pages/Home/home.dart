import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:luanvan/Component/IconGiap.dart';
import 'package:luanvan/Controller/Component/SystemController.dart';
import 'package:luanvan/Controller/Home/HomeController.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/Styles/Themes.dart';
import '../../Common/Calendar.dart';
import '../../Common/NonScrollableRefreshIndicator.dart';
import '../../Component/CalendarPoster.dart';
import '../../Component/NoInternet.dart';
import '../../utils/lunar_solar_utils.dart';
import 'package:colorful_iconify_flutter/icons/noto.dart';

class HomePage extends StatefulWidget {
	HomePage();
	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	var homeController = Get.put(HomeController());
	SystemController systemController = Get.find();
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

	@override
	void initState() {
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
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
    	return Scaffold(
			backgroundColor: Colors.transparent,
			body: SafeArea(
				child: Container(
					decoration: BoxDecoration(
						image: DecorationImage(
							image: AssetImage("assets/${ getChiDay(jdn(homeController.selectedDate.day,homeController.selectedDate.month,homeController.selectedDate.year))}.png"),
							fit: BoxFit.cover,
						),
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
															icon: Iconify(Noto.spiral_calendar),
															label: Text("Perpetualcalendar".tr, style: titleStyle,),
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
																child: Text("Today".tr, style:CustomStyle(14, Colors.white, FontWeight.w400) )))
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
													init: SystemController(),
													builder: (SystemController)=>(systemController.connectionStatus.contains(ConnectivityResult.mobile)  || systemController.connectionStatus.contains( ConnectivityResult.wifi) )
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
										children: [
											Expanded(child: Text("Trực"),flex: 2,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.truc['Ten'] ??'',style: TextStyle(fontFamily: 'mulish'),),
													Text(homeController.truc['TinhChat'] ?? '',style: TextStyle(fontFamily: 'mulish'))
												],
											),flex: 7,),
										]),
									Divider(height: 2,),
									Row(
										children: [
											Expanded(child: Text("Thần",style: TextStyle(fontFamily: 'mulish')),flex: 2,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.than['Ten'] ??'',style: TextStyle(fontFamily: 'mulish')),
												],
											),flex: 7,),
										]),
									Divider(height: 2,),
									Row(
										children: [
											Expanded(child: Text("Sao",style: TextStyle(fontFamily: 'mulish')),flex: 2,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.sao['Ten'] ??'',style: TextStyle(fontFamily: 'mulish')),
												],
											),flex: 7,),
										]),
									Divider(height: 2,),
									Row(
										children: [
											Expanded(child: Text("Năm",style: TextStyle(fontFamily: 'mulish')),flex: 2,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.menhNam['Ten'] ??'',style: TextStyle(fontFamily: 'mulish')),
													Text(homeController.menhNam['Menh'] ??'',style: TextStyle(fontFamily: 'mulish')),
													Text((homeController.menhNam['NguHanh'] ??'') + ' ('+ (homeController.menhNam['NghiaNguHanh'] ?? '')+ ')',style: TextStyle(fontFamily: 'mulish')),
												],
											),flex: 7,),
										]),
									Divider(height: 2,),
									Row(
										children: [
											Expanded(child: Text("Ngày",style: TextStyle(fontFamily: 'mulish')),flex: 2,),
											Expanded(child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(homeController.menhNgay['Ten'] ??'',style: TextStyle(fontFamily: 'mulish')),
													Text(homeController.menhNgay['Menh'] ??'',style: TextStyle(fontFamily: 'mulish')),
													Text((homeController.menhNgay['NguHanh'] ??'') + ' ('+ (homeController.menhNgay['NghiaNguHanh'] ?? '')+ ')',style: TextStyle(fontFamily: 'mulish')),
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
										child: Text("TUỔI XUNG KHẮC",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'mulish'),),
									),
									SizedBox(height: 8),
									Obx(() => Row(
										mainAxisAlignment: MainAxisAlignment.spaceAround,
										children:
										homeController.xungKhac.map((i){
											return Expanded(child:  Column(
												children: [
													getIcon(CHI.indexOf(i['Ten'].split(" ")[1])+1),
													SizedBox(height: 4,),
													Text(i['Ten'],style: TextStyle(fontFamily: 'mulish')),
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
										child: Text("GIỜ HOÀNG ĐẠO",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'mulish'),),
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
											child:  Row(
												children: [
													Expanded(child: getIcon(CHI.indexOf(homeController.listGioHoangDao[index].split(" ")[0])+1),flex:1),
													Expanded(child: Column(
														mainAxisSize: MainAxisSize.max,
														mainAxisAlignment: MainAxisAlignment.center,
														children: [
															Text(homeController.listGioHoangDao[index].split(" ")[0],style: TextStyle(fontFamily: 'mulish')),
															Text(homeController.listGioHoangDao[index].split(" ")[1],style: TextStyle(fontFamily: 'mulish'))
														]
													),flex: 2,)
												],
											)
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
										child: Text("HƯỚNG XUẤT HÀNH",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'mulish'),),
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
															child:  Text('Hỷ Thần',style: TextStyle(fontFamily: 'mulish')),
														),
													),flex: 1,),
													Expanded(child: Padding(
														padding: EdgeInsets.only(left:20),
														child: Text(homeController.xuathanh['hythan']??'',style: TextStyle(fontFamily: 'mulish')),
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
															child:  Text("Tài Thần",style: TextStyle(fontFamily: 'mulish')),
														),
													),flex: 1,),
													Expanded(child: Padding(
														padding: EdgeInsets.only(left:20),
														child: Text(homeController.xuathanh['taithan']??'',style: TextStyle(fontFamily: 'mulish')),
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
															child:  Text('Hạc Thần',style: TextStyle(fontFamily: 'mulish')),
														),
													),flex: 1,),
													Expanded(child: Padding(
														padding: EdgeInsets.only(left:20),
														child: Text(homeController.xuathanh['hacthan']??'',style: TextStyle(fontFamily: 'mulish')),
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
										child: Text("CÁT TINH",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'mulish'),),
									),
									SizedBox(height: 8),
									Padding(
										padding: EdgeInsets.symmetric(horizontal: 10),
										child:Obx(()=>Wrap(
											spacing: 8,
											runSpacing: 20,
											children:homeController.catTinh.map((i){
												return GestureDetector(
													onTap: (){
														Get.bottomSheet(
															Card(
																child: 	Container(
																	padding: EdgeInsets.only(bottom: 100),
																	child: Wrap(
																		children: <Widget>[
																			ListTile(
																				leading: Icon(FluentIcons.book_search_20_regular,color: RootColor.cam_nhat,),
																				title: Text(i['Ten'],style: titleStyle,),
																			),
																			ListTile(
																				leading: Icon(FluentIcons.info_16_regular,color: RootColor.cam_nhat,),
																				title: Text(i["Mota_Chitiet"],style: subTitleStyle,),
																			),
																			ListTile(
																				leading: Icon(FluentIcons.calendar_edit_20_regular,color: RootColor.cam_nhat,),
																				title: Text(i["Mota_Le"],style: subTitleStyle,),
																			),
																		],
																	),
																),
															)
														);
													},
													child: Row(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Expanded(child: Text(i['Ten'] ?? '',style: TextStyle(fontFamily: 'mulish')),flex: 3,),
															SizedBox(width: 12,),
															Expanded(child: Text(i['Mota_TomTat'] ?? '',style: TextStyle(fontFamily: 'mulish')),flex: 7,),

														]),
												);
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
										child: Text("HUNG TINH",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'mulish'),),
									),
									SizedBox(height: 8),
									Padding(
										padding: EdgeInsets.symmetric(horizontal: 10),
											child: Obx(()=>Wrap(
												spacing: 8,
												runSpacing: 20,
												children:homeController.hungTinh.map((i){
													return GestureDetector(
														onTap: (){
															Get.bottomSheet(
																Card(
																	child: 	Container(
																		padding: EdgeInsets.only(bottom: 100),
																		child: Wrap(
																			children: <Widget>[
																				ListTile(
																					leading: Icon(FluentIcons.book_search_20_regular,color: RootColor.cam_nhat,),
																					title: Text(i['Ten'],style: titleStyle,),
																				),
																				ListTile(
																					leading: Icon(FluentIcons.info_16_regular,color: RootColor.cam_nhat,),
																					title: Text(i["Mota_Chitiet"],style: subTitleStyle,),
																				),
																				ListTile(
																					leading: Icon(FluentIcons.calendar_edit_20_regular,color: RootColor.cam_nhat,),
																					title: Text(i["Mota_Le"],style: subTitleStyle,),
																				),
																			],
																		),
																	),
																)
															);
														},
														child: Row(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Expanded(child: Text(i['Ten'] ?? '',style: TextStyle(fontFamily: 'mulish')),flex: 3,),
																SizedBox(width: 12,),
																Expanded(child: Text(i['Mota_TomTat'] ?? '',style: TextStyle(fontFamily: 'Mulish')),flex: 7,),
															])
													);
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
