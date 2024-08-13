import 'dart:convert';
import 'dart:core';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jiffy/jiffy.dart';
import 'package:luanvan/Styles/Colors.dart';

import '../Controller/Component/UserController.dart';
import '../Controller/Home/Calender.dart';
import '../Enum/Data.dart';
import '../utils/lunar_solar_utils.dart';

class CalendarV2 extends StatefulWidget {
  Function onTap;
  DateTime selectedD;
  CalendarV2({
      required this.onTap,
      required this.selectedD
});

  @override
  State<CalendarV2> createState() => _CalendarV2State();
}

class _CalendarV2State extends State<CalendarV2> {
    var calenderController = Get.put(CalenderController());
    UserController userController = Get.find();
    int? addY;
    int? addM;
    int? addD;
    int? _initIndex;
    List<int> listnext = [0, 1, 2];
    List<int> listprev = [-1, -2];
    List<int> list = [-2, -1, 0, 1, 2];
    int pointLeft = -2; // diem them items
    int pointRight = 2; // diem them item
    DateTime? pick;
    ScrollController? _controller; // controller của scrollview
    List<Widget>? pages; // 2 tháng kế tiếp + tháng hiện tại
    List<Widget>? pagesprev; // 2 tháng kế trc
    List<GlobalKey>? listOfGlobalKeys; // key cho cac bang
    var listBookmark = [];
    Future<dynamic> _getDateEventToSetBookmark(int month, int year,int key) async {
        final res = await http.post(Uri.parse(ServiceApi.api + '/event/getDateEventToSetBookmark'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
                "Thang": month,
                "Nam": year,
                "Key":key,
                "IdUser":userController.userData['id']
            }));
        Iterable result = jsonDecode(res.body);
        return result;
    }

    void getDateEventToSetBookmark(int month,int year)async {
        var list = await _getDateEventToSetBookmark( month, year,3);
        setState(() {
            listBookmark = list;
            pages = List.generate(listnext.length, (index) {
                GlobalKey key = listOfGlobalKeys![index + listprev.length];
                DateTime date = DateTime(addY!, addM! + listnext[index], addD!);
                int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
                int f = Jiffy.parse("${date.year!}-${date.month!}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
                if (f == 1) f = 8;
                var items = list[1][index][1];
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    key: key,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 7,
                        children: List.generate(n! + f! - 2, (index) {
                            // lay ra số ngày của tháng + các ô trống trước ngày 1
                            index += 1;
                            if (index > f! - 2) {
                                List<dynamic> lunar = convertSolar2Lunar(index - f! + 2, date.month,  date.year, 7.0);
                                bool isNow = DateTime.now().day == index - f! + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
                                bool isHoangDao = getNgayHoangDao(index - f! + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
                                int isSelected =  DateTime(pick!.year,pick!.month,pick!.day).compareTo(DateTime(date.year, date.month, index - f! + 2)) /* time của ô */;
                                bool isSchedule =false;
                                if(items.length>0 && items[0]['Ngay']==(index - f! + 2)){
                                    isSchedule= true;
                                    items.removeAt(0);
                                }
                                return  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: TextButton(
                                        onPressed: () {
                                            DateTime now = DateTime.now();
                                            DateTime selectedDate = DateTime(date.year, date.month, index - f! + 2, now.hour, now.minute, now.second);
                                            setState(() {
                                                pick = selectedDate;
                                            });
                                            widget.onTap(selectedDate);
                                        },
                                        style: TextButton.styleFrom(padding: EdgeInsets.zero,  backgroundColor:isSelected==0? RootColor.cam_nhat : isNow ? Color(0xffff745c) : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                        child: Stack(
                                            children: [
                                                SizedBox(
                                                    child: Column(
                                                        children: [
                                                            Expanded(
                                                                flex: 3,
                                                                child: Center(
                                                                    child: Text(
                                                                        (index - f! + 2).toString(),
                                                                        style: TextStyle(fontSize: 16, color: isNow ? Colors.white : Colors.black),
                                                                    ),
                                                                )),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                    lunar[0] == 1 ? "${lunar[0]}/${lunar[1]}" : lunar[0].toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: isNow
                                                                            ? Colors.white
                                                                            : isHoangDao
                                                                            ? Colors.green
                                                                            : Color(0xff7d7f86)),
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                                /*   vị trí có lịch trình thì có đấu   */
                                                isSchedule
                                                    ? Positioned(
                                                        top: -3,
                                                        right:-5,
                                                        child: Icon(Icons.bookmark_outlined,color: Colors.green,size: 20,)
                                                    ):SizedBox()
                                                /* end vị trí có lịch trình thì có đấu */
                                            ],
                                        )
                                    )
                                );
                            } else {
                                return TextButton(
                                    onPressed: () {},
                                    child: SizedBox(),
                                );
                            }
                        }),
                    ),
                );
            });
            pagesprev = List.generate(listprev.length, (index) {
                GlobalKey key = listOfGlobalKeys![index];
                DateTime date = DateTime(addY!, addM! + listprev[index], addD!);
                int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
                int f = Jiffy.parse("${date.year!}-${date.month!}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
                if (f == 1) f = 8;
                var items = list[0][index][1];
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    key: key,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 7,
                        children: List.generate(n! + f! - 2, (index) {
                            // lay ra số ngày của tháng + các ô trống trước ngày 1
                            index += 1;
                            if (index > f! - 2) {
                                List<dynamic> lunar = convertSolar2Lunar(index - f! + 2, date.month,  date.year, 7.0);
                                bool isNow = DateTime.now().day == index - f! + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
                                bool isHoangDao = getNgayHoangDao(index - f! + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
                                bool isSelected = DateTime(pick!.year,pick!.month,pick!.day)== DateTime(date.year, date.month, index - f! + 2) /* time của ô */;
                                bool isSchedule =false;
                                if(items.length>0 && items[0]['Ngay']==(index - f! + 2)){
                                    isSchedule= true;
                                    items.removeAt(0);
                                }
                                return  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: TextButton(
                                        onPressed: () {
                                            DateTime now = DateTime.now();
                                            DateTime selectedDate = DateTime(date.year, date.month, index - f! + 2, now.hour, now.minute, now.second);
                                            setState(() {
                                                pick = selectedDate;
                                            });
                                            widget.onTap(selectedDate);
                                        },
                                        style: TextButton.styleFrom(padding: EdgeInsets.zero,  backgroundColor:isSelected? RootColor.cam_nhat : isNow ? Color(0xffff745c) : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                        child: Stack(
                                            children:[
                                                SizedBox(
                                                    child: Column(
                                                        children: [
                                                            Expanded(
                                                                flex: 3,
                                                                child: Center(
                                                                    child: Text(
                                                                        (index - f! + 2).toString(),
                                                                        style: TextStyle(fontSize: 16, color: isNow ? Colors.white : Colors.black),
                                                                    ),
                                                                )),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                    lunar[0] == 1 ? "${lunar[0]}/${lunar[1]}" : lunar[0].toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: isNow
                                                                            ? Colors.white
                                                                            : isHoangDao
                                                                            ? Colors.green
                                                                            : Color(0xff7d7f86)),
                                                                )),
                                                        ],
                                                    ),
                                                ),
                                                /*   vị trí có lịch trình thì có đấu   */
                                                isSchedule
                                                    ? Positioned(
                                                    top: -3,
                                                    right:-5,
                                                    child: Icon(Icons.bookmark_outlined,color: Colors.green,size: 20,)
                                                ):SizedBox()
                                                /* end vị trí có lịch trình thì có đấu */
                                            ]
                                        )
                                    ));
                            } else {
                                return TextButton(
                                    onPressed: () {},
                                    child: SizedBox(),
                                );
                            }
                        }),
                    ),
                );
            });
        });
    }

    @override
    void initState()  {
        pick = DateTime.now();
        addY = DateTime.now().year; // nam hien tai
        addD = DateTime.now().day; // ngay hien tai
        addM = DateTime.now().month; // thang hien tai
        _initIndex = 0; // vi tri cua page view
        _controller = ScrollController();

        listOfGlobalKeys = List.generate(list.length, (index) {
            return GlobalKey();
        });

        getDateEventToSetBookmark(addM!,addY!); // define 5 page

        _controller?.addListener(() {
            // lang nghe su kien\
            final index = (_controller!.offset / 387.4).round() > _initIndex! // offset = full width cua list pages
            // lay ofset chia cho width cua tung widget de xac dinh vi tri cua no trong list pages
                ? (_controller!.offset / 387.4).round().floor() // vuot phai
                : (_controller!.offset / 387.4).round().ceil(); // vuot trai
            if (index == _initIndex) return;
            if (index > _initIndex!) {
                // vi tri lon hon vi tri hien tai
                pagenext();
            } else if (index < _initIndex!) {
                // vi tri lon hon vi tri hien tai
                pageprev();
            }
        });
    }

    void pageprev() async {
        DateTime date = DateTime(addY!, addM! + list.first-1, addD!);
        print(date);
        var items = await _getDateEventToSetBookmark( date.month,date.year,1);
        setState(() {
            list // xoa cuoi va them dau
                ..insert(0, list.first - 1)
                ..removeLast();
            _initIndex = _initIndex! - 1; // giam vi tri cua page view di 1
            GlobalKey key = GlobalKey();
            listOfGlobalKeys!
                ..insert(0, key) // insert 1 key voi vao dau
                ..removeLast();
            int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
            int f = Jiffy.parse("${date.year!}-${date.month!}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
            if (f == 1) f = 8;
            if (list.first + 1 == pointLeft) {

                pagesprev!.add(Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    key: key,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 7,
                        children: List.generate(n! + f! - 2, (index) {
                            // lay ra số ngày của tháng + các ô trống trước ngày 1
                            index += 1;
                            if (index > f! - 2) {
                                List<dynamic> lunar = convertSolar2Lunar(index - f! + 2, date.month,  date.year, 7.0);
                                bool isNow = DateTime.now().day == index - f! + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
                                bool isHoangDao = getNgayHoangDao(index - f! + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
                                bool isSelected = DateTime(widget.selectedD.year,widget.selectedD.month,widget.selectedD.day)== DateTime(date.year, date.month, index - f! + 2) /* time của ô */;
                                bool isSchedule =false;
                                if(items.length>0 && items[0]['Ngay']==(index - f! + 2)){
                                    isSchedule= true;
                                    items.removeAt(0);
                                }
                                return  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: TextButton(
                                        onPressed: () {
                                            DateTime now = DateTime.now();
                                            DateTime selectedDate = DateTime(date.year, date.month, index - f! + 2, now.hour, now.minute, now.second);
                                            setState(() {
                                                pick = selectedDate;
                                            });
                                            widget.onTap(selectedDate);
                                        },
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor:isSelected? RootColor.cam_nhat : isNow ? Color(0xffff745c) : Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                        child: Stack(
                                            children: [SizedBox(
                                                child: Column(
                                                    children: [
                                                        Expanded(
                                                            flex: 3,
                                                            child: Center(
                                                                child: Text(
                                                                    (index - f! + 2).toString(),
                                                                    style: TextStyle(fontSize: 16, color: isNow ? Colors.white : Colors.black),
                                                                ),
                                                            )),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                                lunar[0] == 1 ? "${lunar[0]}/${lunar[1]}" : lunar[0].toString(),
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: isNow
                                                                        ? Colors.white
                                                                        : isHoangDao
                                                                        ? Colors.green
                                                                        : Color(0xff7d7f86)),
                                                            )),
                                                    ],
                                                ),
                                            ),
                                                /*   vị trí có lịch trình thì có đấu   */
                                                isSchedule
                                                    ? Positioned(
                                                    top: -3,
                                                    right:-5,
                                                    child: Icon(Icons.bookmark_outlined,color: Colors.green,size: 20,)
                                                ):SizedBox()
                                                /* end vị trí có lịch trình thì có đấu */
                                            ])
                                    ));
                            } else {
                                return TextButton(
                                    onPressed: () {},
                                    child: SizedBox(),
                                );
                            }
                        }),
                    )));
                pointLeft = list.first;
            }
        });
    }

    void pagenext() async {
        DateTime date = DateTime(addY!, addM! + list.last, addD!);
        var items = await _getDateEventToSetBookmark( date.month,date.year,1);
        setState(() {
            list // xoa dau va them cuoi
                ..removeAt(0)
                ..insert(list.length, list.last + 1);
            _initIndex = _initIndex! + 1; // tang vi tri cua page view len 1
            GlobalKey key = GlobalKey();
            listOfGlobalKeys! // xoa dau va them cuoi
                ..removeAt(0)
                ..insert(listOfGlobalKeys!.length, key); // insert 1 key voi vao cuoi

            int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
            int f = Jiffy.parse("${date.year!}-${date.month!}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
            if (f == 1) f = 8;

            if (list.last - 1 == pointRight) {
                pages!.add(Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    key: key,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 7,
                        children: List.generate(n! + f! - 2, (index) {
                            // lay ra số ngày của tháng + các ô trống trước ngày 1
                            index += 1;
                            if (index > f! - 2) {
                                List<dynamic> lunar = convertSolar2Lunar(index - f! + 2, date.month,  date.year, 7.0);
                                bool isNow = DateTime.now().day == index - f! + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
                                bool isHoangDao = getNgayHoangDao(index - f! + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
                                bool isSelected = DateTime(pick!.year,pick!.month,pick!.day)== DateTime(date.year, date.month, index - f! + 2) /* time của ô */;
                                bool isSchedule =false;
                                if(items.length>0 && items[0]['Ngay']==(index - f! + 2)){
                                    isSchedule= true;
                                    items.removeAt(0);
                                }
                                return  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: TextButton(
                                        onPressed: () {
                                            DateTime now = DateTime.now();
                                            DateTime selectedDate = DateTime(date.year, date.month, index - f! + 2, now.hour, now.minute, now.second);
                                            setState(() {
                                                pick = selectedDate;
                                            });
                                            widget.onTap(selectedDate);
                                        },
                                        style: TextButton.styleFrom(padding: EdgeInsets.zero,  backgroundColor: isSelected? RootColor.cam_nhat : isNow ? Color(0xffff745c) : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                        child: Stack(
                                            children: [SizedBox(
                                                child: Column(
                                                    children: [
                                                        Expanded(
                                                            flex: 3,
                                                            child: Center(
                                                                child: Text(
                                                                    (index - f! + 2).toString(),
                                                                    style: TextStyle(fontSize: 16, color: isNow ? Colors.white : Colors.black),
                                                                ),
                                                            )),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                                lunar[0] == 1 ? "${lunar[0]}/${lunar[1]}" : lunar[0].toString(),
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: isNow
                                                                        ? Colors.white
                                                                        : isHoangDao
                                                                        ? Colors.green
                                                                        : Color(0xff7d7f86)),
                                                            )),
                                                    ],
                                                ),
                                            ),
                                                /*   vị trí có lịch trình thì có đấu   */
                                                isSchedule
                                                    ? Positioned(
                                                    top: -3,
                                                    right:-5,
                                                    child: Icon(Icons.bookmark_outlined,color: Colors.green,size: 20,)
                                                ):SizedBox()
                                                /* end vị trí có lịch trình thì có đấu */]
                                        )));
                            } else {
                                return TextButton(
                                    onPressed: () {},
                                    child: SizedBox(),
                                );
                            }
                        }),
                    ),
                ));
                pointRight = list.last;
            }
        });
    }

    @override
    void dispose() {
        _controller!.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
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
                        height: 320,
                        child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                                dragDevices: {
                                    PointerDeviceKind.mouse,
                                    PointerDeviceKind.touch,
                                },),
                        child: CustomScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _controller,
                            center: ValueKey(0),
                            physics: PageScrollPhysics(),
                            slivers: [
                                SliverFillViewport(delegate: SliverChildBuilderDelegate((context, index) {
                                    return pagesprev?[index] ?? null;
                                })),
                                SliverFillViewport(
                                    key: ValueKey(0),
                                    delegate: SliverChildBuilderDelegate((context, index) {
                                        return pages?[index] ?? null;
                                    }))
                              ],
                        ),),
                    )
            ]),
        );
    }


}
