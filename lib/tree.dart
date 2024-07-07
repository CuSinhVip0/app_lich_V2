// import 'package:flutter/material.dart';
// import 'package:luanvan/pages/home.dart';
// import 'Auth.dart';
// import 'login.dart';
//
// class WidgetTree extends StatefulWidget {
// 	WidgetTree ({Key? key}) :super (key:key);
//
//   @override
//   State<WidgetTree> createState() => _WidgetTreeState();
// }
//
// class _WidgetTreeState extends State<WidgetTree> {
//
// 	@override
// 	Widget build(BuildContext context) {
// 		return StreamBuilder(stream: Auth().authStateChanges,
// 			builder: (context,snapshot){
// 			print(snapshot.hasData);
// 				if(snapshot.hasData){
// 					return HomePage();
// 				}
// 				// else {
// 					return LoginPage();
// 				}
// 			});
// 	}
// }