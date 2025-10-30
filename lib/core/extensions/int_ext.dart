import 'package:intl/intl.dart';

enum CURRENCY_CODES {
  PYG,
  USD,
  BRL,
}

enum UNIT_SYSTEM_CODES {
  m,
  km,
  imperial,
}

extension IntExtension on int {
  String toAmountWithCurencyString(String currency,
      {bool showCurrencySymbol = true}) {
    switch (currency) {
      case 'PYG':
        final format = NumberFormat.currency(
          locale: 'es_PY', // Paraguay locale
          symbol: 'Gs.', // Guaraní symbol
          decimalDigits: 0, // No decimal places
        );
        if (!showCurrencySymbol) {
          return format
              .format(this)
              .replaceAll(format.currencySymbol, '')
              .trim();
        }
        return '${format.currencySymbol} ${format.format(this).replaceAll(format.currencySymbol, '').trim()}';
      case 'USD':
        final format = NumberFormat.currency(
          locale: 'es_PY', // Paraguay locale
          symbol: 'USD', // Dollar symbol
          decimalDigits: 2, // Two decimal places
        );
        if (!showCurrencySymbol) {
          return format
              .format(this)
              .replaceAll(format.currencySymbol, '')
              .trim();
        }
        return '${format.currencySymbol} ${format.format(this).replaceAll(format.currencySymbol, '').trim()}';
      case 'BRL':
        final format = NumberFormat.currency(
          locale: 'es_PY', // Paraguay locale
          symbol: 'BRL', // Real symbol
          decimalDigits: 2, // Two decimal places
        );
        if (!showCurrencySymbol) {
          return format
              .format(this)
              .replaceAll(format.currencySymbol, '')
              .trim();
        }
        return '${format.currencySymbol} ${format.format(this).replaceAll(format.currencySymbol, '').trim()}';
      case 'EUR':
        final format = NumberFormat.currency(
          locale: 'es_PY', // Paraguay locale
          symbol: 'EUR', // Euro symbol
          decimalDigits: 2, // Two decimal places
        );
        if (!showCurrencySymbol) {
          return format
              .format(this)
              .replaceAll(format.currencySymbol, '')
              .trim();
        }
        return '${format.currencySymbol} ${format.format(this).replaceAll(format.currencySymbol, '').trim()}';
      default:
        // Default return if currency is not handled
        return toString();
    }
  }

  String toDistanceWithSystemUnit(String unitSystem,
      {bool showCurrencySymbol = true}) {
    switch (unitSystem) {
      case 'm':
        return '${NumberFormat.decimalPattern('es_PY').format(this)} $unitSystem ';
      case 'km':
        return '${NumberFormat.decimalPattern('es_PY').format(this)} $unitSystem';
      case 'imperial':
        return NumberFormat.decimalPattern('en_US').format(this);
      default:
        // Default return if currency is not handled
        return toString();
    }
  }
}
