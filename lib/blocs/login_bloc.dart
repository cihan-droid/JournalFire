import 'dart:async';
import '../classes/validators.dart';
import '../servis/authentication_api.dart';

class LoginBloc with Validators {
  final AuthenticationApi authenticationApi;
  String _email;
  String _sifre;
  bool _emailValid;
  bool _sifreValid;

  final StreamController<String> _emailController =
      StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final StreamController<String> _sifreController =
      StreamController<String>.broadcast();
  Sink<String> get sifreChanged => _sifreController.sink;
  Stream<String> get sifre => _sifreController.stream.transform(validateSifre);

  final StreamController<bool> _enableLoginCreateButtonController =
      StreamController<bool>.broadcast();
  Sink<bool> get enableLoginCreateButtonChanged =>
      _enableLoginCreateButtonController.sink;
  Stream<bool> get enableLoginCreateButton =>
      _enableLoginCreateButtonController.stream;

  final StreamController<String> _loginOrCreateButtonController =
      StreamController<String>();
  Sink<String> get loginOrCreateButtonChanged =>
      _loginOrCreateButtonController.sink;
  Stream<String> get loginOrCreateButton =>
      _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController =
      StreamController<String>();
  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  LoginBloc({this.authenticationApi}) {
    _mailveSifreDogruysaDinleyicileriBaslat();
  }

  void dispose() {
    _sifreController.close();
    _emailController.close();
    _enableLoginCreateButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();
  }

  void _mailveSifreDogruysaDinleyicileriBaslat() {
    email.listen((email) {
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((hata) {
      _email = '';
      _emailValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    sifre.listen((sifre) {
      _sifre = sifre;
      _sifreValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((hata) {
      _sifre = '';
      _sifreValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    loginOrCreate.listen((action) {
      action == 'Login' ? _girisYap() : _hesapOlustur();
    });
  }

  void _updateEnableLoginCreateButtonStream() {
    if (_emailValid == true && _sifreValid == true) {
      enableLoginCreateButtonChanged.add(true);
    } else {
      enableLoginCreateButtonChanged.add(false);
    }
  }

  Future<String> _girisYap() async {
    String _result = '';
    if (_emailValid && _sifreValid) {
      await authenticationApi
          .mailAdresiveSifreyleGirisYap(email: _email, sifre: _sifre)
          .then((user) {
        _result = 'Success';
      }).catchError((error) {
        print('Login hatası: $error');
        _result = error;
      });
      return _result;
    } else {
      return 'email ve şifre doğru değil';
    }
  }

  Future<String> _hesapOlustur() async {
    String _sonuc = '';
    if (_emailValid && _sifreValid) {
      await authenticationApi
          .mailAdresiveSifreyleKullaniciOlustur(email: _email, sifre: _sifre)
          .then((kullanici) {
        print('Kullanıcı oluşturuldu: $kullanici');
        _sonuc = 'Kullanıcı Oluşturuldu: $kullanici';
        authenticationApi
            .mailAdresiveSifreyleGirisYap(email: _email, sifre: _sifre)
            .then((user) {})
            .catchError((hata) async {
          print('Login error: $hata');
          _sonuc = hata;
        });
      }).catchError((hata) async {
        print('Kullanıcı ekleme hatası: $hata');
      });
      return _sonuc;
    } else {
      return 'Kullanıcı Oluşturulurken hata oldu';
    }
  }
}
