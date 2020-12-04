import 'dart:async';
import '../servis/authentication_api.dart';
import '../servis/db_firestore_api.dart';
import '../model/gunluk.dart';

class HomeBloc {
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;

  final StreamController<List<Gunluk>> _gunlukController =
      StreamController<List<Gunluk>>.broadcast();
  Sink<List<Gunluk>> get _gunlukListesiEkle => _gunlukController.sink;
  Stream<List<Gunluk>> get gunlukListesi => _gunlukController.stream;

  final StreamController<Gunluk> _gunlukSilmeController =
      StreamController<Gunluk>.broadcast();
  Sink<Gunluk> get gunlukSil => _gunlukSilmeController.sink;

  HomeBloc({this.dbApi, this.authenticationApi}) {
    _dinleyecileriBaslat();
  }

  void dispose() {
    _gunlukController.close();
    _gunlukSilmeController.close();
  }

  void _dinleyecileriBaslat() {
    //firestoredan günlük kayıtlarını getirecek ama firestore da tutulduğu gibi document olarak değil List<Gunluk> olarak getirecek
    authenticationApi.getFirebaseAuth().currentUser().then((user) {
      dbApi.getGunlukListesi(user.uid).listen((gunlukDocs) {
        _gunlukListesiEkle.add(gunlukDocs);
      });

      _gunlukSilmeController.stream.listen((gunluk) {
        dbApi.gunlukSil(gunluk);
      });
    });
  }
}
