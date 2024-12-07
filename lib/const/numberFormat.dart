import 'package:intl/intl.dart';

extension IntExtension on int {
  String toThousandSeparated() {
    return NumberFormat('#,###').format(this);
  }
}