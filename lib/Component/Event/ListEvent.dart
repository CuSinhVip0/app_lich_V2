
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luanvan/Styles/Colors.dart';
import 'package:luanvan/Styles/Themes.dart';
import '../../Enum/Data.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../utils/date_utils.dart';
enum ITEM_TYPE { main, sub, hidden }

class ListEvent extends StatefulWidget {
	 ItemScrollController itemScrollController;
	 List<dynamic> mainItems;
	 List<GlobalKey> mainKeys;
	 List<dynamic> subItems;
	 bool show;
	 ItemPositionsListener? itemPositionsListener;
	 int yearPrev;
	 int yearNext;
	 Function subYear;
	 Function addYear;
	 ListEvent({required this.itemScrollController,
		 required this.mainKeys,
		 required this.mainItems,
		 required this.show,
		 required this.subItems,
		 required this.itemPositionsListener,
		 required this.yearPrev,
		 required this.yearNext,
		 required this.subYear,
		 required this.addYear});
	 @override
	 State<ListEvent> createState() => _ListEventState();
}

class _ListEventState extends State<ListEvent> {
	List<dynamic> hiddenItems = [];
	List<GlobalKey> hiddenKeys = [];
	ItemScrollController? itemScrollController ;
	bool isLoadingMore = false;
	bool isLoadingPrev = false;

	@override
	void initState() {
		itemScrollController = widget.itemScrollController;
		super.initState();
	}

	@override
	void dispose() {
		super.dispose();
	}
	@override
	Widget build(BuildContext context) {
		context.isDarkMode;
		return Container(
			color: Get.isDarkMode ? RootColor.den_body : Colors.white,
			child: Stack(
				children: [
					_hiddenWidget(),
					Column(
						children: [
							if (isLoadingPrev)
								const LinearProgressIndicator(minHeight: 2),
							Expanded(
								child: Row(
									children: [
										_mainWidget(context),
										_subWidget(context),
									],
								),
							),
							if (isLoadingMore)
								Container(
									width: 30,
									height: 30,
									padding: const EdgeInsets.all(4),
									child: const CircularProgressIndicator(strokeWidth: 2),
								)
						],
					),
				],
			),
		);
	}

	Expanded _subWidget(BuildContext context) {
		return Expanded(
			flex: !isLoadingPrev ? 0 : 1,
			child: SizedBox(
				width: !isLoadingPrev ? 0 : MediaQuery.of(context).size.width,
				child: ListView.builder(
					physics: const BouncingScrollPhysics(),
					itemBuilder: (context, index) {
						return _itemContainer(
							index: index,
							type: ITEM_TYPE.sub,
						);
					},
					itemCount: widget.subItems.length,
				),
			),
		);
	}

	Expanded _mainWidget(BuildContext context) {
		return Expanded(
			flex: isLoadingPrev ? 0 : 1,
			child: SizedBox(
				width: MediaQuery.of(context).size.width,
				child: NotificationListener<ScrollNotification>(
					onNotification: (ScrollNotification scrollInfo) {
						if (scrollInfo is ScrollUpdateNotification) { // Chỉ xử lý ScrollUpdateNotification
							final metrics = scrollInfo.metrics;
							final maxScroll = metrics.maxScrollExtent;
							final currentScroll = metrics.pixels;
							final isOutOfRange = metrics.outOfRange;

							// Tải thêm khi gần đến cuối danh sách
							if (currentScroll >= maxScroll  && !isLoadingMore && !isOutOfRange ) {
								_loadMore();
							}
							// Tải trước khi gần đến đầu danh sách
							if (currentScroll <= metrics.minScrollExtent && !isLoadingPrev && !isOutOfRange) {
								_loadPrev();
							}
						}
						return true;
					},
					child: Visibility(
						maintainSize: true,
						maintainAnimation: true,
						maintainState: true,
						visible: widget.show,
						child: ScrollablePositionedList.builder(
							itemPositionsListener: widget.itemPositionsListener,
							physics: const BouncingScrollPhysics(),
							itemBuilder: (context, index) {
								return _itemContainer(
									index: index,
									type: ITEM_TYPE.main,
								);
							},
							itemScrollController: itemScrollController,
							itemCount: widget.mainItems.length,

						),
					)
				)

			),
		);
	}

	Positioned _hiddenWidget() {
		return Positioned.fill(
			left: 0,
			bottom: 0,
			child: Offstage(
				offstage: true,
				child: SingleChildScrollView(
					physics: const BouncingScrollPhysics(),
					child: Column(
						children: hiddenItems
							.mapIndexed(
								(index, element) => _itemContainer(
								index: index,
								type: ITEM_TYPE.hidden,
							),
						)

							.toList(),
					),
				),
			),
		);
	}

	TextButton _itemContainer({required int index, required ITEM_TYPE type}) {
		Key? key;
		dynamic text ;

		switch (type) {
			case ITEM_TYPE.main:
				key = widget.mainKeys[index];
				text =widget.mainItems[index];
				break;

			case ITEM_TYPE.hidden:
				key = hiddenKeys[index];
				text = hiddenItems[index];
				break;

			case ITEM_TYPE.sub:
				text = widget.subItems[index];
				break;
			default:
		}

		return  TextButton(
			onPressed: text['thumnail'] == true ?null: (){
				Navigator.of(context).pushNamed('/eventDetailPage' ,arguments: {
					'item': widget.mainItems[index],
				});
			},
			style: TextButton.styleFrom(
				shape: BeveledRectangleBorder(),
				backgroundColor: Get.isDarkMode ? RootColor.den_body : Colors.white,
				padding: EdgeInsets.zero,
				foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
				textStyle: titleStyle
			),
			key:key,
			child: Container(
				padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
				alignment: Alignment.centerLeft,
				width: double.infinity,
				child: text['thumnail'] == true
					? Align(
					alignment: Alignment.center,
					child: Text(getNameMonthOfYear(text['ThangDuong']as int)),
				)

					:Row(
					children: [
						Expanded(flex:1,child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text((text['NgayDuong'].toString()),style: TextStyle(fontSize: 18)),
								(text['DuongLich']==0)? Text((text['NgayAm'].toString() +'/'+text['ThangAm'].toString()),style: TextStyle(fontSize: 13),):SizedBox()
							],
						),),
						Expanded(flex: 6,child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text((text['Ten'] ??''),style: TextStyle(fontSize: 16),),
								SizedBox(height: 4,),
								Text("Cả ngày",style: TextStyle(fontSize: 13),),
							],
						),)
					],
				)));

	}

	void _loadMore( ) async{
		if (isLoadingMore || isLoadingPrev) {
			return;
		}
		setState(() {
			isLoadingMore = true;
		});
		final res = await http.post(Uri.parse(ServiceApi.api+'/event/getEvents'),
			headers: {"Content-Type": "application/json"},
			body: jsonEncode({
				"nam":widget.yearNext
			}));
		dynamic result = jsonDecode(res.body);
		Future.delayed(const Duration(seconds: 3)).then((value) {
			for (var i = 0; i < result['data'].length; i++) {
				widget.mainItems.add(result['data'][i]);
				widget.mainKeys.add(GlobalKey());
			}

			setState(() {});
			isLoadingMore = false;
			widget.subItems = List<dynamic>.from(widget.mainItems);
		});
	}

	void _loadPrev() async {
		if (isLoadingMore || isLoadingPrev) {
			return;
		}

		setState(() {
			isLoadingPrev = true;
		});
		hiddenItems = [];
		hiddenKeys = [];
		final res = await http.post(Uri.parse(ServiceApi.api+'/event/getEvents'),
			headers: {"Content-Type": "application/json"},
			body: jsonEncode({
				"nam":widget.yearPrev
			}));
		dynamic result = jsonDecode(res.body);
		double estimatedAdjustment = 0.0;
		estimatedAdjustment = result['data'].length * 84.0;
		Future.delayed(const Duration(seconds: 3)).then((value) {
			for (var i = result['data'].length-1; i>=0 ; i--) {
				widget.mainItems.insert(0, result['data'][i]);
				widget.mainKeys.insert(0, GlobalKey());
				hiddenItems.insert(0, result['data'][i]);
				hiddenKeys.insert(0, GlobalKey());
			}
			setState(() {});
			itemScrollController!.jumpTo(index: result['data'].length);
			WidgetsBinding.instance.addPostFrameCallback((_) {
				WidgetsBinding.instance.addPostFrameCallback((_) {
					double adjustment = 0.0;

					for (var i = 0; i <  result['data'].length; i++) {
						RenderBox renderBox =
						hiddenKeys[i].currentContext?.findRenderObject() as RenderBox;
						adjustment += renderBox.size.height;
					}

					itemScrollController!.jumpTo(index: result['data'].length);
					Future.microtask(() {
						setState(() {
							isLoadingPrev = false;
							widget.subItems = List<dynamic>.from(widget.mainItems);
						});
						widget.subYear();
					});
				});
			});
		});
	}
}