import 'package:flutter/cupertino.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';

Widget getIcon(i){
	switch (i){
		case 1:
			return Iconify(EmojioneV1.mouse_face);
		case 2:
			return Iconify(EmojioneV1.cow_face);
		case 3:
			return Iconify(EmojioneV1.tiger_face);
		case 4:
			return Iconify(EmojioneV1.cat_face);
		case 5:
			return Iconify(EmojioneV1.dragon_face);
		case 6:
			return Iconify(EmojioneV1.snake);
		case 7:
			return Iconify(EmojioneV1.horse_face);
		case 8:
			return Iconify(EmojioneV1.goat);
		case 9:
			return Iconify(EmojioneV1.monkey_face);
		case 10:
			return Iconify(EmojioneV1.front_facing_baby_chick);
		case 11:
			return Iconify(EmojioneV1.dog_face);
		case 12:
			return Iconify(EmojioneV1.pig_face);
		default: return SizedBox();
	}
}