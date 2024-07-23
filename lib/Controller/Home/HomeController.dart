import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../Enum/Data.dart';
import '../../utils/lunar_solar_utils.dart';

class HomeController extends GetxController{
	DateTime selectedDate = DateTime.now();
	var hide =false.obs;
	var loading = false.obs;
	List<dynamic> lunarDate = convertSolar2Lunar(DateTime.now().day, DateTime.now().month, DateTime.now().year,7);
	List<dynamic> listGioHoangDao= (getGioHoangDao(jdn(DateTime.now().day,DateTime.now().month,DateTime.now().year)).split(", "));
	var connectionStatus = [ConnectivityResult.none];
	var xuathanh ={};
	var truc ={};
	var than ={};
	var sao ={};
	var menhNam ={};
	var menhNgay ={};
	var catTinh=[].obs;
	var hungTinh=[].obs;
	var xungKhac=[].obs;

	void updateXuatHanh (dynamic a ){
		xuathanh  = a;
		update();
	}

	void updateTruc (dynamic a ){
		truc = a;
		update();
	}

	void updateThan (dynamic a ){
		than = a;
		update();
	}

	void updateSao (dynamic a ){
		sao = a;
		update();
	}

	void updateMenhNam (dynamic a ){
		menhNam = a;
		update();
	}

	void updateMenhNgay (dynamic a ){
		menhNgay = a;
		update();
	}

	void updateLunarDate (List<dynamic> a){
		lunarDate = a;
		update();
	}


	void updateSelectedDate  (DateTime d) {
		selectedDate = d;
		update();
	}

	void updateConnectionStatus (List<ConnectivityResult> e ){
		connectionStatus = e;
		update();
	}

	void getData() async{
		try{
			final result = await http.post(Uri.parse(ServiceApi.api+'/infor/getThongTinNgay'),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Can":getCanDay(jdn(selectedDate.day,selectedDate.month,selectedDate.year)).split(' ')[0],
					"Chi":getCanDay(jdn(selectedDate.day,selectedDate.month,selectedDate.year)).split(' ')[1],
					"CanChiNam":getCanChiYear(selectedDate.year),
					"ngayam":lunarDate[1].toString()+'/'+lunarDate[0].toString()+'/'+lunarDate[2].toString(),
					"ngayduong":selectedDate.month.toString()+'/'+selectedDate.day.toString()+'/'+selectedDate.year.toString(),
				}));
			var res = jsonDecode(result.body);
			hungTinh.assignAll(res['hungtinh']);
			catTinh.assignAll(res['cattinh']);
			xungKhac.assignAll(res['xungkhac']);
			xuathanh = 	res['xuathanh'];
			truc = res['truc'];
			than = res['than'];
			sao = res['sao'];
			menhNam = res['menhnam'];
			menhNgay = res['menhngay'];
			loading.value = false;
		}catch(e){
			print("---------Lỗi HomeController getData()---------");
			print(e);
			print("-------End lỗi HomeController getData()-------");
		}
	}

	@override
	void onReady() {
		getData();
		super.onReady();
	}
}


