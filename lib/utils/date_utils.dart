
String getNameDayOfWeek(DateTime date) {
  if(date.weekday == DateTime.monday) {
    return "Thứ Hai";
  }
  if(date.weekday == DateTime.tuesday) {
    return "Thứ Ba";
  }
  if(date.weekday == DateTime.wednesday) {
    return "Thứ Bốn";
  }
  if(date.weekday == DateTime.thursday) {
    return "Thứ Năm";
  }
  if(date.weekday == DateTime.friday) {
    return "Thứ Sáu";
  }
  if(date.weekday == DateTime.saturday) {
    return "Thứ Bảy";
  }
    return "Chủ Nhật";
}

String getNameMonthLunarOfYear(int month) {
  if(month==1) {
    return "Tháng Giêng";
  }
  if(month==2) {
    return "Tháng Hai";
  }
  if(month==3) {
    return "Tháng Ba";
  }
  if(month==4) {
    return "Tháng Tư";
  }
  if(month==5) {
    return "Tháng Năm";
  }
  if(month==6) {
    return "Tháng Sáu";
  }
  if(month==7) {
    return "Tháng Bảy";
  }
  if(month==8) {
    return "Tháng Tám";
  }
  if(month==9) {
    return "Tháng Chín";
  }
  if(month==10) {
    return "Tháng Mười";
  }
  if(month==11) {
    return "Tháng Mười Một";
  }
  return "Tháng Chạp";
}

String getNameMonthOfYear(int month) {
  if(month==1) {
    return "Tháng Một";
  }
  if(month==2) {
    return "Tháng Hai";
  }
  if(month==3) {
    return "Tháng Ba";
  }
  if(month==4) {
    return "Tháng Tư";
  }
  if(month==5) {
    return "Tháng Năm";
  }
  if(month==6) {
    return "Tháng Sáu";
  }
  if(month==7) {
    return "Tháng Bảy";
  }
  if(month==8) {
    return "Tháng Tám";
  }
  if(month==9) {
    return "Tháng Chín";
  }
  if(month==10) {
    return "Tháng Mười";
  }
  if(month==11) {
    return "Tháng Mười Một";
  }
  return "Tháng Mười Hai";
}

DateTime increaseDay(DateTime date) {
  var day = date.day + 1;
  var month = date.month;
  var year = date.year;
  var maxDayThisMonth = lastDayOfMonth(date);
  if(maxDayThisMonth.day == day) {
    day = 1;
    month ++;
    if(date.month == 12) {
      month = 1;
      year ++;
    }
  }

  return new DateTime(year, month, day, date.hour, date.minute, date.second);
}

DateTime decreaseDay(DateTime date) {
  var day = date.day - 1;
  var month = date.month;
  var year = date.year;
  if(date.day == 1) {
    var maxDayPreviousMonth = lastDayOfPreviousMonth(date);
    day = maxDayPreviousMonth.day;
    month = maxDayPreviousMonth.month;
    year = maxDayPreviousMonth.year;
  }

  return new DateTime(year, month, day, date.hour, date.minute, date.second);
}

DateTime lastDayOfMonth(DateTime date) {
  if (date.month < 12) {
    return new DateTime(date.year, date.month + 1, 0);
  }
  return new DateTime(date.year + 1, 1, 0);
}

DateTime lastDayOfPreviousMonth(DateTime date) {
  return new DateTime(date.year, date.month, 0);
}

