class CanChi{
	int? id;
	String? ten;
	String? menh;
	String? nguHanh;
	String? nghiaNguHanh;

	CanChi({this.id, this.ten, this.menh, this.nguHanh, this.nghiaNguHanh});

	factory CanChi.fromJson(Map<String,dynamic> data){
		return CanChi(
			id: data['Id'] as int,
			ten: data['Ten'] as String,
			menh: data['Menh'] as String,
			nguHanh: data['NguHanh'] as String,
			nghiaNguHanh: data['NghiaNguHanh'] as String,
		);
	}
}