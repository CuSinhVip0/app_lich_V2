import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Enum/Data.dart';
class UpdateController extends GetxController{
	var loading = false.obs;
	Future<bool> updateInforToDatabase(String key,String id,var value) async{
		try{
			final res = await http.post(Uri.parse(ServiceApi.api+'/user/updateInforToDatabase/'+key),
				headers: {"Content-Type": "application/json"},
				body: jsonEncode({
					"Id_User":id,
					"Value":value
				}));
			dynamic result = jsonDecode(res.body);
			if(result['status']=='oke')
				return true;
			return false;
		}
		catch(e){
			print("-- Lỗi xảy ra ở UserController updateInforToDatabase - catch --");
			print(e);
			print("-- End Lỗi xảy ra ở UserController updateInforToDatabase - catch --");
			return false;
		}
	}

}