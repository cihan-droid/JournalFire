// Bu sınıf kimlik doğrulama için bir soyut sınıf yaratacak bu sınıftan türeyen sınıflar bu metotların hepsini uygulamak zorundadır. bu yöntem bloc mimarisini kullanırken bloc yapısını platformdan bağımsız hale getirebilmek için gereklidir.
abstract class KimlikDogrulamaApi {
  getFirebaseAuth();
  Future<String> anlikKullaniciId();
  Future<void> cikisYap();
  Future<String> mailAdresiveSifreyleGirisYap({String ePosta, String sifre});
  Future<String> mailAdresiveSifreyleKullaniciOlustur(
      {String ePosta, String sifre});
  Future<void> emailDogrulamaGonder();
  Future<bool> emailDogrulanmisMi();
}
