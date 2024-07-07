import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DetailPostPage extends StatelessWidget{
	@override
 	 Widget build(BuildContext context) {
		print(Get.parameters['payload']);
    	return Text("OKe");
  	}
}