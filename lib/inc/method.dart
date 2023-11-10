import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  String result = currencyFormat.format(amount);
  List<String> substrings = result.split(',');
  return substrings[0];
}
