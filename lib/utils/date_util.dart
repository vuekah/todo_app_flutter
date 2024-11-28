import 'package:intl/intl.dart';

extension DateStringExtensions on String {
  String? toFormattedDateString() {
    List<String> monthAbbreviations = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    String originalText = this; //  "November 21, 2024"

    List<String> parts = originalText.split(" ");

    String monthName = parts[0];
    String day = parts[1];
    String year = parts[2];

    // Kiểm tra nếu tên tháng là một trong các tháng đầy đủ
    int monthIndex = monthAbbreviations.indexOf(monthName.substring(0, 3));
    String monthAbbreviation = monthAbbreviations[monthIndex];

    // Trả về chuỗi với định dạng "MMM dd, yyyy"
    return "$monthAbbreviation $day $year";
  }

  String? toReverseFormattedDateString() {
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    String originalText =
        this; // Assuming the original string is "November 22, 2024"

    List<String> parts = originalText.split(" ");

    String monthName = parts[0]; // Full month name (e.g., "November")
    String day =
        parts[1].replaceAll(',', ''); // Remove comma from day (e.g., "22")
    String year = parts[2]; // Year (e.g., "2024")

    // Find the index of the month name
    int monthIndex = monthNames.indexOf(monthName);
    if (monthIndex == -1) {
      return null; // Return null if the month name is invalid
    }

    // Convert month index to 1-based (e.g., January -> 1, February -> 2, etc.)
    String month = (monthIndex + 1).toString().padLeft(2, '0');

    // Return the formatted string in "yyyy-MM-dd" format
    return "$year-$month-$day";
  }
}

extension ConvertDateExtensions on String {
  String formatTime() {
    String time = this;
    try {
      DateTime parsedTime = DateFormat("HH:mm").parse(time);
      DateFormat dateFormat = DateFormat("H:mm a");
      return dateFormat.format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  String convertTo24HourFormat() {
    return "${split(" ")[0]}:00";
  }
}
