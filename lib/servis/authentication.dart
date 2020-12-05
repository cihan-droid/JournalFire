import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_api.dart';

class AuthenticationService implements YetkiApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  //kullanıcı giriş yapmışsa eğer geçerli kullanıcının id sini geri döner
  @override
  Future<String> anlikKullaniciId() async {
    FirebaseUser kullanici = await _firebaseAuth.currentUser();
    return kullanici.uid;
  }

  //geçerli kullanıcının çıkış yapması için metot
  @override
  Future<void> cikisYap() async {
    return _firebaseAuth.signOut();
  }

  //giriş yapmış kullanıcı için eposta doğrulaması metodu
  @override
  Future<void> emailDogrulamaGonder() async {
    FirebaseUser kullanici = await _firebaseAuth.currentUser();
    kullanici.sendEmailVerification();
  }

  //geçerli kullanıcın eposta adresini doğrulamış mı diye kullanılan metot
  @override
  Future<bool> emailDogrulanmisMi() async {
    FirebaseUser kullanici = await _firebaseAuth.currentUser();

    return kullanici.isEmailVerified;
  }

  //daha önce kayıt olmuş kullanıcının email ve şifreyle giriş yapması için kulllanılacak metot
  @override
  Future<String> mailAdresiveSifreyleGirisYap(
      {String ePosta, String sifre}) async {
    FirebaseUser kullanici = await _firebaseAuth.signInWithEmailAndPassword(
        email: ePosta, password: sifre);
    return kullanici.uid;
  }

  //email ve şifre ile yeni bir kullanıcı oluşturmak için kullanılacak metot
  @override
  Future<String> mailAdresiveSifreyleKullaniciOlustur(
      {String ePosta, String sifre}) async {
    FirebaseUser kullanici = await _firebaseAuth.createUserWithEmailAndPassword(
        email: ePosta, password: sifre);
    return kullanici.uid;
  }
}
