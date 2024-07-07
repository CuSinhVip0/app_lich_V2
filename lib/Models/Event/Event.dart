class Event{
	String? ten;
	int? ngay;
	int? thang;
	int? duongLich;
	String? chiTiet;
	int? nam;

	Event({this.ten, this.ngay, this.thang, this.duongLich, this.chiTiet,this.nam});

	factory Event.fromJson (Map<String,dynamic> data){
		return Event(
			ten:data['Ten'] !=null ? data['Ten']  as String : null ,
			ngay:data['Ngay'] !=null ? data['Ngay']  as int : null ,
			thang:data['Thang'] !=null ? data['Thang']  as int : null,
			duongLich:data['DuongLich']!=null ? data['DuongLich']  as int : null,
			chiTiet:data['ChiTiet'] !=null ? data['ChiTiet']  as String : null,
			nam:data['Nam'] !=null ? data['Nam']  as int : null,
		);
	}
}