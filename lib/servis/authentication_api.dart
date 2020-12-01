abstract class AuthenticationApi {
  getFirebaseAuth();
  Future<String> anlikKullaniciId();
  Future<void> cikisYap();
  Future<String> mailAdresiveSifreyleGirisYap({String email, String sifre});
  Future<String> mailAdresiveSifreyleKullaniciOlustur(
      {String email, String sifre});
  Future<void> emailDogrulamaGonder();
  Future<bool> emailDogrulanmisMi();
}
