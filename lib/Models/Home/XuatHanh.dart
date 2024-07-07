class XuatHanh {
	String? hythan;
	String? tenHythan = 'Hỷ thần';
	String? tenTaithan = 'Tài thần';
	String? tenHacthan = 'Hạc thần';
	String? taithan;
	String? hacthan;
	XuatHanh({this.hythan, this.taithan, this.hacthan});

	factory XuatHanh.fromJson(Map<String, dynamic> data){
		return XuatHanh(
			hythan: data['hythan'].toString(),
			taithan : data['taithan'].toString(),
			hacthan: data['hacthan'].toString()
		);
	}

}