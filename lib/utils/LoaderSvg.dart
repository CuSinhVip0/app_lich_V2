import 'package:flutter_svg/flutter_svg.dart';

class ImageUtils {

	static const String imageHistory = 'assets/backgroundlogin.svg';
	static const String imageHistory2 = 'assets/backgroundlogin_darkmode.svg';
	static const String imageHistory3 = 'assets/notask.svg';



	static Future<void> svgPrecacheImage() async {
		const cacheSvgImages = [
			ImageUtils.imageHistory,
			ImageUtils.imageHistory2,
			ImageUtils.imageHistory3,
		];

		for (String element in cacheSvgImages) {
			var loader = SvgAssetLoader(element);
			svg.cache
				.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
		}

	}

}