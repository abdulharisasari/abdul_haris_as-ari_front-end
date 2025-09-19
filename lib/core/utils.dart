
import 'package:intl/intl.dart';


class Utils {
  static String formatCurrency(int amount, {String symbol = 'Rp. ',String locale = 'id_ID',int decimalDigits = 0, }) {
    final formatter = NumberFormat.currency( locale: locale, symbol: symbol, decimalDigits: decimalDigits);
    return formatter.format(amount);
  }
}