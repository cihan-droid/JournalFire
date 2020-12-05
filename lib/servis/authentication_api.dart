abstract class YetkiApi {
  getFirebaseAuth();
  Future<String> anlikKullaniciId();
  Future<void> cikisYap();
  Future<String> mailAdresiveSifreyleGirisYap({String ePosta, String sifre});
  Future<String> mailAdresiveSifreyleKullaniciOlustur(
      {String ePosta, String sifre});
  Future<void> emailDogrulamaGonder();
  Future<bool> emailDogrulanmisMi();
}
