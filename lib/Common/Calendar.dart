import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../utils/lunar_solar_utils.dart';

class Calendar extends StatefulWidget {
  Function handle;
  DateTime selectedD;
  Calendar(this.handle,this.selectedD);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int? addY;
  int? addM;
  int? addD;
  int? _initIndex;
  List<int> listnext = [0, 1, 2];
  List<int> listprev = [-1, -2];
  List<int> list = [-2, -1, 0, 1, 2];
  int pointLeft = -2; // diem them item
  int pointRight = 2; // diem them item
  DateTime? pick;
  ScrollController? _controller; // controller của scrollview
  List<Widget>? pages; // 2 tháng kế tiếp + tháng hiện tại
  List<Widget>? pagesprev; // 2 tháng kế trc
  List<GlobalKey>? listOfGlobalKeys; // key cho cac bang

  @override
  void initState() {
    pick = DateTime.now();
    addY = DateTime.now().year; // nam hien tai
    addD = DateTime.now().day; // ngay hien tai
    addM = DateTime.now().month; // thang hien tai
    _initIndex = 0; // vi tri cua page view
    _controller = ScrollController();

    listOfGlobalKeys = List.generate(list.length, (index) {
      return GlobalKey();
    });

    pages = List.generate(listnext.length, (index) {
      GlobalKey key = listOfGlobalKeys![index + listprev.length];
      DateTime date = DateTime(addY!, addM! + listnext[index], addD!);
      int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
      int f = Jiffy.parse("${date.year!}-${date.month!}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
      if (f == 1) f = 8;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        key: key,
        child: GridView.count(
          crossAxisCount: 7,
          children: List.generate(n! + f! - 2, (index) {
            // lay ra số ngày của tháng + các ô trống trước ngày 1
            index += 1;
            if (index > f! - 2) {
              List<dynamic> lunar = convertSolar2Lunar(index - f! + 2, date.month,  date.year, 7.0);
              bool isNow = DateTime.now().day == index - f! + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
              bool isHoangDao = getNgayHoangDao(index - f! + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;

              return  Padding(
                  padding: EdgeInsets.all(2),
                  child: TextButton(
                      onPressed: () {
                        DateTime now = DateTime.now();
                        DateTime selectedDate = DateTime(date.year, date.month, index - f! + 2, now.hour, now.minute, now.second);
                        setState(() {
                          pick = selectedDate;
                        });
                        widget.handle(selectedDate);
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero,  backgroundColor: isNow ? Color(0xffff745c) : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Text(
                                  (index - f! + 2).toString(),
                                  style: TextStyle(fontSize: 16, color: isNow ? Colors.white : Colors.black),
                                )),
                            Expanded(
                                flex: 3,
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
                      )));
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
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        key: key,
        child: GridView.count(
          crossAxisCount: 7,
          children: List.generate(n! + f! - 2, (index) {
            // lay ra số ngày của tháng + các ô trống trước ngày 1
            index += 1;
            if (index > f! - 2) {
              List<dynamic> lunar = convertSolar2Lunar(index - f! + 2, date.month,  date.year, 7.0);
              bool isNow = DateTime.now().day == index - f! + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
              bool isHoangDao = getNgayHoangDao(index - f! + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
              return  Padding(
                  padding: EdgeInsets.all(2),
                  child: TextButton(
                      onPressed: () {
                        DateTime now = DateTime.now();
                        DateTime selectedDate = DateTime(date.year, date.month, index - f! + 2, now.hour, now.minute, now.second);
                        setState(() {
                          pick = selectedDate;
                        });
                        widget.handle(selectedDate);
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero,  backgroundColor: isNow ? Color(0xffff745c) : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Text(
                                  (index - f! + 2).toString(),
                                  style: TextStyle(fontSize: 16, color: isNow ? Colors.white : Colors.black),
                                )),
                            Expanded(
                                flex: 3,
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
                      )));
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

  void pageprev() {
    setState(() {
      list // xoa cuoi va them dau
        ..insert(0, list.first - 1)
        ..removeLast();
      _initIndex = _initIndex! - 1; // giam vi tri cua page view di 1
      GlobalKey key = GlobalKey();
      listOfGlobalKeys!
        ..insert(0, key) // insert 1 key voi vao dau
        ..removeLast();
      DateTime date = DateTime(addY!, addM! + list.first, addD!);
      int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
      int f = Jiffy.parse("${date.year!}-${date.month!}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
      if (f == 1) f = 8;
      if (list.first + 1 == pointLeft) {
        pagesprev!.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            key: key,
            child: GridView.count(
              crossAxisCount: 7,
              children: List.generate(n! + f! - 2, (index) {
                // lay ra số ngày của tháng + các ô trống trước ngày 1
                index += 1;
                if (index > f! - 2) {
                  List<dynamic> lunar = convertSolar2Lunar(index - f! + 2, date.month,  date.year, 7.0);
                  bool isNow = DateTime.now().day == index - f! + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
                  bool isHoangDao = getNgayHoangDao(index - f! + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
                  return  Padding(
                      padding: EdgeInsets.all(2),
                      child: TextButton(
                          onPressed: () {
                            DateTime now = DateTime.now();
                            DateTime selectedDate = DateTime(date.year, date.month, index - f! + 2, now.hour, now.minute, now.second);
                            setState(() {
                              pick = selectedDate;
                            });
                            widget.handle(selectedDate);
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero,  backgroundColor: isNow ? Color(0xffff745c) : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: SizedBox(
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      (index - f! + 2).toString(),
                                      style: TextStyle(fontSize: 16, color: isNow ? Colors.white : Colors.black),
                                    )),
                                Expanded(
                                    flex: 3,
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
                          )));
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

  void pagenext() {
    setState(() {
      list // xoa dau va them cuoi
        ..removeAt(0)
        ..insert(list.length, list.last + 1);
      _initIndex = _initIndex! + 1; // tang vi tri cua page view len 1
      GlobalKey key = GlobalKey();
      listOfGlobalKeys! // xoa dau va them cuoi
        ..removeAt(0)
        ..insert(listOfGlobalKeys!.length, key); // insert 1 key voi vao cuoi
      DateTime date = DateTime(addY!, addM! + list.last, addD!);

      int n = DateTime(date.year, date.month + 1, 0).day; // so ngay trong 1 thang
      int f = Jiffy.parse("${date.year!}-${date.month!}-1").dayOfWeek; // ngay dau tien cua thang la ngay nao trong tuan
      if (f == 1) f = 8;

      if (list.last - 1 == pointRight) {
        pages!.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          key: key,
          child: GridView.count(
            crossAxisCount: 7,
            children: List.generate(n! + f! - 2, (index) {
              // lay ra số ngày của tháng + các ô trống trước ngày 1
              index += 1;
              if (index > f! - 2) {
                List<dynamic> lunar = convertSolar2Lunar(index - f! + 2, date.month,  date.year, 7.0);
                bool isNow = DateTime.now().day == index - f! + 2 && DateTime.now().month == date.month && DateTime.now().year ==  date.year;
                bool isHoangDao = getNgayHoangDao(index - f! + 2, date.month,  date.year) == "Ngày Hoàng Đạo" ? true : false;
                return  Padding(
                    padding: EdgeInsets.all(2),
                    child: TextButton(
                        onPressed: () {
                          DateTime now = DateTime.now();
                          DateTime selectedDate = DateTime(date.year, date.month, index - f! + 2, now.hour, now.minute, now.second);
                          setState(() {
                            pick = selectedDate;
                          });
                          widget.handle(selectedDate);
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero,  backgroundColor: isNow ? Color(0xffff745c) : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                    (index - f! + 2).toString(),
                                    style: TextStyle(fontSize: 16, color: isNow ? Colors.white : Colors.black),
                                  )),
                              Expanded(
                                  flex: 3,
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
      width: 387,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.shade500, spreadRadius: 1, blurRadius: 15, offset: Offset(0, 2)),
      ]),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Text(pick.toString()),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(0xffff745c),
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      _controller?.animateTo((_controller!.offset - 387.4), duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
                    },
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                    ),
                  )),
              Expanded(flex: 2, child: Text("Tháng ${DateTime(addY!, addM! + list[2], addD!).month} - ${DateTime(addY!, addM! + list[2], addD!).year}", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16))),
              Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      _controller?.animateTo((_controller!.offset + 387.4), duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
                    },
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Expanded(flex: 1, child: Text("T2", textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text("T3", textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text("T4", textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text("T5", textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text("T6", textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text("T7", textAlign: TextAlign.center)),
              Expanded(
                  flex: 1,
                  child: Text(
                    "CN",
                    textAlign: TextAlign.center,
                  )),
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
              },
            ),
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              center: ValueKey(0),
              physics: PageScrollPhysics(),
              slivers: [
                SliverFillViewport(delegate: SliverChildBuilderDelegate((context, index) {
                  return pagesprev![index];
                })),
                SliverFillViewport(
                    key: ValueKey(0),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return pages![index];
                    }))
              ],
            ),
          ),
        )
      ]),
    );
  }


}
