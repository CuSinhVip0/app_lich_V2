import 'package:flutter/material.dart';

// NOTE: this is really important, it will make overscroll look the same on both platforms
class _ClampingScrollBehavior extends ScrollBehavior {
	@override
	ScrollPhysics getScrollPhysics(BuildContext context) => ClampingScrollPhysics();
}

class NonScrollableRefreshIndicatorV2 extends StatelessWidget {
	final Widget child;
	final Future<void> Function() onRefresh;
	ScrollController scrollController;

	 NonScrollableRefreshIndicatorV2({
		required this.child,
		required this.onRefresh,
		 required this.scrollController,
		Key? key,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
			builder: ((_, constraints) {
				return RefreshIndicator(
					onRefresh: onRefresh,
					child: ScrollConfiguration(
						behavior: _ClampingScrollBehavior(),
						child: SingleChildScrollView(
							controller: scrollController,
							physics: BouncingScrollPhysics(),
							child: child,
						),
					),
				);
			}),
		);
	}
}