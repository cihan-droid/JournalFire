import 'dart:async';
import '../servis/authentication_api.dart';

class YetkiBloc {
  final YetkiApi yetkiApi;
  final StreamController<String> _yetkiKontrolor = StreamController<String>();
  Sink<String> get kullaniciEkleSinki => _yetkiKontrolor.sink;
  Stream<String> get kullaniciAkisi => _yetkiKontrolor.stream;

  final StreamController<bool> _kullaniciCikisKontrolor =
      StreamController<bool>();
  Sink<bool> get kullaniciCikisSinki => _kullaniciCikisKontrolor.sink;
  Stream<bool> get kullaniciCikisAkisi => _kullaniciCikisKontrolor.stream;

  YetkiBloc({this.yetkiApi}) {
    onYetkiDegisti();
  }

  void dispose() {
    _yetkiKontrolor.close();
    _kullaniciCikisKontrolor.close();
  }

  void onYetkiDegisti() {
    yetkiApi.getFirebaseAuth().onAuthStateChanged.listen((kullanici) {
      final String uid = kullanici != null ? kullanici.uid : null;
      kullaniciEkleSinki.add(uid);
    });
    _kullaniciCikisKontrolor.stream.listen((cikis) {
      if (cikis == true) {
        _cikisYap();
      }
    });
  }

  void _cikisYap() {
    yetkiApi.cikisYap();
  }
}
