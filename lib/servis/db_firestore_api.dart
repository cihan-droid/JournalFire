import '../model/gunluk.dart';

abstract class DbApi {
  Stream<List<Gunluk>> getGunlukListesi(String uid);
  Future<Gunluk> getGunluk(String documentId);
  Future<bool> gunlukEkle(Gunluk gunluk);
  void gunlukGuncelle(Gunluk gunluk);
  void transactionIleGunlukGuncelle(Gunluk gunluk);
  void gunlukSil(Gunluk gunluk);
}
