import 'package:flutter/cupertino.dart';

class NoInternet extends StatelessWidget {
  	@override
  	Widget build(BuildContext context) {
    	return Column(
			children: [
				Container(
					margin: EdgeInsets.only(top: 20,bottom: 10),
					child: Text("Không có kết nối internet",
						style: TextStyle(fontSize: 20),
					)
				),
				Container(
					margin: EdgeInsets.only(bottom: 10),
					child: Text("Vui lòng kết nối internet và thử lại.")
				),
			],
		);
  	}
}