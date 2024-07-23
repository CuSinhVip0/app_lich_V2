import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:luanvan/Controller/LoginController.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
import 'dart:ui' as ui;
import '../Auth.dart';
import '../Common/Input/Input.dart';
import '../Styles/Colors.dart';
import '../Styles/Themes.dart';

class LoginPage extends StatelessWidget {
	LoginController loginController = Get.put(LoginController());
	UserController userController = Get.find();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			extendBodyBehindAppBar: true,
			appBar: AppBar(
				flexibleSpace: ClipRect(
					child: BackdropFilter(
						filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
						child: Container(
							color: Colors.transparent,
						),
					),
				),
				iconTheme: IconThemeData(
					color: Colors.white, //change your color here
				),
				centerTitle: true,
				title: Text("signin".tr ,style: AppBarTitleStyle(Colors.white),),
				backgroundColor: Colors.transparent, // <-- this
				shadowColor: Colors.transparent, // <-- and this
				elevation: 0,
			),
			body:  Container(
				decoration: BoxDecoration(
					image: DecorationImage(
						image: AssetImage("assets/backgroundLoginPage.jpg"),
						fit: BoxFit.cover,
					),
				),
				height: double.infinity,
				width: double.infinity,
				padding: EdgeInsets.all(20),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.center,
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Column(
							children: [
								Padding(padding: EdgeInsets.symmetric(horizontal: 20),
									child: Column(
										children: [
											Text("Logintoyouraccounttojoinustohelpyou".tr,style: CustomStyle(16,Colors.white,FontWeight.w400),),
											Text("Storeandsynchronizeeventsanddataontheapponalldevices".tr,style: CustomStyle(15,Colors.white,FontWeight.w400))
										],
									),
								),
								SizedBox(height: 50,),
								GestureDetector(
									onTap: () async{
										bool res = await userController.loginFaceBook();
										if(res) {
											await userController.insertInforToDatabase(userController.userData['id'], 'FB',userController.userData['name'],userController.userData['picture']['data']['url'],userController.userData['email']);
											Get.back();
										}
										else Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
									},
									child: Card(
										child: Container(
											width: 300,
											decoration: BoxDecoration(
												borderRadius: BorderRadius.circular(32),
											),
											child:ListTile(
												titleAlignment: ListTileTitleAlignment.center,
												leading: SvgPicture.asset('assets/icons-facebook.svg'),
												title: Center(
													child: Text("SigninwithFacebook".tr, style: CustomStyle(16, Colors.black, FontWeight.w400 ),),
												)
											),
										),
									)
								),
								SizedBox(height: 20,),
								GestureDetector(
									onTap: () async{
										var res = await userController.signInWithGoogle();
										if(res) {
											await userController.insertInforToDatabase(userController.userData['id'], 'GG',userController.userData['name'],userController.userData['picture']['data']['url'],userController.userData['email']);
											Get.back();
										}
										else Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
									},
									child: Card(
										child: Container(
											width: 300,
											decoration: BoxDecoration(
												borderRadius: BorderRadius.circular(32),
											),
											child:ListTile(
												titleAlignment: ListTileTitleAlignment.center,
												leading: SvgPicture.asset('assets/icons-google.svg'),
												title: Center(
													child: Text("SigninwithGoogle".tr, style: CustomStyle(16, Colors.black, FontWeight.w400 ),),
												),
											),
										),
									),
								),
								SizedBox(height: 50,),
								Center(
									child: Text("WhenyouusethePerpetualCalendar,youagreetoourpoliciesandterms".tr, style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,fontFamily: "Mulish",color: Colors.white,),textAlign: TextAlign.center,),
								)
							],
						)
					],
				),
			),
		);
	}

}

// Input(hint: "Tài khoản của bạn", textEditingController: _username,size: 16,txtColor: Colors.white,hintColor: Colors.grey[400],txtWeight: FontWeight.w400,),
// SizedBox(height: 12,),
// Obx(()=>Container(
// 		child: Column(
// 			crossAxisAlignment: CrossAxisAlignment.start,
// 			children: [
// 				Container(
// 					height: 52,
// 					padding:EdgeInsets.only(left: 12),
// 					decoration: BoxDecoration(
// 						border: Border.all(
// 							color: Colors.grey,
// 							width: 1
// 						),
// 						borderRadius: BorderRadius.circular(12)
// 					),
// 					child:
// 						TextFormField(
// 								autofocus: false,
// 								controller: _password,
// 								cursorColor: Colors.grey[400],
// 								style:CustomStyle(16,Colors.white, FontWeight.w400) ,
// 								decoration: InputDecoration(
// 									hintText: "Mật khẩu",
// 									hintStyle:CustomStyle(16, Colors.grey[400]!, FontWeight.w400) ,
// 									focusedBorder: UnderlineInputBorder(
// 										borderSide: BorderSide(
// 											color:Colors.white,
// 											width: 0
// 										)
// 									),
// 									enabledBorder: UnderlineInputBorder(
// 										borderSide: BorderSide(
// 											color:Colors.white,
// 											width: 0
// 										)
// 									),
// 									disabledBorder: UnderlineInputBorder(
// 										borderSide: BorderSide(
// 											color:Colors.white,
// 											width: 0
// 										)
// 									),
// 									suffixIcon: IconButton(
// 										icon: Icon(
// 											!loginController.showPass.value
// 												? Icons.visibility
// 												: Icons.visibility_off,
// 											color: Theme.of(context).primaryColorDark,
// 										),
// 										onPressed: () {
// 											loginController.showPass.value = !loginController.showPass.value;
// 										},
// 									),),
// 								obscureText: loginController.showPass.value == true
// 							),
// 				),
// 			],
// 		),
// 	)	),