extension DateTimeExtension on DateTime {
  bool isToday(int timestamp) {
    final now = DateTime.now().toUtc();
    final then = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    return now.year == then.year &&
        now.month == then.month &&
        now.day == then.day;
  }
}

bool isToday(int timestampSeconds) {
  final now = DateTime.now().toUtc();
  final then = DateTime.fromMicrosecondsSinceEpoch(timestampSeconds * 1000);
  return now.year == then.year &&
      now.month == then.month &&
      now.day == then.day;
}

String relativeTimeString(int timestampSeconds) {
  final time = DateTime.fromMicrosecondsSinceEpoch(timestampSeconds * 1000);
  return isToday(timestampSeconds)
      ? 'Today at ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}'
      : '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year}';
}
