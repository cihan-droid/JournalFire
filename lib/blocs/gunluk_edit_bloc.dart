import 'dart:async';
import '../model/gunluk.dart';
import '../servis/db_firestore_api.dart';

class GunlukEditBloc {
  final DbApi dbApi;
  final bool ekle;
  Gunluk seciliGunluk;

  final StreamController<String> _tarihKontrolor =
      StreamController<String>.broadcast();
  Sink<String> get tarihDuzenlemeDegistiSinki => _tarihKontrolor.sink;
  Stream<String> get tarihDuzenlemeAkisi => _tarihKontrolor.stream;

  final StreamController<String> _modKontrolor =
      StreamController<String>.broadcast();
  Sink<String> get modDuzenlemeDegistiSinki => _modKontrolor.sink;
  Stream<String> get modDuzenlemeAkisi => _modKontrolor.stream;

  final StreamController<String> _notController =
      StreamController<String>.broadcast();
  Sink<String> get notDuzenlemeDegistiSinki => _notController.sink;
  Stream<String> get notDuzenlemeAkisi => _notController.stream;

  final StreamController<String> _gunlukKaydetmeController =
      StreamController<String>.broadcast();
  Sink<String> get gunlukKaydetDegistiSinki => _gunlukKaydetmeController.sink;
  Stream<String> get gunlukKaydetAkisi => _gunlukKaydetmeController.stream;

  GunlukEditBloc(this.ekle, this.seciliGunluk, this.dbApi) {
    _duzenlemeDinleyecileriniBaslat()
        .then((bitti) => _getGunluk(ekle, seciliGunluk));
  }

  void dispose() {
    _tarihKontrolor.close();
    _notController.close();
    _modKontrolor.close();
    _gunlukKaydetmeController.close();
  }

  Future<bool> _duzenlemeDinleyecileriniBaslat() async {
    _tarihKontrolor.stream.listen((tarih) {
      seciliGunluk.tarih = tarih;
    });
    _modKontrolor.stream.listen((mod) {
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
    tarihDuzenlemeDegistiSinki.add(seciliGunluk.tarih);
    modDuzenlemeDegistiSinki.add(seciliGunluk.mod);
    notDuzenlemeDegistiSinki.add(seciliGunluk.not);
  }

  //gunluk kaydet metodu çağrıldığında yeni bir gunluk nesnesi yaratılır ve bu nesne secili gunluk nasıl şekillendiyse ona göre oluşur.sadece tarih formatlanır ve api tarafına bu günlük
  void _gunlukKaydet() {
    Gunluk gunluk = Gunluk(
      documentID: seciliGunluk.documentID,
      tarih: DateTime.parse(seciliGunluk.tarih).toIso8601String(),
      mod: seciliGunluk.mod,
      not: seciliGunluk.not,
      uid: seciliGunluk.uid,
    );
    ekle ? dbApi.gunlukEkle(gunluk) : dbApi.gunlukGuncelle(gunluk);
  }
}
