import 'dart:core';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Controller/Home/Calender.dart';

class CalendarV3 extends StatelessWidget {
    Function onTap;
    DateTime selectedD;
    CalendarV3({
        required this.onTap,
        required this.selectedD
});
    CalenderController calenderController = Get.find();
    @override
    Widget build(BuildContext context) {
        context.isDarkMode;
        return Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                            children: [
                                Expanded(flex: 1, child: Text("T2", textAlign: TextAlign.center)),
                                Expanded(flex: 1, child: Text("T3", textAlign: TextAlign.center)),
                                Expanded(flex: 1, child: Text("T4", textAlign: TextAlign.center)),
                                Expanded(flex: 1, child: Text("T5", textAlign: TextAlign.center)),
                                Expanded(flex: 1, child: Text("T6", textAlign: TextAlign.center)),
                                Expanded(flex: 1, child: Text("T7", textAlign: TextAlign.center)),
                                Expanded(flex: 1, child: Text("CN",textAlign: TextAlign.center,)),
                            ],
                        ),
                    ),
                    SizedBox(
                        height: 340,
                        child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                                dragDevices: {
                                    PointerDeviceKind.mouse,
                                    PointerDeviceKind.touch,
                                },),
                        child:GetBuilder<CalenderController>(
                            builder: (calenderController)=>CustomScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: calenderController.controller,
                                center: ValueKey(0),
                                physics: PageScrollPhysics(),
                                slivers: [
                                    SliverFillViewport(delegate: SliverChildBuilderDelegate((context, index) {
                                        return calenderController.pagesprev.length>0 ? calenderController.pagesprev[index] : null;
                                    })),
                                    SliverFillViewport(
                                        key: ValueKey(0),
                                        delegate: SliverChildBuilderDelegate((context, index) {
                                            return calenderController.pages.length>0 ?  calenderController.pages[index] : null;
                                        }))
                                ],
                            ),
                        )),
                    )
            ]),
        );
    }

}
