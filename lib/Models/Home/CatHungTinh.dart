import 'dart:ffi';

class CatHungTinh{
	int? Id;
	int? Thang;
	String? Ten;
	int? CatTinh;
	String? Mota_ChiTiet;
	String? Mota_TomTat;
	String? Mota_Le;
	CatHungTinh({this.Id, this.Thang, this.Ten, this.CatTinh, this.Mota_ChiTiet, this.Mota_TomTat, this.Mota_Le});

	factory CatHungTinh.fromJson(Map<String,dynamic>data){
		return CatHungTinh(
			Id:data['Id'] as int,
			Thang:data['Thang'] as int,
			Ten:data['Ten'] as String,
			CatTinh:data['CatTinh'] as int,
			Mota_ChiTiet:data['Mota_ChiTiet'] != null ?data['Mota_ChiTiet'] as String : null,
			Mota_TomTat:data['Mota_TomTat'] != null ?data['Mota_TomTat'] as String : null,
			Mota_Le: data['Mota_Le'] != null ?data['Mota_Le'] as String : null
		);
	}
}