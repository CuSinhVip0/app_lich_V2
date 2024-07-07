import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget{
	@override
  	Widget build(BuildContext context) {
		return CircularProgressIndicator(
			valueColor:AlwaysStoppedAnimation(Color(0xffff745c))
		);
  	}


}