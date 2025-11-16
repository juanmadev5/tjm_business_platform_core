import 'package:intl/intl.dart';

/// Convert a String in format 125.000 to double
double parseGsToDouble(String amount) {
  final cleaned = amount.replaceAll('.', '').replaceAll(',', '');
  return double.tryParse(cleaned) ?? 0.0;
}

/// Convert a String with format "125.000"
String formatDoubleToGs(double amount) {
  final formatter = NumberFormat('#,###', 'es_PY'); // Paraguay format
  return formatter.format(amount).replaceAll(',', '.');
}
