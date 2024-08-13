import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ListEventController extends GetxController{

	List<dynamic> hiddenItems = [];
	List<GlobalKey> hiddenKeys = [];
	var isLoadingMore = false.obs;
	var isLoadingPrev = false.obs;
}