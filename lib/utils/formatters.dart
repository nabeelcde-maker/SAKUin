String rupiah(num value, {bool withSign = false, int decimals = 0}) {
  final negative = value < 0;
  final absolute = value.abs();
  final whole = absolute.truncate().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  var text = 'Rp $buffer';
  if (decimals > 0) {
    final fraction = ((absolute - absolute.truncate()) * 100).round();
    text += ',$fraction'.padRight(decimals + 1, '0');
  }
  if (withSign) text = '${negative ? '−' : '+'}$text';
  return text;
}

/// Compact form used in tight places (never "1.000k" — that was a bug in the
/// original design: 1.000k should read 1.000.000).
String rupiahCompact(num value) {
  if (value.abs() >= 1000000000) {
    return 'Rp ${(value / 1000000000).toStringAsFixed(1).replaceAll('.', ',')} M';
  }
  if (value.abs() >= 1000000) {
    return 'Rp ${(value / 1000000).toStringAsFixed(1).replaceAll('.', ',')} jt';
  }
  return rupiah(value);
}

/// Indonesian decimal comma, e.g. 25,7%
String percent(double value, {int decimals = 1}) {
  return '${value.toStringAsFixed(decimals).replaceAll('.', ',')}%';
}

const _monthsShort = [
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
  'Dec',
];

const _monthsLong = [
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
  'December',
];

String monthYear(DateTime d) => '${_monthsShort[d.month - 1]} ${d.year}';

String shortDate(DateTime d) => '${d.day} ${_monthsShort[d.month - 1]} ${d.year}';

String longMonthYear(DateTime d) => '${_monthsLong[d.month - 1]} ${d.year}';

/// "Today, 13.15" — 24h clock, one consistent date style across the app.
String txnTime(DateTime d) {
  final now = DateTime.now();
  final clock =
      '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';
  final isToday =
      d.year == now.year && d.month == now.month && d.day == now.day;
  final yesterday =
      now.subtract(const Duration(days: 1));
  final isYesterday =
      d.year == yesterday.year && d.month == yesterday.month && d.day == yesterday.day;
  if (isToday) return 'Today, $clock';
  if (isYesterday) return 'Yesterday, $clock';
  return '${d.day} ${_monthsShort[d.month - 1]}, $clock';
}

String monthsRemaining(DateTime deadline) {
  final now = DateTime.now();
  var months = (deadline.year - now.year) * 12 + (deadline.month - now.month);
  if (months <= 0) return 'due this month';
  if (months == 1) return '1 month remaining';
  return '$months months remaining';
}
