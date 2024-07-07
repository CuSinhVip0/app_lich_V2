
String FormatTimeToString(Duration duration) {
	if (duration.inDays > 0) {
		return '${duration.inDays} ngày trước';
	} else if (duration.inHours > 0) {
		return '${duration.inHours} giờ trước';
	} else if (duration.inMinutes > 0) {
		return '${duration.inMinutes} phút trước';
	} else {
		return '${duration.inSeconds} giây trước';
	}
}