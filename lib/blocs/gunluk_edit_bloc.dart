import 'dart:async';
import '../model/gunluk.dart';
import '../servis/db_firestore_api.dart';

class GunlukEditBloc {
  final DbApi dbApi;
  final bool ekle;
  Gunluk seciliGunluk;

  final StreamController<String> _tarihController =
      StreamController<String>.broadcast();
  Sink<String> get tarihEditChanged => _tarihController.sink;
  Stream<String> get tarihEdit => _tarihController.stream;

  final StreamController<String> _modController =
      StreamController<String>.broadcast();
  Sink<String> get modEditChanged => _modController.sink;
  Stream<String> get modEdit => _modController.stream;

  final StreamController<String> _notController =
      StreamController<String>.broadcast();
  Sink<String> get notEditChanged => _notController.sink;
  Stream<String> get notEdit => _notController.stream;

  final StreamController<String> _gunlukKaydetmeController =
      StreamController<String>.broadcast();
  Sink<String> get gunlukKaydetChanged => _gunlukKaydetmeController.sink;
  Stream<String> get gunlukKaydet => _gunlukKaydetmeController.stream;

  GunlukEditBloc(this.ekle, this.seciliGunluk, this.dbApi) {
    _duzenlemeDinleyecileriniBaslat()
        .then((bitti) => _getGunluk(ekle, seciliGunluk));
  }

  void dispose() {
    _tarihController.close();
    _notController.close();
    _modController.close();
    _gunlukKaydetmeController.close();
  }

  Future<bool> _duzenlemeDinleyecileriniBaslat() async {
    _tarihController.stream.listen((tarih) {
      seciliGunluk.tarih = tarih;
    });
    _modController.stream.listen((mod) {
      seciliGunluk.mod = mod;
    });
    _notController.stream.listen((not) {
      seciliGunluk.not = not;
    });
    _gunlukKaydetmeController.stream.listen((aksiyon) {
      if (aksiyon == 'Kaydet') {
        _gunlukKaydet();
      }
    });
    return true;
  }

  //eğer bu metot içine ekle doğru gelirse secili gunluk yeniden oluşturuluyor eğer false gelirse seçiligunluk bloc içerisine gelen gunluk değerlerini alıyor. resmin tamamına bakacak olursak kurucu dinleyicileri başlatır bütün stream kontrolleri başladıktan sonra getGunluk metodu duruma göre seciligunluk değişkenine değer atar. ardından akış kontrollerine bu değişkenleri ekleyerek sink yaratır.
  void _getGunluk(bool ekle, Gunluk gunluk) {
    if (ekle) {
      seciliGunluk = Gunluk();
      seciliGunluk.tarih = DateTime.now().toString();
      seciliGunluk.mod = 'Çok Memnun';
      seciliGunluk.not = '';
      seciliGunluk.uid = gunluk.uid;
    } else {
      seciliGunluk.tarih = gunluk.tarih;
      seciliGunluk.mod = gunluk.mod;
      seciliGunluk.not = gunluk.not;
    }
    tarihEditChanged.add(seciliGunluk.tarih);
    modEditChanged.add(seciliGunluk.mod);
    notEditChanged.add(seciliGunluk.not);
  }

  //gunluk kaydet metodu çağrıldığında yeni bir gunluk nesnesi yaratılır ve bu nesne secili gunluk nasıl şekillendiyse ona göre oluşur.sadece tarih formatlanır ve api tarafına bu günlük
  void _gunlukKaydet() {
    Gunluk gunluk = Gunluk(
      documentId: seciliGunluk.documentId,
      tarih: DateTime.parse(seciliGunluk.tarih).toIso8601String(),
      mod: seciliGunluk.mod,
      not: seciliGunluk.not,
      uid: seciliGunluk.uid,
    );
    ekle ? dbApi.gunlukEkle(gunluk) : dbApi.gunlukGuncelle(gunluk);
  }
}
