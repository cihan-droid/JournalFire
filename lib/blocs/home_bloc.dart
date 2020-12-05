import 'dart:async';
import '../servis/authentication_api.dart';
import '../servis/db_firestore_api.dart';
import '../model/gunluk.dart';

class HomeBloc {
  final DbApi dbApi;
  final YetkiApi yetkiApi;

  final StreamController<List<Gunluk>> _gunlukListesiKontrolor =
      StreamController<List<Gunluk>>.broadcast();
  Sink<List<Gunluk>> get _gunlukListesiEkleSinki =>
      _gunlukListesiKontrolor.sink;
  Stream<List<Gunluk>> get gunlukListesiAkisi => _gunlukListesiKontrolor.stream;

  final StreamController<Gunluk> _gunlukSilmeKontrolor =
      StreamController<Gunluk>.broadcast();
  Sink<Gunluk> get gunlukSilmeSinki => _gunlukSilmeKontrolor.sink;

  HomeBloc({this.dbApi, this.yetkiApi}) {
    _dinleyecileriBaslat();
  }

  void dispose() {
    _gunlukListesiKontrolor.close();
    _gunlukSilmeKontrolor.close();
  }

  void _dinleyecileriBaslat() {
    //firestoredan günlük kayıtlarını getirecek ama firestore da tutulduğu gibi document olarak değil List<Gunluk> olarak getirecek
    yetkiApi.getFirebaseAuth().currentUser().then((kullanici) {
      dbApi.getGunlukListesi(kullanici.uid).listen((gunlukDocs) {
        _gunlukListesiEkleSinki.add(gunlukDocs);
      });

      _gunlukSilmeKontrolor.stream.listen((gunluk) {
        dbApi.gunlukSil(gunluk);
      });
    });
  }
}
