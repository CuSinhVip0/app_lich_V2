import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Enum/Extentions/NgayTotXau.dart';
import '../Provider/Internet.dart';
import '../utils/lunar_solar_utils.dart';
import 'Event.dart';
import 'ReminderPage.dart';
import 'StatusPage.dart';
import 'home.dart';
class ExtensionPage extends StatefulWidget{
	ExtensionPage();
	@override
  	State<ExtensionPage> createState() {
    	return _ExtensionPage();
  	}
}

class _ExtensionPage extends State<ExtensionPage>{

	bool hide =false;
	Timer? _timer;
	DateTime _selectedDate = DateTime.now();
	List<dynamic> lunarDate =[];

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

	}
	@override
	void dispose() {
		_timer?.cancel();

		super.dispose();
	}
	@override
	Widget build(BuildContext context) {
		return Consumer<Internet>(
			builder: (context, internet, _){
				return Scaffold(
					// bottomNavigationBar: BottomNavigationBar(
					// 	currentIndex: 3,
					// 	selectedItemColor: Color(0xffff745c),
					// 	unselectedItemColor: Colors.grey,
					// 	showUnselectedLabels: false,
					// 	showSelectedLabels: false,
					// 	type: BottomNavigationBarType.fixed,
					// 	items: [
					// 		const BottomNavigationBarItem(label: "", icon: Icon(Icons.home_sharp)),
					// 		const BottomNavigationBarItem(label: "", icon: Icon(Icons.calendar_month_sharp)),
					// 		const BottomNavigationBarItem(label: "", icon: Icon(Icons.add)),
					// 		const BottomNavigationBarItem(label: "", icon: Icon(Icons.apps_sharp)),
					// 		const BottomNavigationBarItem(label: "", icon: Icon(Icons.account_circle_sharp)),
					// 	],
					// 	onTap: (index) {
					// 		Navigator.pushReplacement(
					// 			context,
					// 			PageRouteBuilder(
					// 				pageBuilder: (context, animation, secondaryAnimation) {
					// 					late Widget widget;
					// 					if (index == 0) {
					// 						widget = HomePage(DateTime.now());
					// 					}
					// 					else if (index == 1) {
					// 						widget = EventPage(0);
					// 					}
					// 					else if (index == 2) {
					// 						widget = ReminderPage();
					// 					}
					// 					else if (index ==4){
					// 						widget = StatusPage();
					// 					}
					// 					else widget= ExtensionPage();
					// 					return widget;
					// 				},
					// 			),
					// 		);
					// 	},
					// ),
					backgroundColor: Colors.transparent,
					body: SafeArea(child: Container(
						decoration: BoxDecoration(
							gradient: LinearGradient(
								colors: [
									Colors.white,
									const Color(0xff9fcdf6),
								],
								begin: Alignment.topLeft,
								end: Alignment.bottomRight,
								stops: [0.0, 1.0],
								tileMode: TileMode.clamp),
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
												elevation: 2,
												child: Padding(
													padding: EdgeInsets.symmetric(horizontal: 12),
													child: Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [
															TextButton.icon(
																style: TextButton.styleFrom(
																	padding: EdgeInsets.zero,
																	foregroundColor: Colors.white,
																	iconColor: Colors.black,
																),
																onPressed: () {
																	setState(() {
																		hide = !hide;
																	});
																},
																icon: Icon(Icons.calendar_month_sharp),
																label: Text("Lịch vạn niên", style: TextStyle(fontSize: 15, color: Colors.black),),
															),
															TextButton(onPressed: () {
																setState(() {
																	DateTime now = DateTime.now();
																	_selectedDate = DateTime(now.year, now.month,
																		now.day, now.hour, now.minute, now.second);
																});
																lunarDate = convertSolar2Lunar(_selectedDate.day, _selectedDate.month, _selectedDate.year, 7.0);
															},
																style: TextButton.styleFrom(
																	backgroundColor: Color(0xffff745c),
																	foregroundColor: Colors.transparent,
																	minimumSize: Size(80, 30),
																	padding: EdgeInsets.zero
																),
																child: Text("Hôm nay", style: TextStyle(color: Colors.white))),
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
										child:Column(
											mainAxisSize: MainAxisSize.max,
											children: [
												SizedBox(
													width: double.infinity,
													child: Column(
														children: [
															Align(
																alignment: Alignment.centerLeft,
																child: Text("Xem ngày tốt xấu",style: TextStyle(fontSize: 16),),
															),
															SizedBox(
																width: double.infinity,
																child: Card(
																	color: Colors.white,
																	child:Padding(
																		padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
																		child:GridView.builder(
																			physics: NeverScrollableScrollPhysics(),
																			itemCount: NgayTotXau.item.length,
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
																						Text( NgayTotXau.item[index].title! ),
																					]
																				),
																			),
																		),
																	)),
															)
														],
													),
												),
											],
										),
									)
								),
							],
						),
					),
					));
			});
	}
}


