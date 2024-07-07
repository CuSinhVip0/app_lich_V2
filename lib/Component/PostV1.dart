import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/Styles/Themes.dart';
import 'package:luanvan/utils/formatTimeToString.dart';

class PostV1 extends StatelessWidget{
	var payload;
	PostV1(this.payload);

	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
    	return Card(
			margin: EdgeInsets.symmetric(vertical: 8),
			surfaceTintColor: Colors.white,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(8.0),
				side: BorderSide(
					color:Get.isDarkMode ? Colors.transparent : Color(0xffd5d5d5),
					width: 1.0,
				),
			),
			elevation: 2,
			shadowColor: Colors.transparent,
			child: Column(
				children: [
					ListTile(
						leading: CircleAvatar(
							backgroundColor: Colors.white,
							radius: 20.0,
							child: CircleAvatar(
								// backgroundImage: NetworkImage(userController.userData['picture']['data']['url'],),
								backgroundImage: AssetImage('assets/Ti.jpg'),
								radius: 100.0,
							),
						),
						title: Text(payload['Id_Platform']  ?? "",style: titleStyle,),
						subtitle: Text(FormatTimeToString(DateTime.now().difference(DateFormat("yyyy-MM-dd hh:mm:ss").parse(payload['CreateAt']))),style: subTitleStyle,),
					),
					SizedBox(height: 4,),
					Padding(
						padding: EdgeInsets.symmetric(horizontal: 14),
						child: Align(
							alignment: Alignment.centerLeft,
							child: Text(payload['Title']),
						),
					),
					SizedBox(height: 4,),
					Container(
						padding: EdgeInsets.symmetric(horizontal: 14,vertical: 12),
						child: InkWell(
							onTap: (){
								// Navigator.push(context, MaterialPageRoute(builder: (c)=> FullImage));
							},
							child: Container(
								height: 300,
								decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(8.0),
									image: DecorationImage(
		// image: NetworkImage(appBanner.url), fit: BoxFit.cover)),
										image: AssetImage('assets/Tet-nguyen-dan-2022-1.jpg'), fit: BoxFit.cover,),
								),
							),
						),
					),
					Divider(
						height: 1,
						indent: 14,
						endIndent: 14,
					),
					Container(
						padding: EdgeInsets.symmetric(horizontal: 14,vertical: 8),
						child: Row(
							children: [
								Expanded(
									flex: 1,
									child:Row(
										children: [
											Icon(FontAwesomeIcons.heart,color: RootColor.cam_nhat,size: 24,),
											SizedBox(width: 4,),
											Text(payload['NumLike'].toString(),style: subTitleStyle,),
											SizedBox(width: 12,),
											Icon(FontAwesomeIcons.commentDots,color: RootColor.cam_nhat,size: 24,),
											SizedBox(width: 4,),
											Text("17",style: subTitleStyle,),
										],
									)
								),
								Expanded(
									flex: 1,
									child:Align(
										alignment: Alignment.centerRight,
										child: GestureDetector(
											onTap: (){},
											child: Icon(FontAwesomeIcons.bookmark,color: RootColor.cam_nhat,size: 24,),
										),
									)
								)
							],
						),
					)
				],
			),
		);
  	}
}