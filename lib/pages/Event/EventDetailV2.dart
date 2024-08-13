import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luanvan/Controller/Component/SystemController.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import 'package:luanvan/Controller/Home/HomeController.dart';
import 'package:luanvan/Styles/Themes.dart';
import 'package:luanvan/pages/NavigatorPage.dart';
import '../../Controller/Navigator.dart';
import '../../Controller/Task.dart';
import '../../Styles/Colors.dart';
import '../Home/home.dart';
import '../../utils/date_utils.dart';
import '../../utils/lunar_solar_utils.dart';
import '../LoginPage.dart';
import '../Reminder/CreateTask.dart';

class EventDetailPageV2 extends StatelessWidget{
	UserController userController = Get.find();
	HomeController homeController = Get.find();
	NavigatorController navigatorController = Get.find();
	DateTime date;
	TaskController taskController = Get.find();

	EventDetailPageV2(this.date);
	var remind = ['Không',"1 phút","5 phút","10 phút","30 phút", "1 tiếng", "1 ngày"];
	Future<bool> precacheImages(BuildContext context, String? imageUrls) async {
		if (taskController.task['UrlPic'] == null) return true;
		await precacheImage(NetworkImage(imageUrls!), context);
		return true;
	}
	@override
  	Widget build(BuildContext context) {
    	return FutureBuilder(
			future: precacheImages(context, taskController.task['UrlPic']),
			builder: (context, snapshot) {
			if (snapshot.connectionState == ConnectionState.done) {
				return Scaffold(
					extendBodyBehindAppBar: true,
					appBar: AppBar(
						backgroundColor: Colors.transparent,
						iconTheme: IconThemeData(color: Colors.white),
					),
					body:
					SingleChildScrollView(
						physics: BouncingScrollPhysics(),
						child: Container(
							child: Column(
								children: [
									/*   title   */
									Stack(
										children: [
											Container(
												height: 300,
												child: taskController.task['UrlPic'] !=null
													?Image.network(taskController.task['UrlPic'],width: double.infinity, fit: BoxFit.cover,)
													:Image.asset(taskController.task['Id']==1?'assets/ngay-le.jpg':taskController.task['Id']==2?'assets/cong-viec.jpg':'assets/sinh-nhat.jpg',width: double.infinity, fit: BoxFit.cover,),
											),
											Positioned(
												bottom: 8,
												left: 12,
												child: Container(
													decoration:  BoxDecoration(
														shape: BoxShape.rectangle,
														color: Colors.black,
														borderRadius: BorderRadius.circular(12)
													),
													padding: EdgeInsets.symmetric(vertical: 4, horizontal: 14),
													child: Text(taskController.task['Name'], style:subTitleStyle),
												))
										],
									),
									Padding(
										padding:EdgeInsets.symmetric(horizontal: 16,vertical: 14),
										child: Align(
											alignment: Alignment.centerLeft,
											child: Text(taskController.task['Ten'] ,style: TextStyle(fontSize: 22,fontFamily: 'mulish',fontWeight: FontWeight.w600),),
										),
									),
									Container(
										height: 80,
										child: Row(
											children: [
												Expanded(flex: 1,child: ElevatedButton(
													style: ElevatedButton.styleFrom(
														padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
														shape: BeveledRectangleBorder(),
														foregroundColor: Colors.black,
														textStyle: TextStyle(fontWeight: FontWeight.normal)
													),
													onPressed: (){
														homeController.updateSelectedDate(date);
														homeController.updateLunarDate(convertSolar2Lunar(date.day, date.month, date.year,7));
														navigatorController.currentIndex.value = 0;
														Get.off(()=>NavigatorPage());
													},
													child:Column(
														mainAxisAlignment: MainAxisAlignment.center,
														children: [
															Icon(FluentIcons.book_information_24_regular),
															Text("DateInformation".tr,style: subTitleStyle,)
														]
													)
												)),
												Expanded(flex: 1,child: ElevatedButton(
													style: ElevatedButton.styleFrom(
														padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
														shape: BeveledRectangleBorder(),
														foregroundColor: Colors.black,
														textStyle: TextStyle(fontWeight: FontWeight.normal)
													),
													onPressed: () async{
														if(userController.isLogin.value){
															Get.to(()=>CreateTaskPage());
														}else {
															try{
																var data = await Get.to(()=>LoginPage());
																if(data == true) Get.to(()=>CreateTaskPage(payload: {
																	"date":[date.year.toString(), date.month.toString(), date.day.toString()]
																},));
															}catch(e){}
														}
													},
													child:Column(
														mainAxisAlignment: MainAxisAlignment.center,
														children: [
															Icon(FluentIcons.notepad_edit_20_regular),
															Text("Createevent".tr,style: subTitleStyle,)
														]
													)
												))
											],
										),
									),
									Container(
										child: Column(
											children: [
												ListTile(
													leading: Icon(Icons.timer_sharp),
													title: (taskController.task['DuongLich']==0) ?
													Text('${taskController.task['Ngay']}/${taskController.task['Thang']}, ${userController.setting["Language"]=="Vie"?"năm ":""}${getCanChiYear(convertSolar2Lunar(date.day,date.month, date.year, 7)[2])}${userController.setting["Language"]=="Eng"?" year":""}',style: titleStyle,)
														:Text(DateFormat.yMMMMEEEEd(userController.setting["Language"]=="Vie"?'vi':"en").format((DateTime(DateTime.now().year,taskController.task['Thang'],taskController.task['Ngay']))),style: titleStyle,),
													subtitle: (taskController.task['DuongLich']==0) ? Text(DateFormat.yMMMMd(userController.setting["Language"]=="Vie"?'vi':"en").format(date),style: subTitleStyle,) : null,
												),
												ListTile(
													leading: Icon(Icons.book_outlined),
													titleAlignment:  taskController.task['ChiTiet']!=null ? ListTileTitleAlignment.top:ListTileTitleAlignment.center,
													title: Text(taskController.task['ChiTiet']??'Longtimenoupdate'.tr,style: titleStyle,)
												)
											],
										),
									)
								],
							),
						),
					)
				);
			} else {
				return Scaffold(
					body: Center(child: LoadingAnimationWidget.dotsTriangle(color: RootColor.cam_nhat, size:60),),
				);
			}
		},
		);

  	}
}

