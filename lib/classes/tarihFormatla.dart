import 'package:intl/intl.dart';

class TarihFormat {
  String tarihFormatlaYilAyGun(String date) {
    return DateFormat.yMMMd().format(DateTime.parse(date));
  }

  String tarihFormatlaGunNumarasi(String date) {
    return DateFormat.d().format(DateTime.parse(date));
  }

  String tarihFormatlaKisaGunAdi(String date) {
    return DateFormat.E().format(DateTime.parse(date));
  }
}
