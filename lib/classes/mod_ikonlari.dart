import 'package:flutter/material.dart';

class ModIkon {
  final String baslik;
  final Color renk;
  final double rotasyon;
  final IconData ikon;
  const ModIkon({this.baslik, this.renk, this.rotasyon, this.ikon});
}

const List<ModIkon> _modIkonListesi = const <ModIkon>[
  const ModIkon(
      baslik: 'Çok Memnun',
      renk: Colors.amber,
      rotasyon: 0.4,
      ikon: Icons.sentiment_very_satisfied),
  const ModIkon(
      baslik: 'Memnun',
      renk: Colors.green,
      rotasyon: 0.2,
      ikon: Icons.sentiment_satisfied),
  const ModIkon(
      baslik: 'Normal',
      renk: Colors.grey,
      rotasyon: 0.0,
      ikon: Icons.sentiment_neutral),
  const ModIkon(
      baslik: 'Üzgün',
      renk: Colors.cyan,
      rotasyon: -0.2,
      ikon: Icons.sentiment_dissatisfied),
  const ModIkon(
      baslik: 'Çok Üzgün',
      renk: Colors.red,
      rotasyon: -0.4,
      ikon: Icons.sentiment_very_dissatisfied),
];
