import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luanvan/utils/lunar_solar_utils.dart';
import '../../Styles/Themes.dart';
class PickInput extends StatelessWidget{
	final String hint;
	final TextEditingController? textEditingController;
	final bool DuongLich;
	final DateTime? date;
	Function()? onTap;
	PickInput({
		Key? key,
		required this.hint,
		required this.DuongLich,
		this.textEditingController,
		this.date,
		this.onTap
	}):super(key:key);
	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		var Lunar = convertSolar2Lunar(date!.day, date!.month, date!.year, 7);
		return GestureDetector(
			onTap: onTap,
		  child: Container(
		  		padding:EdgeInsets.symmetric(horizontal: 20,vertical: 8),
		  		decoration: BoxDecoration(
		  			border: Border.all(
		  				color: Colors.grey,
		  				width: 1
		  			),
		  			borderRadius: BorderRadius.circular(12)
		  		),
		  		child:Column(
		  			mainAxisAlignment: MainAxisAlignment.center,
		  			crossAxisAlignment: CrossAxisAlignment.start,
		  			children: [
		  				(DuongLich == true)
		  					? SizedBox()
		  					: Text(
		  						"${Lunar[0]} / ${Lunar[1]}, ${getCanChiYear(Lunar[2])}",
		  						style: GoogleFonts.mulish(
		  							textStyle:TextStyle(
		  								fontSize: 14,
		  								fontWeight: FontWeight.w400,
		  								color: Get.isDarkMode ? Colors.white : Colors.black
		  							)
		  						)
		  				),

		  				Text(
		  					hint.toString().split(', ')[0],
		  					style: GoogleFonts.mulish(
		  						textStyle:TextStyle(
		  							fontSize: 14,
		  							fontWeight: FontWeight.w400,
		  							color:DuongLich == true? (Get.isDarkMode ? Colors.white : Colors.black) :   (Get.isDarkMode ? Colors.white : Colors.grey[600])
		  						)
		  					)
		  				),
		  				Text(
		  					hint.toString().split(', ')[1] + ", "+ hint.toString().split(', ')[2],
		  					style: GoogleFonts.mulish(
		  						textStyle:TextStyle(
		  							fontSize: 14,
		  							fontWeight: FontWeight.w400,
		  							color: Colors.grey[600]
		  						)
		  				),)
		  			],
		  		)
		  	),
		);

	}
}