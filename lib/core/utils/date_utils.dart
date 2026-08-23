/// Parse date string handling both ISO format (2025-01-15T00:00:00)
/// and simple format (2025-01-15)
DateTime? parseDate(dynamic value) {
  if (value == null || value.toString().isEmpty) return null;
  try {
    final str = value.toString();
    if (str.contains('T')) {
      return DateTime.parse(str);
    } else {
      return DateTime.parse('${str}T00:00:00');
    }
  } catch (e) {
    return null;
  }
}

/// Format date as yyyy-MM-dd (Spring LocalDate expected format)
String? formatDateOnly(DateTime? value) {
  if (value == null) return null;
  final m = value.month.toString().padLeft(2, '0');
  final d = value.day.toString().padLeft(2, '0');
  return '${value.year}-$m-$d';
}

/// Format datetime as ISO-8601 without milliseconds (Spring LocalDateTime
/// accepted format, ex: 2026-08-22T14:30:00)
String? formatDateTime(DateTime? value) {
  if (value == null) return null;
  final date = formatDateOnly(value);
  final h = value.hour.toString().padLeft(2, '0');
  final min = value.minute.toString().padLeft(2, '0');
  final s = value.second.toString().padLeft(2, '0');
  return '${date}T$h:$min:$s';
}
