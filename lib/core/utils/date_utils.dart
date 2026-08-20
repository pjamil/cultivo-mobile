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
