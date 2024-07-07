class Task{
	String? ten;
	int? ngay;
	int? thang;
	int? duongLich;
	String? chiTiet;
	int? nam;
	String? gioBatDau;
	String? gioKetThuc;
	String? loai;
	int? status;

	Task({this.ten, this.ngay, this.thang, this.duongLich, this.chiTiet,this.nam,this.gioBatDau,this.gioKetThuc,this.status,this.loai});

	factory Task.fromJson (Map<String,dynamic> data){
		return Task(
			ten:data['Ten'] !=null ? data['Ten']  as String : null ,
			ngay:data['Ngay'] !=null ? data['Ngay']  as int : null ,
			thang:data['Thang'] !=null ? data['Thang']  as int : null,
			duongLich:data['DuongLich']!=null ? data['DuongLich']  as int : null,
			chiTiet:data['ChiTiet'] !=null ? data['ChiTiet']  as String : null,
			nam:data['Nam'] !=null ? data['Nam']  as int : null,
			gioKetThuc:data['GioKetThuc'] !=null ? data['GioKetThuc']  as String : null,
			gioBatDau:data['GioBatDau'] !=null ? data['GioBatDau']  as String : null,
			loai:data['Loai'] !=null ? data['Loai']  as String : null,
			status:data['Status'] !=null ? data['Status']  as int : null,
		);
	}
}