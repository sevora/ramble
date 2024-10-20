const List<Map<String, dynamic>> units = [
  {'label': 'year', 'seconds': 31536000},
  {'label': 'month', 'seconds': 2592000},
  {'label': 'week', 'seconds': 604800},
  {'label': 'day', 'seconds': 86400},
  {'label': 'hour', 'seconds': 3600},
  {'label': 'min', 'seconds': 60},
  {'label': 'sec', 'seconds': 1}
];

/**
 * Helper function to get the largest unit and interval
 * to use for calculating time difference.
 */
Map<String, dynamic> calculateTimeDifference(int time) {
  for (var unit in units) {
    int interval = (time / unit['seconds']).floor();
    if (interval >= 1) {
      return {'interval': interval, 'unit': unit['label']};
    }
  }
  return {'interval': 0, 'unit': ''};
}

/**
 * Use this to convert a date to the relative time.
 * @param date the date to convert
 * @returns a string
 */
String timeAgo(DateTime date) {
  final now = DateTime.now();
  final differenceInSeconds = now.difference(date).inSeconds;
  final result = calculateTimeDifference(differenceInSeconds);
  final interval = result['interval'];
  final unit = result['unit'];
  final suffix = interval == 1 ? '' : 's';
  return '$interval $unit$suffix ago';
}