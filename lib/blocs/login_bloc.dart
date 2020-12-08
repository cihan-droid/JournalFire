import 'dart:async';

import '../classes/validators.dart';
import '../servis/kimlik_dogrulama_api.dart';

class LoginBloc with Dogrulayicilar {
  final KimlikDogrulamaApi kimlikDogrulamaApi;
  String _eposta;
  String _sifre;
  bool _epostaDogru;
  bool _sifreDogru;

  final StreamController<String> _ePostaKontrolor =
      StreamController<String>.broadcast();
  Sink<String> get ePostaDegistiSinki => _ePostaKontrolor.sink;
  Stream<String> get ePostaAkisi =>
      _ePostaKontrolor.stream.transform(ePostaDogrula);

  final StreamController<String> _sifreKontrolor =
      StreamController<String>.broadcast();
  Sink<String> get sifreDegistiSinki => _sifreKontrolor.sink;
  Stream<String> get sifreAkisi =>
      _sifreKontrolor.stream.transform(sifreDogrula);

  final StreamController<bool> _loginHesapOlusturButonuAktiflemeKontrolor =
      StreamController<bool>.broadcast();
  Sink<bool> get loginHesapOlusturButonuAktiflemeDegistiSinki =>
      _loginHesapOlusturButonuAktiflemeKontrolor.sink;
  Stream<bool> get loginHesapOlusturButonuAktiflemeAkisi =>
      _loginHesapOlusturButonuAktiflemeKontrolor.stream;

  final StreamController<String> _loginYadaHesapOlusturButonuKontrolor =
      StreamController<String>();
  Sink<String> get loginYadaHesapOlusturButonuDegistiSinki =>
      _loginYadaHesapOlusturButonuKontrolor.sink;
  Stream<String> get loginYadaHesapOlusturButonuAkisi =>
      _loginYadaHesapOlusturButonuKontrolor.stream;

  final StreamController<String> _loginYadaHesapOlusturKontrolor =
      StreamController<String>();
  Sink<String> get loginYadaHesapOlusturDegistiSinki =>
      _loginYadaHesapOlusturKontrolor.sink;
  Stream<String> get loginYadaHesapOlusturAkisi =>
      _loginYadaHesapOlusturKontrolor.stream;

  LoginBloc({this.kimlikDogrulamaApi}) {
    _ePostaveSifreDogrulamaDinleyicileriniBaslat();
  }

  void dispose() {
    _sifreKontrolor.close();
    _ePostaKontrolor.close();
    _loginHesapOlusturButonuAktiflemeKontrolor.close();
    _loginYadaHesapOlusturButonuKontrolor.close();
    _loginYadaHesapOlusturKontrolor.close();
  }

  //bu metot loginbloc oluştuğu gibi dinleyicileri başlatır ve her email ve şifre değiştiğinde login create buton durumunu değiştirir.
  void _ePostaveSifreDogrulamaDinleyicileriniBaslat() {
    ePostaAkisi.listen((ePosta) {
      _eposta = ePosta;
      _epostaDogru = true;
      _loginHesapOlusturButonAktiflemeAkisiniGuncelle();
    }).onError((hata) {
      _eposta = '';
      _epostaDogru = false;
      _loginHesapOlusturButonAktiflemeAkisiniGuncelle();
    });
    sifreAkisi.listen((sifre) {
      _sifre = sifre;
      _sifreDogru = true;
      _loginHesapOlusturButonAktiflemeAkisiniGuncelle();
    }).onError((hata) {
      _sifre = '';
      _sifreDogru = false;
      _loginHesapOlusturButonAktiflemeAkisiniGuncelle();
    });
    loginYadaHesapOlusturAkisi.listen((aksiyon) {
      aksiyon == 'Login' ? _girisYap() : _hesapOlustur();
    });
  }

  void _loginHesapOlusturButonAktiflemeAkisiniGuncelle() {
    if (_epostaDogru == true && _sifreDogru == true) {
      loginHesapOlusturButonuAktiflemeDegistiSinki.add(true);
    } else {
      loginHesapOlusturButonuAktiflemeDegistiSinki.add(false);
    }
  }

  Future<String> _girisYap() async {
    String _sonuc = '';
    if (_epostaDogru && _sifreDogru) {
      await kimlikDogrulamaApi
          .mailAdresiveSifreyleGirisYap(ePosta: _eposta, sifre: _sifre)
          .then((kullanici) {
        _sonuc = 'Success';
      }).catchError((hata) {
        print('Login hatası: $hata');
        _sonuc = hata;
      });
      return _sonuc;
    } else {
      return 'ePosta ve şifre doğru değil';
    }
  }

  Future<String> _hesapOlustur() async {
    String _sonuc = '';
    if (_epostaDogru && _sifreDogru) {
      await kimlikDogrulamaApi
          .mailAdresiveSifreyleKullaniciOlustur(ePosta: _eposta, sifre: _sifre)
          .then((kullanici) {
        print('Kullanıcı oluşturuldu: $kullanici');
        _sonuc = 'Kullanıcı Oluşturuldu: $kullanici';
        kimlikDogrulamaApi
            .mailAdresiveSifreyleGirisYap(ePosta: _eposta, sifre: _sifre)
            .then((user) {})
            .catchError((hata) async {
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
