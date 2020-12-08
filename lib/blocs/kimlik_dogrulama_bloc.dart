import 'dart:async';
import '../servis/kimlik_dogrulama_api.dart';

class KimlikDogrulamaBloc {
  final KimlikDogrulamaApi kimlikDogrulamaApi;
  final StreamController<String> _kimlikDogrulamaKontrolor =
      StreamController<String>();
  Sink<String> get kullaniciEkleSinki => _kimlikDogrulamaKontrolor.sink;
  Stream<String> get kullaniciAkisi => _kimlikDogrulamaKontrolor.stream;

  final StreamController<bool> _kullaniciCikisKontrolor =
      StreamController<bool>();
  Sink<bool> get kullaniciCikisSinki => _kullaniciCikisKontrolor.sink;
  Stream<bool> get kullaniciCikisAkisi => _kullaniciCikisKontrolor.stream;

  KimlikDogrulamaBloc({this.kimlikDogrulamaApi}) {
    onKimlikDogrulamaDegisti();
  }

  void dispose() {
    _kimlikDogrulamaKontrolor.close();
    _kullaniciCikisKontrolor.close();
  }

  void onKimlikDogrulamaDegisti() {
    kimlikDogrulamaApi.getFirebaseAuth().onAuthStateChanged.listen((kullanici) {
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
    kimlikDogrulamaApi.cikisYap();
  }
}
