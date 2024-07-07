import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luanvan/Controller/LoginController.dart';
import '../../Styles/Themes.dart';
class Input extends StatelessWidget{
	final String? title;
	final String hint;
	final TextEditingController? textEditingController;
	final Widget? icon;
	final double? size;
	final FontWeight? txtWeight;
	final Color? txtColor;
	final Color? hintColor;
	Input({
		Key? key,
		this.title,
		required this.hint,
		this.textEditingController,
		this.icon,
		this.size,
		this.txtColor,
		this.txtWeight,
		this.hintColor,

	}):super(key:key);
	
	@override
	Widget build(BuildContext context) {
		return Container(
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					title == null
						? SizedBox()
						: Padding(padding: EdgeInsets.only(bottom: 8),
						child: Text(
							title!,
							style: titleStyle,
						),
					),

					Container(
						height: 52,
						padding:icon==null?EdgeInsets.symmetric(horizontal: 12):EdgeInsets.only(left: 12),
						decoration: BoxDecoration(
							border: Border.all(
								color: Colors.grey,
								width: 1
							),
							borderRadius: BorderRadius.circular(12)
						),
						child: Row(
							children: [
								Expanded(
									child:TextFormField(
										readOnly: icon != null?true:false,
										autofocus: false,
										controller: textEditingController,
										cursorColor: Colors.grey[400],
										style:size != null && txtColor != null && txtWeight != null ? CustomStyle(size!, txtColor!, txtWeight!) : subTitleStyle ,
										decoration: InputDecoration(
											hintText: hint,
											hintStyle: size != null && hintColor != null && txtWeight != null ? CustomStyle(size!, hintColor!, txtWeight!) : subTitleStyle ,
											focusedBorder: UnderlineInputBorder(
												borderSide: BorderSide(
													color:Colors.white,
													width: 0
												)
											),
											enabledBorder: UnderlineInputBorder(
												borderSide: BorderSide(
													color:Colors.white,
													width: 0
												)
											),
											disabledBorder: UnderlineInputBorder(
												borderSide: BorderSide(
													color:Colors.white,
													width: 0
												)
											),
										),

									)),
								icon ==null?SizedBox():Container(
									child: icon,
								)
							],
						)
					),
				],
			),
		);
	}
}