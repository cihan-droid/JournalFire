import 'dart:async';
import '../model/gunluk.dart';
import '../servis/db_firestore_api.dart';

class GunlukEditBloc {
  final DbApi dbApi;
  final bool ekle;
  Gunluk seciliGunluk;

  GunlukEditBloc(this.ekle, this.seciliGunluk, this.dbApi) {
    _dinleyicileriBaslat().then((finished) => _getGunluk(ekle, seciliGunluk));
  }

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
  final StreamController<String> _gunlukKaydetController =
      StreamController<String>.broadcast();
  Sink<String> get gunlukKaydetChanged => _gunlukKaydetController.sink;
  Stream<String> get gunlukKaydet => _gunlukKaydetController.stream;

  void dispose() {
    _tarihController.close();
    _modController.close();
    _notController.close();
    _gunlukKaydetController.close();
  }

  Future<bool> _dinleyicileriBaslat() async {
    _tarihController.stream.listen((tarih) {
      seciliGunluk.tarih = tarih;
    });
    _modController.stream.listen((mod) {
      seciliGunluk.mod = mod;
    });
    _notController.stream.listen((not) {
      seciliGunluk.not = not;
    });
    _gunlukKaydetController.stream.listen((action) {
      if (action == 'Kaydet') {
        _gunlukKaydet();
      }
    });
    return true;
  }

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
