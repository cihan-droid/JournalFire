import 'package:flutter/material.dart';

//mod ikonları bize o günkü durum ile ilgili ikon seçebilmemizi sağlayacak
//bu ikonların rengi ikonu ve rotasyonu duruma göre değişecek
// örneğin çok memnunsa sarı renkte olacak ve sağa doğru ikon rotate olacak
class ModIkonlari {
  final String baslik;
  final Color renk;
  final double rotasyon;
  final IconData ikon;

  const ModIkonlari({this.baslik, this.renk, this.rotasyon, this.ikon});

// bu metot bize başlığına göre ikonu getirmemize yarayacak. alttaki metotlarda aynı şekilde string olarak örneğin üzgün dediğimizde bize üzgünün ikonunu rengini ve rotasyonunu getirecek
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

//bu liste ikonların başlığına göre rengi rotasyonu ve ikonunun belirlerndiği listedir. bu listede aynı zamanda mod ikonu ekleyeceğimiz zaman karşımıza çıkacak
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
