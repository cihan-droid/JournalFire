import 'package:flutter/material.dart';

// Used for Data Entry to pick Mood
class ModIkonlari {
  final String baslik;
  final Color renk;
  final double rotasyon;
  final IconData ikon;

  const ModIkonlari({this.baslik, this.renk, this.rotasyon, this.ikon});

  IconData getModIkon(String mod) {
    return _modIkonList[_modIkonList.indexWhere((icon) => icon.baslik == mod)]
        .ikon;
  }

  Color getModRenk(String mod) {
    return _modIkonList[_modIkonList.indexWhere((icon) => icon.baslik == mod)]
        .renk;
  }

  double getModRotasyon(String mod) {
    return _modIkonList[_modIkonList.indexWhere((icon) => icon.baslik == mod)]
        .rotasyon;
  }

  List<ModIkonlari> getModIkonList() {
    return _modIkonList;
  }
}

const List<ModIkonlari> _modIkonList = const <ModIkonlari>[
  const ModIkonlari(
      baslik: 'Çok Memnun',
      renk: Colors.amber,
      rotasyon: 0.4,
      ikon: Icons.sentiment_very_satisfied),
  const ModIkonlari(
      baslik: 'Memnun',
      renk: Colors.green,
      rotasyon: 0.2,
      ikon: Icons.sentiment_satisfied),
  const ModIkonlari(
      baslik: 'Normal',
      renk: Colors.grey,
      rotasyon: 0.0,
      ikon: Icons.sentiment_neutral),
  const ModIkonlari(
      baslik: 'Üzgün',
      renk: Colors.cyan,
      rotasyon: -0.2,
      ikon: Icons.sentiment_dissatisfied),
  const ModIkonlari(
      baslik: 'Çok Üzgün',
      renk: Colors.red,
      rotasyon: -0.4,
      ikon: Icons.sentiment_very_dissatisfied),
];
