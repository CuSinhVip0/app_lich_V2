String CalculateAge(DateTime birthDate) {
	final now = DateTime.now();
	int years = now.year - birthDate.year;
	int months = now.month - birthDate.month;
	int days = now.day - birthDate.day;

	if (months < 0 || (months == 0 && days < 0)) {
		years--;
		months += 12;
	}

	if (days < 0) {
		final monthAgo = DateTime(now.year, now.month - 1, birthDate.day);
		days = now.difference(monthAgo).inDays;
	}

	final weeks = days ~/ 7;
	days %= 7;

	return '$years tuổi, $months tháng, $weeks tuần, $days ngày';

}
