class Gunluk {
  String documentID;
  String tarih;
  String mod;
  String not;
  String uid;

  Gunluk({this.documentID, this.mod, this.not, this.tarih, this.uid});

  factory Gunluk.fromDoc(dynamic doc) => Gunluk(
      documentID: doc.documentID,
      tarih: doc["tarih"],
      mod: doc["mod"],
      not: doc["not"],
      uid: doc["uid"]);
}
