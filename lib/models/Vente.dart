import 'package:cloud_firestore/cloud_firestore.dart';

class Vente {
  String key;
  String clientRef;
  String prixProduit;
  String prospect;
  int status;

  Vente(this.clientRef, this.prixProduit, this.prospect, this.status);

  Vente.fromSnapshot(DocumentSnapshot snapshot) :
    key = snapshot.documentID,
    clientRef = snapshot.data["clientRef"],
    prixProduit = snapshot.data["prixProduit"],
    prospect = snapshot.data["prospect"],
    status = snapshot.data["status"];

  toJson() {
    return {
      "clientRef": clientRef,
      "prixProduit": prixProduit,
      "prospect": prospect,
      "status": status
    };
  }
}