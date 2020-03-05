import 'dart:ui';
import 'package:HeatHome/models/Client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormScreen extends StatelessWidget {

  final databaseReference = Firestore.instance;

  FormScreen({Key key, this.customer, this.userMail}): super(key: key);
  
  final Client customer;
  final String userMail;

  final _formKey = GlobalKey<FormState>();

  String _name;
  String _city;
  String _address;
  String _prixProduit;
  
  @override
  Widget build(BuildContext context) {
    print(this.userMail);

    String msg = (customer != null) ? "Update customer" : "Add a customer";

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('HeatHome form'),
      ),
      body: new SingleChildScrollView(
          padding: new EdgeInsets.all(25.0),
          child: Center(
          child: Column(
            children : <Widget>[
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    Text("Name :"),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter name',
                      ),
                      initialValue: (customer != null) ? customer.name : null,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      onSaved: (input) => _name = input,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    Text("City :"),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter City',
                      ),
                      initialValue: (customer != null) ? customer.city : null,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      },
                      onSaved: (input) => _city = input,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    Text("Adress :"),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Adress',
                      ),
                      initialValue: (customer != null) ? customer.address : null,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter adress';
                        }
                        return null;
                      },
                      onSaved: (input) => _address = input,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    Text("Price :"),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Price',
                      ),
                      initialValue: (customer != null) ? customer.prixProduit : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      validator: (value) {
                        int number = num.parse(value);
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }else if(number > 100){
                          return 'Please enter a price between 0 - 100';
                        }
                        return null;
                      },
                      onSaved: (input) => _prixProduit = input,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if(customer != null){
                              QuerySnapshot vente = await databaseReference.collection("ventes")
                              .where("clientRef", isEqualTo: "/clients/"+customer.key).getDocuments();

                              String idVente = vente.documents.first.documentID;
                              
                              var dataClientUpdate = {
                                "name": _name,
                                "city": _city,
                                "address": _address,
                                "prixProduit": _prixProduit,
                                "proscpect": customer.prospect,
                                "status": 0
                              };
                              var dataVenteUpdate = {
                                "clientRef": "/clients/"+customer.key,
                                "prixProduit": _prixProduit,
                                "prospect": customer.prospect,
                                "status": 0
                              };
                              databaseReference.collection("clients").document(customer.key).updateData(dataClientUpdate);
                              databaseReference.collection("ventes").document(idVente).updateData(dataVenteUpdate);
                            }else{
                              var dataClient = {
                              "name": _name,
                              "city": _city,
                              "address": _address,
                              "prixProduit": _prixProduit,
                              "proscpect": this.userMail,
                              "status": 0
                              };
                              
                              DocumentReference c = await databaseReference.collection("clients").add(dataClient);

                              String id = c.documentID;

                              var dataVente = {
                                  "clientRef": "/clients/"+id,
                                  "prixProduit": _prixProduit,
                                  "prospect": this.userMail,
                                  "status": 0
                              };
                              
                              databaseReference.collection("ventes").add(dataVente);

                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              )
            ]
          )
        )
      )    
    );
  }
}

