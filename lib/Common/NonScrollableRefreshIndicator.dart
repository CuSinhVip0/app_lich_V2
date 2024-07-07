import 'package:flutter/material.dart';

// NOTE: this is really important, it will make overscroll look the same on both platforms
class _ClampingScrollBehavior extends ScrollBehavior {
	@override
	ScrollPhysics getScrollPhysics(BuildContext context) => ClampingScrollPhysics();
}

class NonScrollableRefreshIndicator extends StatelessWidget {
	final Widget child;
	final Future<void> Function() onRefresh;

	const NonScrollableRefreshIndicator({
		required this.child,
		required this.onRefresh,
		Key? key,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
			builder: ((_, constraints) {
				return RefreshIndicator(
					onRefresh: onRefresh,
					child: ScrollConfiguration(
						// Customize scroll behavior for both platforms
						behavior: _ClampingScrollBehavior(),
						child: SingleChildScrollView(
							physics: BouncingScrollPhysics(),
							child: child,
						),
					),
				);
			}),
		);
	}
}