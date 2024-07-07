class Menh{
	String? menh;
	String? ten;
	String? nguHanh;
	String? nghiaNguHanh;

	Menh({this.menh, this.ten,this.nguHanh, this.nghiaNguHanh});

	factory Menh.fromJson(Map<String,dynamic>data){
		return Menh(
			ten: data['Ten'] as String,
			menh: data['Menh'] as String,
			nguHanh: data['NguHanh'] as String,
			nghiaNguHanh: data['NghiaNguHanh'] as String
		);
	}

}
