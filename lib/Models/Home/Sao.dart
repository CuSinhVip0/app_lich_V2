class Sao {
	String? ten;

	Sao({this.ten});

	factory Sao.fromJson(Map<String,dynamic> data){
		return Sao(
			ten:data['Ten'] as String,
		);
	}
}