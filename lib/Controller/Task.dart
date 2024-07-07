import 'package:get/get.dart';

class TaskController extends GetxController{
	Map<String, dynamic> task = {};
	void setTask (Map<String, dynamic> e){
		task = e;
		update();
	}

}