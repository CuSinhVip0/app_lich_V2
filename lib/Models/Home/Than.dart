class Than {
	String? ten;
	int? isHoangDao;

	Than({this.ten, this.isHoangDao});

	factory Than.fromJson(Map<String,dynamic> data){
		return Than(
			ten:data['Ten'] as String,
			isHoangDao:data['IsHoangDao'] as int
		);
	}
}