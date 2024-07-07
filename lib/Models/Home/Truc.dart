class Truc {
	String? ten;
	String? tinhChat;

	Truc({this.ten, this.tinhChat});

	factory Truc.fromJson(Map<String,dynamic> data){
		return Truc(
			ten:data['Ten'] as String,
			tinhChat:data['TinhChat'] as String
		);
	}
}