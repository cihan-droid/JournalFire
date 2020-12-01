import 'dart:async';
import '../servis/authentication_api.dart';
import '../servis/db_firestore_api.dart';
import '../model/gunluk.dart';

class HomeBloc {
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;

  final StreamController<List<Gunluk>> _gunlukController =
      StreamController<List<Gunluk>>.broadcast();
  Sink<List<Gunluk>> get _addListGunluk => _gunlukController.sink;
  Stream<List<Gunluk>> get listGunluk => _gunlukController.stream;

  final StreamController<Gunluk> _gunlukSilmeController =
      StreamController<Gunluk>.broadcast();
  Sink<Gunluk> get gunlukSil => _gunlukSilmeController.sink;

  HomeBloc(this.dbApi, this.authenticationApi) {
    _dinleyicileriBaslat();
  }

  void dispose() {
    _gunlukController.close();
    _gunlukSilmeController.close();
  }

/*homebloc sınıfı kurucusunda dinleyicileri başlatıyor ve bu metot geçerli kullanıcının
id sini alıyor ve bu ile dbapi soyut sınıfının gunlukleri getirme metodunu çağırıyor ve 
*/
  void _dinleyicileriBaslat() {
    authenticationApi.getFirebaseAuth().currentUser().then((kullanici) {
      dbApi.getGunlukListesi(kullanici.uid).listen((gunlukDocs) {
        _addListGunluk.add(gunlukDocs);
      });
      _gunlukSilmeController.stream.listen((gunluk) {
        dbApi.gunlukSil(gunluk);
      });
    });
  }
}
