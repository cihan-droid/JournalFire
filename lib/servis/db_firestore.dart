import '../model/gunluk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  Firestore _firestore = Firestore.instance;
  String _gunlukKoleksiyonu = 'gunlukler';

  DbFirestoreService() {
    _firestore.settings(timestampsInSnapshotsEnabled: true);
  }

  //kullanıcya ait bütün günlük listesini alabilmek için kullandığımız metot
  @override
  Stream<List<Gunluk>> getGunlukListesi(String uid) {
    return _firestore
        .collection(_gunlukKoleksiyonu)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Gunluk> _gunlukDocs =
          snapshot.documents.map((doc) => Gunluk.fromDoc(doc)).toList();
      _gunlukDocs.sort((comp1, comp2) => comp2.tarih.compareTo(comp1.tarih));
      return _gunlukDocs;
    });
  }

  //gunluk ekleme için kullandığımız metot
  @override
  Future<bool> gunlukEkle(Gunluk gunluk) async {
    DocumentReference _documentReference = await _firestore
        .collection(_gunlukKoleksiyonu)
        .add({
      'tarih': gunluk.tarih,
      'mod': gunluk.mod,
      'not': gunluk.mod,
      'uid': gunluk.uid
    });
    return _documentReference.documentID != null;
  }

  @override
  void gunlukGuncelle(Gunluk gunluk) async {
    await _firestore
        .collection(_gunlukKoleksiyonu)
        .document(gunluk.documentId)
        .updateData({
      'tarih': gunluk.tarih,
      'mod': gunluk.mod,
      'not': gunluk.not
    }).catchError((hata) => print('Güncelleme yaparken hata oluştu: $hata'));
  }

  @override
  void gunlukSil(Gunluk gunluk) async {
    await _firestore
        .collection(_gunlukKoleksiyonu)
        .document(gunluk.documentId)
        .delete()
        .catchError((hata) => print('Silme sırasında bir hata oluştu: $hata'));
  }

  @override
  void transactionIleGunlukGuncelle(Gunluk gunluk) {
    DocumentReference _documentReference =
        _firestore.collection(_gunlukKoleksiyonu).document(gunluk.documentId);
    var gunlukData = {
      'tarih': gunluk.tarih,
      'mod': gunluk.mod,
      'not': gunluk.not,
    };
    _firestore.runTransaction((transaction) async {
      await transaction
          .update(_documentReference, gunlukData)
          .catchError((error) => print('Error updating: $error'));
    });
  }

  @override
  Future<Gunluk> getGunluk(String documentId) {
    return _firestore
        .collection(_gunlukKoleksiyonu)
        .document(documentId)
        .get()
        .then((documentSnapshot) {
      return Gunluk.fromDoc(documentSnapshot);
    });
  }
}
