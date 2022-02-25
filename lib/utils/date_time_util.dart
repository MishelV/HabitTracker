class DateTimeUtil {
  static const DATE_FORMAT = 'yyyy-mm-dd hh:mm';

  DateTime getDateTime(String s) {
    final String date = s.split(' ')[0];
    final String time = s.split(' ')[1];

    final year = int.parse(date.split('-')[0]);
    final month = int.parse(date.split('-')[1]);
    final day = int.parse(date.split('-')[2]);
    final hour = int.parse(time.split(':')[0]);
    final minute = int.parse(time.split(':')[1]);
    return DateTime(year, month, day, hour, minute);
  }
}
