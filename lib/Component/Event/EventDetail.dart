import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../pages/Home/home.dart';
import '../../utils/date_utils.dart';
import '../../utils/lunar_solar_utils.dart';

class EventDetailPage extends StatefulWidget{
	EventDetailPage();
	@override
  	State<EventDetailPage> createState() =>_EventDetail();
}

class _EventDetail extends State<EventDetailPage>{
	@override
  	Widget build(BuildContext context) {
		final  args =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
		dynamic item = args['item'];
    	return Scaffold(
			extendBodyBehindAppBar: true,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				iconTheme: IconThemeData(color: Colors.white),
			),
			body: Container(
				child: Column(
					children: [
						Image.asset('assets/Tet-nguyen-dan-2022-1.jpg'),
						Padding(
							padding:EdgeInsets.symmetric(horizontal: 16,vertical: 14),
							child: Align(
								alignment: Alignment.centerLeft,
								child: Text(item['Ten'] ,style: TextStyle(fontSize: 22),),
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
											// Navigator.push(context,
											// 	MaterialPageRoute(builder: (context)=> HomePage(DateTime(item['NamDuong'],item['ThangDuong'],item['NgayDuong'])))
											// );
										},
										child:Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												Icon(Icons.calendar_month_sharp),
												Text("Thông tin ngày")
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
										onPressed: (){},
										child:Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												Icon(Icons.more_horiz),
												Text("Mở rộng")
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
										title: (item['DuongLich']==0) ?
												Text('${item['NgayAm']}/${item['ThangAm']}, năm ${getCanChiYear(item['NamAm'])}')
											:Text('${getNameDayOfWeek(DateTime(item['NamDuong'],item['ThangDuong'],item['NgayDuong']))}, ${item['NgayDuong']}/${item['ThangDuong']}/${item['NamDuong']}'),
										subtitle: Text('${item['NgayDuong']}/${item['ThangDuong']}/${item['NamDuong']}'),
									),
									ListTile(
										leading: Icon(Icons.book_outlined),
										title: Text(item['ChiTiet']??'Chưa cập nhật')
									)
								],
							),
						)
					],
				),
			)
		);

  	}
}