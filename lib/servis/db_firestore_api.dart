import '../model/gunluk.dart';

//kimlik doğrulama sınıfı gibi bu sınıfta da metotları tanımlarsınız ama metotlar içerisinde kod içermez sadece bu sınıftan türeyen sınıflara bu metotları zorunlu tutar
abstract class DbApi {
  Stream<List<Gunluk>> getGunlukListesi(String uid);
  Future<Gunluk> getGunluk(String documentId);
  Future<bool> gunlukEkle(Gunluk gunluk);
  void gunlukGuncelle(Gunluk gunluk);
  void transactionIleGunlukGuncelle(Gunluk gunluk);
  void gunlukSil(Gunluk gunluk);
}
