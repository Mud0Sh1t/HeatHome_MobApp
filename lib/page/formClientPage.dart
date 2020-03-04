import 'dart:ui';
import 'package:HeatHome/page/homePage.dart';
import 'package:HeatHome/services/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormScreen extends StatelessWidget {

  final databaseReference = Firestore.instance;

  FormScreen({Key key, this.auth, this.userId, this.userMail, this.logoutCallback}): super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String userMail;

  final _formKey = GlobalKey<FormState>();

  String _name;
  String _city;
  String _address;
  String _prixProduit;
  
  @override
  Widget build(BuildContext context) {
    print(this.userMail);
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
                "Add a new customer",
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                      onSaved: (input) => _prixProduit = input,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            // Process data.
                            _formKey.currentState.save();
                            var dataClient = {
                              "name": _name,
                              "city": _city,
                              "address": _address,
                              "prixProduit": _prixProduit,
                              "proscpect": this.userMail,
                              "status": 0
                            };
                            var dataVente = {
                              "clientRef": _name,
                              "prixProduit": _prixProduit,
                              "prospect": this.userMail,
                              "status": 0
                            };
                            print(dataClient);
                            databaseReference.collection("clients").add(dataClient);
                            databaseReference.collection("ventes").add(dataVente);

                            return new HomePage(
                              userId: userId,
                              userMail: userMail,
                              auth: auth,
                              logoutCallback: logoutCallback,
                            );
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

