class Gunluk {
  String documentId;
  String tarih;
  String mod;
  String not;
  String uid;

  Gunluk({this.documentId, this.mod, this.not, this.tarih, this.uid});

  factory Gunluk.fromDoc(dynamic doc) => Gunluk(
      documentId: doc.documentID,
      tarih: doc["tarih"],
      mod: doc["mod"],
      not: doc["not"],
      uid: doc["uid"]);
}
