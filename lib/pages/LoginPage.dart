import 'dart:ui';
import 'package:colorful_iconify_flutter/icons/emojione.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:luanvan/Controller/LoginController.dart';
import 'package:luanvan/Controller/Component/UserController.dart';
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
			body:  Obx(
				()=>Stack(
					children: [
						Container(
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
													if(!res) {
														Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
													}
													else{
														var result = await loginController.LV_spGetInforFromDatabase('FB');
														if(result==0){
															Navigator.of(context).pop(true);
														}
														Future.delayed(Duration(seconds: 3)).then((value) async{
															if(result==1) {
																loginController.showSyncDialog.value = true;
																loginController.success.value = 0;
																Future.delayed(Duration(seconds: 2)).then((value) =>Navigator.of(context).pop(true));
															}
															else {
																loginController.showSyncDialog.value = true;
																loginController.success.value = 2;
																Future.delayed(Duration(seconds: 2)).then((value) =>Navigator.of(context).pop(true));
															};
														});
													}
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
													if(!res) {
														Get.snackbar("Loginerror".tr, 'Pleasetryagain'.tr,snackPosition: SnackPosition.BOTTOM);
													}
													else{
														var result = await loginController.LV_spGetInforFromDatabase('GG');
														if(result==0){
															Navigator.of(context).pop(true);
															return;
														}
														loginController.showSyncDialog.value = true;
														Future.delayed(Duration(seconds: 3)).then((value) async{
															if(result==1) {
																loginController.success.value = 0;
																Future.delayed(Duration(seconds: 2)).then((value) =>Navigator.of(context).pop(true));
															}
															else {
																loginController.success.value = 2;
																Future.delayed(Duration(seconds: 2)).then((value) =>Navigator.of(context).pop(true));
															};
														});
													}
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
						loginController.showSyncDialog.value == true ? Container(
							color: Colors.black.withOpacity(0.5),
							child: Center(
								child: Card(
									child: Padding(
										padding: const EdgeInsets.all(20.0),
										child: loginController.success.value == 0
												? Column(
														mainAxisSize: MainAxisSize.min,
														children: [
															Iconify(Emojione.white_heavy_check_mark),
															SizedBox(height: 20),
															Text('Đồng bộ thành công',style: titleStyle,),
														],
													)
												: loginController.success.value == 1
													? Column(
														mainAxisSize: MainAxisSize.min,
														children: [
															LoadingAnimationWidget.staggeredDotsWave(color: RootColor.cam_nhat, size:40),
															SizedBox(height: 20),
															Text('Đang đồng bộ...'),
														],
													)
													:  Column(
															mainAxisSize: MainAxisSize.min,
															children: [
																Iconify(Emojione.cross_mark_button),
																SizedBox(height: 20),
																Text('Đồng bộ không thành công'),
															],
														)
										)

										// Obx(
										// 	()=>Column(
										// 		mainAxisSize: MainAxisSize.min,
										// 		children: [
										// 			CircularProgressIndicator(value: loginController.progress.value / 100),
										// 			SizedBox(height: 20),
										// 			Text('Đang đồng bộ: ${loginController.progress}%'),
										// 		],
										// 	),
										// )
									),
								),
						):SizedBox()
					],
				)
			)
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