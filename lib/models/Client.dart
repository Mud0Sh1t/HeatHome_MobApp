import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String key;
  String name;
  String city;
  String address;
  String prixProduit;
  String prospect;
  int status;

  Client(this.name, this.city, this.address, this.prixProduit, this.prospect, this.status);

  Client.fromSnapshot(DocumentSnapshot snapshot) :
    key = snapshot.documentID,
    name = snapshot.data["name"],
    city = snapshot.data["city"],
    address = snapshot.data["address"],
    prixProduit = snapshot.data["prixProduit"],
    prospect = snapshot.data["prospect"],
    status = snapshot.data["status"];

  toJson() {
    return {
      "name": name,
      "city": city,
      "address": address,
      "prixProduit": prixProduit,
      "prospect": prospect,
      "status": status
    };
  }
}